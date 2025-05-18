CREATE
OR REPLACE FUNCTION pull_changes (
  collections TEXT[],
  last_pulled_at TIMESTAMP WITH TIME ZONE
) RETURNS jsonb AS $$
DECLARE
    _result jsonb;
    _user_id uuid;
BEGIN
    SELECT auth.uid() into _user_id;
    RETURN jsonb_build_object(
        'timestamp', trunc(EXTRACT(epoch FROM now() AT TIME ZONE 'UTC') * 1000),
        'changes', jsonb_object_agg(
            col, jsonb_build_object(
                'created', funcs.pull_updates_created(_user_id, col, last_pulled_at),
                'updated', funcs.pull_updates_updated(_user_id, col, last_pulled_at),
                'deleted', funcs.pull_updates_deleted(_user_id, col, last_pulled_at)
            )
        )
    )::jsonb
    FROM UNNEST(collections) AS col;
END; $$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION funcs.pull_updates_deleted (
  _user_id UUID,
  _table_name TEXT,
  _last_pulled_at TIMESTAMP WITH TIME ZONE
) RETURNS jsonb AS $$
DECLARE
    _result jsonb;
    _schema_name TEXT;
    _table TEXT;
BEGIN
    -- Split the fully qualified table name into schema and table parts
    _schema_name := split_part(_table_name, '.', 1);
    _table := split_part(_table_name, '.', 2);

    -- Execute the query with schema and table name, but selecting only the IDs
    EXECUTE format(
        'SELECT jsonb_agg(src.id ORDER BY src.deleted_at, src.id::text) FROM %I.%I src WHERE src.user_id = $1 AND src.deleted_at IS NOT NULL AND src.deleted_at >= $2',
        _schema_name, _table
    ) INTO _result USING _user_id, _last_pulled_at;

    RETURN COALESCE(_result, '[]'::jsonb);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION funcs.pull_updates_updated (
  _user_id UUID,
  _table_name TEXT,
  _last_pulled_at TIMESTAMP WITH TIME ZONE
) RETURNS jsonb AS $$
DECLARE
    _result jsonb;
    _schema_name TEXT;
    _table TEXT;
BEGIN
    -- Split the fully qualified table name into schema and table parts
    _schema_name := split_part(_table_name, '.', 1);
    _table := split_part(_table_name, '.', 2);

    -- Execute the query with schema and table name
    EXECUTE format(
        'SELECT jsonb_agg(src ORDER BY server_updated_at, id::text) FROM %1$s src WHERE src.user_id = $1 AND src.deleted_at IS NULL AND src.server_updated_at >= $2',
        _table_name
    ) INTO _result USING _user_id, _last_pulled_at;

    RETURN COALESCE(_result, '[]'::jsonb);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION funcs.pull_updates_created (
  _user_id UUID,
  _table_name TEXT,
  _last_pulled_at TIMESTAMP WITH TIME ZONE
) RETURNS jsonb AS $$
DECLARE
    _result jsonb;
    _schema_name TEXT;
    _table TEXT;
BEGIN
    -- Split the fully qualified table name into schema and table parts
    _schema_name := split_part(_table_name, '.', 1);
    _table := split_part(_table_name, '.', 2);

    -- Debugging output
    RAISE LOG 'User ID: %, Table Name: %, Last Pulled At: %', _user_id, _table_name, _last_pulled_at;

    -- Execute the query with schema and table name
    EXECUTE format(
        'SELECT jsonb_agg(src ORDER BY server_created_at, id::text) FROM %I.%I src WHERE src.user_id = $1 AND src.deleted_at IS NULL AND src.server_created_at >= $2',
        _schema_name, _table
    ) INTO _result USING _user_id, _last_pulled_at;

    RETURN COALESCE(_result, '[]'::jsonb);
END;
$$ LANGUAGE plpgsql;