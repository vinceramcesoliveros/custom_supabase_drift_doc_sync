CREATE OR REPLACE FUNCTION construct_sql_for_collection(collection TEXT, cols TEXT, excl TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN format($f$
        INSERT INTO %1$s (user_id, server_created_at, %2$s)
        SELECT $1, $2, %2$s
        FROM jsonb_populate_recordset(null::%1$s, COALESCE((($3)->'%1$s')->'created', '[]') || COALESCE((($3)->'%1$s')->'updated', '[]'))
        ON CONFLICT (id) DO UPDATE SET (server_updated_at, %2$s) = ($2, %3$s)
    $f$, collection, cols, excl);
END;
$$ LANGUAGE plpgsql;


-- Function to retrieve columns and exclusions for the insert/update operation
CREATE OR REPLACE FUNCTION get_columns_and_exclusions(collection TEXT)
RETURNS TABLE(cols TEXT, excl TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT
        string_agg(quote_ident(attname), ',' ORDER BY attnum) AS cols,
        string_agg(format('excluded.%s', attname), ',' ORDER BY attnum) AS excl
    FROM pg_attribute att
    WHERE attrelid = to_regclass(collection)
    AND attnum > 0
    AND attname NOT IN ('user_id', 'server_created_at', 'server_updated_at', 'deleted_at')
    AND NOT attisdropped;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION construct_insert_update_sql(_updated_collections TEXT[], _changes JSONB)
RETURNS TEXT AS $$
DECLARE
    _sql TEXT := '';
    cols TEXT;
    excl TEXT;
    collection TEXT;  -- Declare the loop variable here
BEGIN
    FOREACH collection IN ARRAY _updated_collections
    LOOP
        -- Get columns and exclusions for the collection using an alias to avoid ambiguity
        SELECT gc.cols, gc.excl INTO cols, excl
        FROM get_columns_and_exclusions(collection) AS gc;

        -- Construct SQL for the collection
        _sql := _sql || construct_sql_for_collection(collection, cols, excl) || E'\n';
    END LOOP;

    RETURN _sql;
END;
$$ LANGUAGE plpgsql;

