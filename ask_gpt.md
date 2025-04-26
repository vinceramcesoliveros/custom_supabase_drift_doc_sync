db functions

```sql
CREATE
OR REPLACE FUNCTION funcs.pull_changes (
\_user_id UUID,
collections TEXT[],
last_pulled_at TIMESTAMP WITH TIME ZONE
) RETURNS jsonb AS $$
DECLARE
    _result jsonb;
BEGIN
    RETURN jsonb_build_object(
        'timestamp', trunc(EXTRACT(epoch FROM now() AT TIME ZONE 'UTC') * 1000),
        'changes', jsonb_object_agg(**>g**
            col, jsonb_build_object(
                'created', funcs.pull_updates_created(_user_id, col, last_pulled_at),
                'updated', funcs.pull_updates_updated(_user_id, col, last_pulled_at),
                'deleted', funcs.pull_updates_deleted(_user_id, col, last_pulled_at)
            )
        )
    )::jsonb
    FROM UNNEST(collections) AS col;
END; $$ LANGUAGE plpgsql;
```

```sql
-- Supabase AI is experimental and may produce incorrect answers
-- Always verify the output before executing

CREATE
OR REPLACE FUNCTION sync_changes (
  _changes JSONB,
  last_pulled_at TIMESTAMP WITH TIME ZONE
) RETURNS TIMESTAMP WITH TIME ZONE AS $$
DECLARE
    _updated_collections TEXT[];
    _purgatory BOOLEAN;
    _user_id UUID;
    _now_utc TIMESTAMP WITH TIME ZONE;
BEGIN
    -- GET USERID
    SELECT auth.uid() into _user_id;
    -- GET currentTime
    _now_utc = NOW();

    -- Look in all collections that include at least one created or updated element
    SELECT array_agg(key ORDER BY key)
    INTO _updated_collections
    FROM jsonb_each(_changes)
    WHERE (COALESCE(value->'created', '[]') <> '[]' OR COALESCE(value->'updated', '[]') <> '[]')
    AND to_regclass(format('public.%I', key)) IS NOT NULL;  -- ensure is a table in the public schema

    IF _updated_collections <> '{}' THEN
        -- Prevent updates or inserts out of sequence
        EXECUTE concat(
            'SELECT ', string_agg(format($f$
                EXISTS (
                    SELECT * FROM public.%I
                    WHERE user_id = $1
                    AND deleted_at IS NULL
                    -- AND server_updated_at <> $2 When they are equal and newer changes are saved in the db - but the older are pushed -> this will evaluate to false and this will result to false -> and so the older data will be inserted
                    AND server_updated_at > $3
                )$f$,
            collection), E'\n')
        )
        USING _user_id, _now_utc, last_pulled_at INTO _purgatory;

        IF _purgatory THEN
            RAISE EXCEPTION 'Record was updated remotely between pull and push';
        END IF;

        EXECUTE concat(
            'SELECT ', string_agg(format($f$
                EXISTS (
                    SELECT * FROM public.%I
                    WHERE user_id = $1
                    AND deleted_at IS NULL
                    -- AND server_created_at <> $2 -- the same reason as above
                    AND server_created_at > $3
                )$f$,
            collection), E'\n')
        )
        USING _user_id, _now_utc, last_pulled_at INTO _purgatory;

        IF _purgatory THEN
            RAISE EXCEPTION 'Record was created remotely between pull and push';
        END IF;

        EXECUTE string_agg(format($f$
            INSERT INTO public.%I (user_id, server_created_at, %2$s)
            SELECT $1, $2, %3$s
            FROM jsonb_populate_recordset(null::%I, COALESCE((($3)->%1$L)->'created', '[]') || COALESCE((($3)->%1$L)->'updated', '[]'))
            ON CONFLICT (id) DO UPDATE SET (server_updated_at, %2$s) = ($2, %3$s)
            WHERE excluded.user_id = $1;
        $f$, collection, cols, excl), E'\n')
        FROM (
            SELECT collection,
                   string_agg(quote_ident(attname), ',' ORDER BY attnum) AS cols,
                   string_agg(format('excluded.%I', attname), ',' ORDER BY attnum) AS excl
            FROM UNNEST(_updated_collections) collection
            JOIN pg_attribute att ON (attrelid = to_regclass(format('public.%I', collection)))
            WHERE attnum > 0
            AND attname NOT IN ('user_id', 'server_created_at', 'server_updated_at', 'deleted_at')  -- these are handled separately
            AND NOT attisdropped
            GROUP BY collection
            ORDER BY collection
        ) x
        USING _user_id, _now_utc, _changes;
    END IF;

    -- Delete all records with "deleted" values in one execution
    SELECT array_agg(key ORDER BY key)
    INTO _updated_collections
    FROM jsonb_each(_changes)
    WHERE COALESCE(value->'deleted', '[]') <> '[]'
    AND to_regclass(format('public.%I', key)) IS NOT NULL;  -- ensure is a table in the public schema

    IF _updated_collections <> '{}' THEN
        -- RAISE NOTICE 'del: %', _updated_collections;
        EXECUTE string_agg(format($f$
            UPDATE public.%I
            SET deleted_at = $2
            FROM jsonb_array_elements_text((($3)->%1$L)->'deleted') del
            WHERE user_id = $1
            AND id = del
            AND deleted_at IS NULL;
        $f$, collection), E'\n')
        FROM UNNEST(_updated_collections) collection
        USING _user_id, _now_utc, _changes;
    END IF;

    RETURN _now_utc;
END;
$$ LANGUAGE plpgsql;
```

```ts
import { SyncDatabaseChangeSet, synchronize } from "@nozbe/watermelondb/sync";

await synchronize({
  database,
  pullChanges: async ({ lastPulledAt, schemaVersion, migration }) => {
    const { data, error } = await supabase.rpc("pull", {
      last_pulled_at: lastPulledAt,
    });

    const { changes, timestamp } = data as {
      changes: SyncDatabaseChangeSet;
      timestamp: number;
    };

    return { changes, timestamp };
  },
  pushChanges: async ({ changes, lastPulledAt }) => {
    const { error } = await supabase.rpc("push", { changes });
  },
  sendCreatedAsUpdated: true,
});
```

```ts
import { RealtimeChannel } from "@supabase/supabase-js";
import { ReactNode, createContext, useEffect, useState } from "react";
import { AppState } from "react-native";
import { YStack, debounce } from "tamagui";

import { Loading } from "@/components/Loading";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/lib/supabase";
import { sync } from "@/lib/sync";
import { database } from "@/lib/watermelon";

function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export const SyncContext = createContext<{
  isSyncing: boolean;
  queueSync: ({
    reset,
    broadcast,
  }?: {
    reset?: boolean;
    broadcast?: boolean;
  }) => void;
  reset: () => void;
}>({
  isSyncing: false,
  queueSync: () => {},
  reset: () => {},
});

const syncDelay = 0;

export function SyncProvider({ children }: { children: ReactNode }) {
  const [isResetting, setIsResetting] = useState(false);
  const [isReadyToReset, setIsReadyToReset] = useState(false);
  const [isSyncing, setIsSyncing] = useState(false);
  const [isSyncQueued, setIsSyncQueued] = useState(false);
  const [channel, setChannel] = useState<RealtimeChannel>();
  const { user } = useAuth();

  useEffect(() => {
    queueSync();
  }, [user]);

  // Subscribe to broadcasts
  useEffect(() => {
    if (user) {
      const channel = supabase.channel(`sync-${user.id}`);
      const subscription = channel
        .on("broadcast", { event: "sync" }, (payload) => {
          console.log("Broadcast received", payload);
          queueSync();
        })
        .subscribe();

      console.log("Subscribed to broadcast", `sync-${user.id}`);

      setChannel(channel);

      return () => {
        subscription.unsubscribe();
        console.log("Unsubscribed from broadcast");
      };
    }
  }, [user]);

  // Send broadcast
  function sendBroadcast(payload: {
    type: "broadcast" | "presence" | "postgres_changes";
    event: string;
    payload?: any;
    [key: string]: any;
  }) {
    if (channel) {
      console.log("♻️ Sending broadcast");
      channel.send(payload).then((response) => {
        console.log("♻️ Broadcast sent", response);
      });
    }
  }

  // On initial load, queue sync and liste for app state changes
  useEffect(() => {
    console.log("Initial sync");
    queueSync();

    const subscription = AppState.addEventListener("change", () => {
      queueSync();
    });

    return () => {
      subscription.remove();
    };
  }, []);

  // Listen for db events as along as we're not resetting
  useEffect(() => {
    if (!isResetting) {
      const subscription = database
        .withChangesForTables(["stacks", "picks", "stars", "profiles"])
        .subscribe({
          next: (changes) => {
            const changedRecords = changes?.filter(
              (c) => c.record.syncStatus !== "synced"
            );

            if (changes?.length ?? changedRecords?.length) {
              console.log(
                "♻️ Database changes",
                changes?.length,
                changedRecords?.length
              );
            }

            if (changedRecords?.length) {
              const debouncedSync = debounce(() => queueSync(), syncDelay);
              debouncedSync();
            }
          },
          error: (error) => console.error("♻️ Database changes error", error),
        });

      console.log("♻️ Subscribed to database changes", {
        closed: subscription.closed,
      });

      return () => {
        subscription.unsubscribe();
        console.log("Unsubscribed from database changes");
      };
    }
  }, [database, isResetting]);

  function queueSync() {
    setIsSyncQueued(true);
    console.log("queueSync", { isSyncing, isSyncQueued });
  }

  /* useEffect(() => {
    if (!isSyncing && isSyncQueued) {
      sync()
        .then(() => {
          console.log("♻️ Sync succeeded");
          sendBroadcast({
            type: "broadcast",
            event: "sync",
          });
        })
        .catch((reason) => {
          console.log("♻️ Sync failed", reason);
        })
        .finally(() => {
          setIsSyncing(false);
        });
    }
  }, [isSyncing, isSyncQueued]); */

  // If not syncing but sync is queued, execute sync
  useEffect(() => {
    if (!isSyncing && isSyncQueued) {
      executeSync();
    }
  }, [isSyncing, isSyncQueued]);

  // To reset, set isResetting to true, which will unmount all screens and set isReadyToReset to true via onLayout
  function reset() {
    setIsResetting(true);
  }

  // If ready to reset and not syncing, execute sync
  useEffect(() => {
    if (isReadyToReset && !isSyncing) {
      console.log("Ready to reset");
      executeSync(true);
    }
  }, [isReadyToReset, isSyncing]);

  async function executeSync(reset?: boolean) {
    reset && setIsReadyToReset(false);
    setIsSyncQueued(false);
    setIsSyncing(true);
    // If this is a reset, delay sync call by one second to give the app time to umount all screens
    if (reset) {
      await delay(1000);
    }
    sync({ reset })
      .then(() => {
        console.log("♻️ Sync succeeded", { reset });
        sendBroadcast({
          type: "broadcast",
          event: "sync",
        });
      })
      .catch((reason) => {
        console.log("♻️ Sync failed", { reset, reason });
      })
      .finally(() => {
        setIsSyncing(false);
        reset && setIsResetting(false);
      });
  }

  return isResetting ? (
    <YStack
      fullscreen
      onLayout={() => {
        setIsReadyToReset(true);
      }}
    >
      <Loading message="Syncing" />
    </YStack>
  ) : (
    <SyncContext.Provider
      value={{
        isSyncing,
        queueSync,
        reset,
      }}
    >
      {children}
    </SyncContext.Provider>
  );
}
```

```ts
import { SyncDatabaseChangeSet, synchronize } from "@nozbe/watermelondb/sync";
// import SyncLogger from "@nozbe/watermelondb/sync/SyncLogger";
// const logger = new SyncLogger(10 /* limit of sync logs to keep in memory */);
// import { pullSyncChanges } from "native-sync";

import { supabase } from "./supabase";
import { database } from "./watermelon";

export async function sync({
  reset,
}: {
  reset?: boolean;
} = {}) {
  if (reset) {
    await database.write(async () => {
      await database.unsafeResetDatabase();
      console.log("✅ DB reset");
    });
  }

  await synchronize({
    database,
    pullChanges: async ({ lastPulledAt, schemaVersion, migration }) => {
      console.log("🍉 ⬇️ Pulling changes ...", { lastPulledAt });

      lastPulledAt = reset ?? !lastPulledAt ? undefined : lastPulledAt;

      const { data, error } = await supabase.rpc("pull", {
        last_pulled_at: lastPulledAt,
      });
      if (error) {
        throw new Error("🍉".concat(error.message));
      }

      const { changes, timestamp } = data as {
        changes: SyncDatabaseChangeSet;
        timestamp: number;
      };

      console.log(
        `🍉 Changes pulled at ${new Date(timestamp).toISOString()} UTC`
      );

      return { changes, timestamp };
    },
    pushChanges: async ({ changes, lastPulledAt }) => {
      console.log("🍉 ⬆️ Pushing changes ...");

      const { error } = await supabase.rpc("push", { changes });

      if (error) {
        throw new Error("🍉".concat(error.message));
      }

      console.log(`🍉 Changes pushed at ${new Date().toISOString()} UTC`);
    },
    unsafeTurbo: false,
    // migrationsEnabledAtVersion: 1,
    // log: logger.newLog(),
    sendCreatedAsUpdated: true,
  });
}
```

Also powersync can be a great example for inspiration. It is a library that syncs data between a local database and a remote server. And integrates with drift db.

|
Please write something simmular to how watermelondb synchronizes with a server Do it a abstractly so that it works for all selected classes. Use that i ma using drift for code generation and db You can maybe add someghing to codegen if it helps

I idea is that I sync my local data withe the server db based on timestamps. The solution needs to include synchronize function in simmular format;

Try to make it abstract and robust so that I can communicate with it though user interaface. Also use files in lib/models/generated_classes where are models from supabase with usefull methods on them.

Code generation can be also usefull.
