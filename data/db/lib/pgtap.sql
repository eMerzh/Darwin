-- This file defines pgTAP, a collection of functions for TAP-based unit
-- testing. It is distributed under the revised FreeBSD license. You can
-- find the original here:
--
-- $HeadURL: https://svn.kineticode.com/pgtap/trunk/pgtap.sql.in $
--
-- The home page for the pgTAP project is:
--
-- http://pgtap.projects.postgresql.org/

-- $Id: pgtap.sql.in 4549 2009-02-21 01:36:20Z david $
-- ## CREATE SCHEMA TAPSCHEMA;
-- ## SET search_path TO TAPSCHEMA, public;

--CREATE OR REPLACE FUNCTION pg_typeof("any")
--RETURNS regtype
--AS '$libdir/pgtap'
--LANGUAGE C STABLE;

CREATE OR REPLACE FUNCTION pg_version()
RETURNS text AS 'SELECT current_setting(''server_version'')'
LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION pg_version_num()
RETURNS integer AS $$
    SELECT s.a[1]::int * 10000
           + COALESCE(substring(s.a[2] FROM '[[:digit:]]+')::int, 0) * 100
           + COALESCE(substring(s.a[3] FROM '[[:digit:]]+')::int, 0)
      FROM (
          SELECT string_to_array(current_setting('server_version'), '.') AS a
      ) AS s;
$$ LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION os_name()
RETURNS TEXT AS 'SELECT ''linux''::text;'
LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION pgtap_version()
RETURNS NUMERIC AS 'SELECT 0.19;'
LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION plan( integer )
RETURNS TEXT AS $$
DECLARE
    rcount INTEGER;
    cmm    text := current_setting('client_min_messages');
BEGIN
    BEGIN
        PERFORM set_config('client_min_messages', 'warning', true);
        EXECUTE '
            CREATE TEMP TABLE __tcache__ (
                id    SERIAL           PRIMARY KEY,
                label TEXT    NOT NULL,
                value INTEGER NOT NULL,
                note  TEXT    NOT NULL DEFAULT ''''
            );
            GRANT ALL ON TABLE __tcache__ TO PUBLIC;

            CREATE TEMP TABLE __tresults__ (
                numb   SERIAL           PRIMARY KEY,
                ok     BOOLEAN NOT NULL DEFAULT TRUE,
                aok    BOOLEAN NOT NULL DEFAULT TRUE,
                descr  TEXT    NOT NULL DEFAULT '''',
                type   TEXT    NOT NULL DEFAULT '''',
                reason TEXT    NOT NULL DEFAULT ''''
            );
            GRANT ALL ON TABLE __tresults__ TO PUBLIC;
            GRANT ALL ON TABLE __tresults___numb_seq TO PUBLIC;
        ';

    EXCEPTION WHEN duplicate_table THEN
        PERFORM set_config('client_min_messages', cmm, true);
        -- Raise an exception if there's already a plan.
        EXECUTE 'SELECT TRUE FROM __tcache__ WHERE label = ''plan''';
      GET DIAGNOSTICS rcount = ROW_COUNT;
        IF rcount > 0 THEN
           RAISE EXCEPTION 'You tried to plan twice!';
        END IF;
    END;

    PERFORM set_config('client_min_messages', cmm, true);

    -- Save the plan and return.
    PERFORM _set('plan', $1 );
    RETURN '1..' || $1;
END;
$$ LANGUAGE plpgsql strict;

CREATE OR REPLACE FUNCTION no_plan()
RETURNS SETOF boolean AS $$
BEGIN
    PERFORM plan(0);
    RETURN;
END;
$$ LANGUAGE plpgsql strict;

CREATE OR REPLACE FUNCTION _get ( text )
RETURNS integer AS $$
DECLARE
    ret integer;
BEGIN
    EXECUTE 'SELECT value FROM __tcache__ WHERE label = ' || quote_literal($1) || ' LIMIT 1' INTO ret;
    RETURN ret;
END;
$$ LANGUAGE plpgsql strict;

CREATE OR REPLACE FUNCTION _get_latest ( text )
RETURNS integer[] AS $$
DECLARE
    ret integer[];
BEGIN
    EXECUTE 'SELECT ARRAY[ id, value] FROM __tcache__ WHERE label = ' ||
    quote_literal($1) || ' AND id = (SELECT MAX(id) FROM __tcache__ WHERE label = ' ||
    quote_literal($1) || ') LIMIT 1' INTO ret;
    RETURN ret;
END;
$$ LANGUAGE plpgsql strict;

CREATE OR REPLACE FUNCTION _get_latest ( text, integer )
RETURNS integer AS $$
DECLARE
    ret integer;
BEGIN
    EXECUTE 'SELECT MAX(id) FROM __tcache__ WHERE label = ' ||
    quote_literal($1) || ' AND value = ' || $2 INTO ret;
    RETURN ret;
END;
$$ LANGUAGE plpgsql strict;

CREATE OR REPLACE FUNCTION _get_note ( text )
RETURNS text AS $$
DECLARE
    ret text;
BEGIN
    EXECUTE 'SELECT note FROM __tcache__ WHERE label = ' || quote_literal($1) || ' LIMIT 1' INTO ret;
    RETURN ret;
END;
$$ LANGUAGE plpgsql strict;

CREATE OR REPLACE FUNCTION _get_note ( integer )
RETURNS text AS $$
DECLARE
    ret text;
BEGIN
    EXECUTE 'SELECT note FROM __tcache__ WHERE id = ' || $1 || ' LIMIT 1' INTO ret;
    RETURN ret;
END;
$$ LANGUAGE plpgsql strict;

CREATE OR REPLACE FUNCTION _set ( text, integer, text )
RETURNS integer AS $$
DECLARE
    rcount integer;
BEGIN
    EXECUTE 'UPDATE __tcache__ SET value = ' || $2
        || CASE WHEN $3 IS NULL THEN '' ELSE ', note = ' || quote_literal($3) END
        || ' WHERE label = ' || quote_literal($1);
    GET DIAGNOSTICS rcount = ROW_COUNT;
    IF rcount = 0 THEN
       RETURN _add( $1, $2, $3 );
    END IF;
    RETURN $2;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION _set ( text, integer )
RETURNS integer AS $$
    SELECT _set($1, $2, '')
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION _set ( integer, integer )
RETURNS integer AS $$
BEGIN
    EXECUTE 'UPDATE __tcache__ SET value = ' || $2
        || ' WHERE id = ' || $1;
    RETURN $2;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION _add ( text, integer, text )
RETURNS integer AS $$
BEGIN
    EXECUTE 'INSERT INTO __tcache__ (label, value, note) values (' ||
    quote_literal($1) || ', ' || $2 || ', ' || quote_literal(COALESCE($3, '')) || ')';
    RETURN $2;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION _add ( text, integer )
RETURNS integer AS $$
    SELECT _add($1, $2, '')
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION add_result ( bool, bool, text, text, text )
RETURNS integer AS $$
BEGIN
    EXECUTE 'INSERT INTO __tresults__ ( ok, aok, descr, type, reason )
    VALUES( ' || $1 || ', '
              || $2 || ', '
              || quote_literal(COALESCE($3, '')) || ', '
              || quote_literal($4) || ', '
              || quote_literal($5) || ' )';
    RETURN currval('__tresults___numb_seq');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION num_failed ()
RETURNS INTEGER AS $$
DECLARE
    ret integer;
BEGIN
    EXECUTE 'SELECT COUNT(*)::INTEGER FROM __tresults__ WHERE ok = FALSE' INTO ret;
    RETURN ret;
END;
$$ LANGUAGE plpgsql strict;

CREATE OR REPLACE FUNCTION _finish ( INTEGER, INTEGER, INTEGER)
RETURNS SETOF TEXT AS $$
DECLARE
    curr_test ALIAS FOR $1;
    exp_tests INTEGER := $2;
    num_faild ALIAS FOR $3;
    plural    CHAR;
BEGIN
    plural    := CASE exp_tests WHEN 1 THEN '' ELSE 's' END;

    IF curr_test IS NULL THEN
        RAISE EXCEPTION '# No tests run!';
    END IF;

    IF exp_tests = 0 OR exp_tests IS NULL THEN
         -- No plan. Output one now.
        exp_tests = curr_test;
        RETURN NEXT '1..' || exp_tests;
    END IF;

    IF curr_test <> exp_tests THEN
        RETURN NEXT diag(
            'Looks like you planned ' || exp_tests || ' test' ||
            plural || ' but ran ' || curr_test
        );
    ELSIF num_faild > 0 THEN
        RETURN NEXT diag(
            'Looks like you failed ' || num_faild || ' test' ||
            CASE num_faild WHEN 1 THEN '' ELSE 's' END
            || ' of ' || exp_tests
        );
    ELSE

    END IF;
    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION finish ()
RETURNS SETOF TEXT AS $$
    SELECT * FROM _finish(
        _get('curr_test'),
        _get('plan'),
        num_failed()
    );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION diag ( msg text )
RETURNS TEXT AS $$
    SELECT '# ' || replace(
       replace(
            replace( $1, E'\r\n', E'\n# ' ),
            E'\n',
            E'\n# '
        ),
        E'\r',
        E'\n# '
    );
$$ LANGUAGE sql strict;

CREATE OR REPLACE FUNCTION ok ( boolean, text )
RETURNS TEXT AS $$
DECLARE
   aok      ALIAS FOR $1;
   descr    text := $2;
   test_num INTEGER;
   todo_why TEXT;
   ok       BOOL;
BEGIN
   todo_why := _todo();
   ok       := CASE
       WHEN aok = TRUE THEN aok
       WHEN todo_why IS NULL THEN COALESCE(aok, false)
       ELSE TRUE
    END;
    IF _get('plan') IS NULL THEN
        RAISE EXCEPTION 'You tried to run a test without a plan! Gotta have a plan';
    END IF;

    test_num := add_result(
        ok,
        COALESCE(aok, false),
        descr,
        CASE WHEN todo_why IS NULL THEN '' ELSE 'todo' END,
        COALESCE(todo_why, '')
    );

    RETURN (CASE aok WHEN TRUE THEN '' ELSE 'not ' END)
           || 'ok ' || _set( 'curr_test', test_num )
           || CASE descr WHEN '' THEN '' ELSE COALESCE( ' - ' || substr(diag( descr ), 3), '' ) END
           || COALESCE( ' ' || diag( 'TODO ' || todo_why ), '')
           || CASE aok WHEN TRUE THEN '' ELSE E'\n' ||
                diag('Failed ' ||
                CASE WHEN todo_why IS NULL THEN '' ELSE '(TODO) ' END ||
                'test ' || test_num ||
                CASE descr WHEN '' THEN '' ELSE COALESCE(': "' || descr || '"', '') END ) ||
                CASE WHEN aok IS NULL THEN E'\n' || diag('    (test result was NULL)') ELSE '' END
           END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ok ( boolean )
RETURNS TEXT AS $$
    SELECT ok( $1, NULL );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION is (anyelement, anyelement, text)
RETURNS TEXT AS $$
DECLARE
    result BOOLEAN;
    output TEXT;
BEGIN
    -- Would prefer $1 IS NOT DISTINCT FROM, but that's not supported by 8.1.
    result := NOT $1 IS DISTINCT FROM $2;
    output := ok( result, $3 );
    RETURN output || CASE result WHEN TRUE THEN '' ELSE E'\n' || diag(
           '        have: ' || COALESCE( $1::text, 'NULL' ) ||
        E'\n        want: ' || COALESCE( $2::text, 'NULL' )
    ) END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is (anyelement, anyelement)
RETURNS TEXT AS $$
    SELECT is( $1, $2, NULL);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION isnt (anyelement, anyelement, text)
RETURNS TEXT AS $$
DECLARE
    result BOOLEAN;
    output TEXT;
BEGIN
    result := $1 IS DISTINCT FROM $2;
    output := ok( result, $3 );
    RETURN output || CASE result WHEN TRUE THEN '' ELSE E'\n' || diag(
           '    ' || COALESCE( $1::text, 'NULL' ) ||
        E'\n      <>' ||
        E'\n    ' || COALESCE( $2::text, 'NULL' )
    ) END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isnt (anyelement, anyelement)
RETURNS TEXT AS $$
    SELECT isnt( $1, $2, NULL);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION _alike ( BOOLEAN, ANYELEMENT, TEXT, TEXT )
RETURNS TEXT AS $$
DECLARE
    result ALIAS FOR $1;
    got    ALIAS FOR $2;
    rx     ALIAS FOR $3;
    descr  ALIAS FOR $4;
    output TEXT;
BEGIN
    output := ok( result, descr );
    RETURN output || CASE result WHEN TRUE THEN '' ELSE E'\n' || diag(
           '                  ' || COALESCE( quote_literal(got), 'NULL' ) ||
        E'\n   doesn''t match: ' || COALESCE( quote_literal(rx), 'NULL' )
    ) END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION matches ( anyelement, text, text )
RETURNS TEXT AS $$
    SELECT _alike( $1 ~ $2, $1, $2, $3 );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION matches ( anyelement, text )
RETURNS TEXT AS $$
    SELECT _alike( $1 ~ $2, $1, $2, NULL );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION imatches ( anyelement, text, text )
RETURNS TEXT AS $$
    SELECT _alike( $1 ~* $2, $1, $2, $3 );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION imatches ( anyelement, text )
RETURNS TEXT AS $$
    SELECT _alike( $1 ~* $2, $1, $2, NULL );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION alike ( anyelement, text, text )
RETURNS TEXT AS $$
    SELECT _alike( $1 ~~ $2, $1, $2, $3 );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION alike ( anyelement, text )
RETURNS TEXT AS $$
    SELECT _alike( $1 ~~ $2, $1, $2, NULL );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION ialike ( anyelement, text, text )
RETURNS TEXT AS $$
    SELECT _alike( $1 ~~* $2, $1, $2, $3 );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION ialike ( anyelement, text )
RETURNS TEXT AS $$
    SELECT _alike( $1 ~~* $2, $1, $2, NULL );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION _unalike ( BOOLEAN, ANYELEMENT, TEXT, TEXT )
RETURNS TEXT AS $$
DECLARE
    result ALIAS FOR $1;
    got    ALIAS FOR $2;
    rx     ALIAS FOR $3;
    descr  ALIAS FOR $4;
    output TEXT;
BEGIN
    output := ok( result, descr );
    RETURN output || CASE result WHEN TRUE THEN '' ELSE E'\n' || diag(
           '                  ' || COALESCE( quote_literal(got), 'NULL' ) ||
        E'\n         matches: ' || COALESCE( quote_literal(rx), 'NULL' )
    ) END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION doesnt_match ( anyelement, text, text )
RETURNS TEXT AS $$
    SELECT _unalike( $1 !~ $2, $1, $2, $3 );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION doesnt_match ( anyelement, text )
RETURNS TEXT AS $$
    SELECT _unalike( $1 !~ $2, $1, $2, NULL );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION doesnt_imatch ( anyelement, text, text )
RETURNS TEXT AS $$
    SELECT _unalike( $1 !~* $2, $1, $2, $3 );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION doesnt_imatch ( anyelement, text )
RETURNS TEXT AS $$
    SELECT _unalike( $1 !~* $2, $1, $2, NULL );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION unalike ( anyelement, text, text )
RETURNS TEXT AS $$
    SELECT _unalike( $1 !~~ $2, $1, $2, $3 );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION unalike ( anyelement, text )
RETURNS TEXT AS $$
    SELECT _unalike( $1 !~~ $2, $1, $2, NULL );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION unialike ( anyelement, text, text )
RETURNS TEXT AS $$
    SELECT _unalike( $1 !~~* $2, $1, $2, $3 );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION unialike ( anyelement, text )
RETURNS TEXT AS $$
    SELECT _unalike( $1 !~~* $2, $1, $2, NULL );
$$ LANGUAGE SQL;

--CREATE OR REPLACE FUNCTION cmp_ok (anyelement, text, anyelement, text)
--RETURNS TEXT AS $$
--DECLARE
--    have   ALIAS FOR $1;
--    op     ALIAS FOR $2;
--    want   ALIAS FOR $3;
--    descr  ALIAS FOR $4;
--    result BOOLEAN;
--    output TEXT;
--BEGIN
--    EXECUTE 'SELECT ' ||
--            COALESCE(quote_literal( have ), 'NULL') || '::' || pg_typeof(have) || ' '
--            || op || ' ' ||
--            COALESCE(quote_literal( want ), 'NULL') || '::' || pg_typeof(want)
--       INTO result;
--    output := ok( COALESCE(result, FALSE), descr );
--    RETURN output || CASE result WHEN TRUE THEN '' ELSE E'\n' || diag(
--           '    ' || COALESCE( quote_literal(have), 'NULL' ) ||
--           E'\n        ' || op ||
--           E'\n    ' || COALESCE( quote_literal(want), 'NULL' )
--    ) END;
--END;
--$$ LANGUAGE plpgsql;

--CREATE OR REPLACE FUNCTION cmp_ok (anyelement, text, anyelement)
--RETURNS TEXT AS $$
--    SELECT cmp_ok( $1, $2, $3, NULL );
--$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION pass ( text )
RETURNS TEXT AS $$
    SELECT ok( TRUE, $1 );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pass ()
RETURNS TEXT AS $$
    SELECT ok( TRUE, NULL );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION fail ( text )
RETURNS TEXT AS $$
    SELECT ok( FALSE, $1 );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION fail ()
RETURNS TEXT AS $$
    SELECT ok( FALSE, NULL );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION todo ( why text, how_many int )
RETURNS SETOF BOOLEAN AS $$
BEGIN
    PERFORM _add('todo', COALESCE(how_many, 1), COALESCE(why, ''));
    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION todo ( how_many int, why text )
RETURNS SETOF BOOLEAN AS $$
BEGIN
    PERFORM _add('todo', COALESCE(how_many, 1), COALESCE(why, ''));
    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION todo ( why text )
RETURNS SETOF BOOLEAN AS $$
BEGIN
    PERFORM _add('todo', 1, COALESCE(why, ''));
    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION todo ( how_many int )
RETURNS SETOF BOOLEAN AS $$
BEGIN
    PERFORM _add('todo', COALESCE(how_many, 1), '');
    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION todo_start (text)
RETURNS SETOF BOOLEAN AS $$
BEGIN
    PERFORM _add('todo', -1, COALESCE($1, ''));
    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION todo_start ()
RETURNS SETOF BOOLEAN AS $$
BEGIN
    PERFORM _add('todo', -1, '');
    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION in_todo ()
RETURNS BOOLEAN AS $$
DECLARE
    todos integer;
BEGIN
    todos := _get('todo');
    RETURN CASE WHEN todos IS NULL THEN FALSE ELSE TRUE END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION todo_end ()
RETURNS SETOF BOOLEAN AS $$
DECLARE
    id integer;
BEGIN
    id := _get_latest( 'todo', -1 );
    IF id IS NULL THEN
        RAISE EXCEPTION 'todo_end() called without todo_start()';
    END IF;
    EXECUTE 'DELETE FROM __tcache__ WHERE id = ' || id;
    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION _todo()
RETURNS TEXT AS $$
DECLARE
    todos INT[];
    note text;
BEGIN
    -- Get the latest id and value, because todo() might have been called
    -- again before the todos ran out for the first call to todo(). This
    -- allows them to nest.
    todos := _get_latest('todo');
    IF todos IS NULL THEN
        -- No todos.
        RETURN NULL;
    END IF;
    IF todos[2] = 0 THEN
        -- Todos depleted. Clean up.
        EXECUTE 'DELETE FROM __tcache__ WHERE id = ' || todos[1];
        RETURN NULL;
    END IF;
    -- Decrement the count of counted todos and return the reason.
    IF todos[2] <> -1 THEN
        PERFORM _set(todos[1], todos[2] - 1);
    END IF;
    note := _get_note(todos[1]);

    IF todos[2] = 1 THEN
        -- This was the last todo, so delete the record.
        EXECUTE 'DELETE FROM __tcache__ WHERE id = ' || todos[1];
    END IF;

    RETURN note;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION skip ( why text, how_many int )
RETURNS TEXT AS $$
DECLARE
    output TEXT[];
BEGIN
    output := '{}';
    FOR i IN 1..how_many LOOP
        output = array_append(output, ok( TRUE, 'SKIP: ' || COALESCE( why, '') ) );
    END LOOP;
    RETURN array_to_string(output, E'\n');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION skip ( text )
RETURNS TEXT AS $$
    SELECT ok( TRUE, 'SKIP: ' || $1 );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION skip( int, text )
RETURNS TEXT AS 'SELECT skip($2, $1)'
LANGUAGE sql;

CREATE OR REPLACE FUNCTION skip( int )
RETURNS TEXT AS 'SELECT skip(NULL, $1)'
LANGUAGE sql;

-- throws_ok ( sql, errcode, errmsg, description )
CREATE OR REPLACE FUNCTION throws_ok ( TEXT, CHAR(5), TEXT, TEXT )
RETURNS TEXT AS $$
DECLARE
    query     ALIAS FOR $1;
    errcode   ALIAS FOR $2;
    errmsg    ALIAS FOR $3;
    desctext  ALIAS FOR $4;
    descr     TEXT;
BEGIN
    descr := COALESCE(
          desctext,
          'threw ' || errcode || ': ' || errmsg,
          'threw ' || errcode,
          'threw ' || errmsg,
          'threw an exception'
    );
    EXECUTE query;
    RETURN ok( FALSE, descr ) || E'\n' || diag(
           '      caught: no exception' ||
        E'\n      wanted: ' || COALESCE( errcode, 'an exception' )
    );
EXCEPTION WHEN OTHERS THEN
    IF (errcode IS NULL OR SQLSTATE = errcode)
        AND ( errmsg IS NULL OR SQLERRM = errmsg)
    THEN
        -- The expected errcode and/or message was thrown.
        RETURN ok( TRUE, descr );
    ELSE
        -- This was not the expected errcodeor.
        RETURN ok( FALSE, descr ) || E'\n' || diag(
               '      caught: ' || SQLSTATE || ': ' || SQLERRM ||
            E'\n      wanted: ' || COALESCE( errcode, 'an exception' ) ||
            COALESCE( ': ' || errmsg, '')
        );
    END IF;
END;
$$ LANGUAGE plpgsql;

-- throws_ok ( query, errcode, errmsg )
-- throws_ok ( query, errmsg, description )
CREATE OR REPLACE FUNCTION throws_ok ( TEXT, TEXT, TEXT )
RETURNS TEXT AS $$
BEGIN
    IF octet_length($2) = 5 THEN
        RETURN throws_ok( $1, $2::char(5), $3, NULL );
    ELSE
        RETURN throws_ok( $1, NULL, $2, $3 );
    END IF;
END;
$$ LANGUAGE plpgsql;

-- throws_ok ( query, errcode )
-- throws_ok ( query, errmsg )
CREATE OR REPLACE FUNCTION throws_ok ( TEXT, TEXT )
RETURNS TEXT AS $$
BEGIN
    IF octet_length($2) = 5 THEN
        RETURN throws_ok( $1, $2::char(5), NULL, NULL );
    ELSE
        RETURN throws_ok( $1, NULL, $2, NULL );
    END IF;
END;
$$ LANGUAGE plpgsql;

-- throws_ok ( query )
CREATE OR REPLACE FUNCTION throws_ok ( TEXT )
RETURNS TEXT AS $$
    SELECT throws_ok( $1, NULL, NULL, NULL );
$$ LANGUAGE SQL;

-- Magically cast integer error codes.
-- throws_ok ( query, errcode, errmsg, description )
CREATE OR REPLACE FUNCTION throws_ok ( TEXT, int4, TEXT, TEXT )
RETURNS TEXT AS $$
    SELECT throws_ok( $1, $2::char(5), $3, $4 );
$$ LANGUAGE SQL;

-- throws_ok ( query, errcode, errmsg )
CREATE OR REPLACE FUNCTION throws_ok ( TEXT, int4, TEXT )
RETURNS TEXT AS $$
    SELECT throws_ok( $1, $2::char(5), $3, NULL );
$$ LANGUAGE SQL;

-- throws_ok ( query, errcode )
CREATE OR REPLACE FUNCTION throws_ok ( TEXT, int4 )
RETURNS TEXT AS $$
    SELECT throws_ok( $1, $2::char(5), NULL, NULL );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION lives_ok ( TEXT, TEXT )
RETURNS TEXT AS $$
DECLARE
    code  ALIAS FOR $1;
    descr ALIAS FOR $2;
BEGIN
    EXECUTE code;
    RETURN ok( TRUE, descr );
EXCEPTION WHEN OTHERS THEN
    -- There should have been no exception.
    RETURN ok( FALSE, descr ) || E'\n' || diag(
           '        died: ' || SQLSTATE || ': ' || SQLERRM
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION lives_ok ( TEXT )
RETURNS TEXT AS $$
    SELECT lives_ok( $1, NULL );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION _rexists ( CHAR, NAME, NAME )
RETURNS BOOLEAN AS $$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_namespace n
          JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
         WHERE c.relkind = $1
           AND n.nspname = $2
           AND c.relname = $3
    );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION _rexists ( CHAR, NAME )
RETURNS BOOLEAN AS $$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_class c
         WHERE c.relkind = $1
           AND pg_catalog.pg_table_is_visible(c.oid)
           AND c.relname = $2
    );
$$ LANGUAGE SQL;

-- has_table( schema, table, description )
CREATE OR REPLACE FUNCTION has_table ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _rexists( 'r', $1, $2 ), $3 );
$$ LANGUAGE SQL;

-- has_table( table, description )
CREATE OR REPLACE FUNCTION has_table ( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _rexists( 'r', $1 ), $2 );
$$ LANGUAGE SQL;

-- has_table( table )
CREATE OR REPLACE FUNCTION has_table ( NAME )
RETURNS TEXT AS $$
    SELECT has_table( $1, 'Table ' || quote_ident($1) || ' should exist' );
$$ LANGUAGE SQL;

-- hasnt_table( schema, table, description )
CREATE OR REPLACE FUNCTION hasnt_table ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _rexists( 'r', $1, $2 ), $3 );
$$ LANGUAGE SQL;

-- hasnt_table( table, description )
CREATE OR REPLACE FUNCTION hasnt_table ( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _rexists( 'r', $1 ), $2 );
$$ LANGUAGE SQL;

-- hasnt_table( table )
CREATE OR REPLACE FUNCTION hasnt_table ( NAME )
RETURNS TEXT AS $$
    SELECT hasnt_table( $1, 'Table ' || quote_ident($1) || ' should not exist' );
$$ LANGUAGE SQL;

-- has_view( schema, view, description )
CREATE OR REPLACE FUNCTION has_view ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _rexists( 'v', $1, $2 ), $3 );
$$ LANGUAGE SQL;

-- has_view( view, description )
CREATE OR REPLACE FUNCTION has_view ( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _rexists( 'v', $1 ), $2 );
$$ LANGUAGE SQL;

-- has_view( view )
CREATE OR REPLACE FUNCTION has_view ( NAME )
RETURNS TEXT AS $$
    SELECT has_view( $1, 'View ' || quote_ident($1) || ' should exist' );
$$ LANGUAGE SQL;

-- hasnt_view( schema, view, description )
CREATE OR REPLACE FUNCTION hasnt_view ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _rexists( 'v', $1, $2 ), $3 );
$$ LANGUAGE SQL;

-- hasnt_view( view, description )
CREATE OR REPLACE FUNCTION hasnt_view ( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _rexists( 'v', $1 ), $2 );
$$ LANGUAGE SQL;

-- hasnt_view( view )
CREATE OR REPLACE FUNCTION hasnt_view ( NAME )
RETURNS TEXT AS $$
    SELECT hasnt_view( $1, 'View ' || quote_ident($1) || ' should not exist' );
$$ LANGUAGE SQL;

-- has_sequence( schema, sequence, description )
CREATE OR REPLACE FUNCTION has_sequence ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _rexists( 'S', $1, $2 ), $3 );
$$ LANGUAGE SQL;

-- has_sequence( sequence, description )
CREATE OR REPLACE FUNCTION has_sequence ( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _rexists( 'S', $1 ), $2 );
$$ LANGUAGE SQL;

-- has_sequence( sequence )
CREATE OR REPLACE FUNCTION has_sequence ( NAME )
RETURNS TEXT AS $$
    SELECT has_sequence( $1, 'Sequence ' || quote_ident($1) || ' should exist' );
$$ LANGUAGE SQL;

-- hasnt_sequence( schema, sequence, description )
CREATE OR REPLACE FUNCTION hasnt_sequence ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _rexists( 'S', $1, $2 ), $3 );
$$ LANGUAGE SQL;

-- hasnt_sequence( sequence, description )
CREATE OR REPLACE FUNCTION hasnt_sequence ( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _rexists( 'S', $1 ), $2 );
$$ LANGUAGE SQL;

-- hasnt_sequence( sequence )
CREATE OR REPLACE FUNCTION hasnt_sequence ( NAME )
RETURNS TEXT AS $$
    SELECT hasnt_sequence( $1, 'Sequence ' || quote_ident($1) || ' should not exist' );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION _cexists ( NAME, NAME, NAME )
RETURNS BOOLEAN AS $$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_namespace n
          JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
          JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
         WHERE n.nspname = $1
           AND c.relname = $2
           AND a.attnum > 0
           AND NOT a.attisdropped
           AND a.attname = LOWER($3)
    );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION _cexists ( NAME, NAME )
RETURNS BOOLEAN AS $$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_class c
          JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
         WHERE c.relname = $1
           AND pg_catalog.pg_table_is_visible(c.oid)
           AND a.attnum > 0
           AND NOT a.attisdropped
           AND a.attname = LOWER($2)
    );
$$ LANGUAGE SQL;

-- has_column( schema, table, column, description )
CREATE OR REPLACE FUNCTION has_column ( NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _cexists( $1, $2, $3 ), $4 );
$$ LANGUAGE SQL;

-- has_column( table, column, description )
CREATE OR REPLACE FUNCTION has_column ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _cexists( $1, $2 ), $3 );
$$ LANGUAGE SQL;

-- has_column( table, column )
CREATE OR REPLACE FUNCTION has_column ( NAME, NAME )
RETURNS TEXT AS $$
    SELECT has_column( $1, $2, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should exist' );
$$ LANGUAGE SQL;

-- hasnt_column( schema, table, column, description )
CREATE OR REPLACE FUNCTION hasnt_column ( NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _cexists( $1, $2, $3 ), $4 );
$$ LANGUAGE SQL;

-- hasnt_column( table, column, description )
CREATE OR REPLACE FUNCTION hasnt_column ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _cexists( $1, $2 ), $3 );
$$ LANGUAGE SQL;

-- hasnt_column( table, column )
CREATE OR REPLACE FUNCTION hasnt_column ( NAME, NAME )
RETURNS TEXT AS $$
    SELECT hasnt_column( $1, $2, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should not exist' );
$$ LANGUAGE SQL;

-- _col_is_null( schema, table, column, desc, null )
CREATE OR REPLACE FUNCTION _col_is_null ( NAME, NAME, NAME, TEXT, bool )
RETURNS TEXT AS $$
BEGIN
    IF NOT _cexists( $1, $2, $3 ) THEN
        RETURN fail( $4 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3) || ' does not exist' );
    END IF;
    RETURN ok(
        EXISTS(
            SELECT true
              FROM pg_catalog.pg_namespace n, pg_catalog.pg_class c, pg_catalog.pg_attribute a
             WHERE n.oid = c.relnamespace
               AND c.oid = a.attrelid
               AND n.nspname = $1
               AND c.relname = $2
               AND a.attnum  > 0
               AND NOT a.attisdropped
               AND a.attname    = $3
               AND a.attnotnull = $5
        ), $4
    );
END;
$$ LANGUAGE plpgsql;

-- _col_is_null( table, column, desc, null )
CREATE OR REPLACE FUNCTION _col_is_null ( NAME, NAME, TEXT, bool )
RETURNS TEXT AS $$
BEGIN
    IF NOT _cexists( $1, $2 ) THEN
        RETURN fail( $3 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist' );
    END IF;
    RETURN ok(
        EXISTS(
            SELECT true
              FROM pg_catalog.pg_class c, pg_catalog.pg_attribute a
             WHERE c.oid = a.attrelid
               AND pg_catalog.pg_table_is_visible(c.oid)
               AND c.relname = $1
               AND a.attnum > 0
               AND NOT a.attisdropped
               AND a.attname    = $2
               AND a.attnotnull = $4
        ), $3
    );
END;
$$ LANGUAGE plpgsql;

-- col_not_null( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_not_null ( NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT _col_is_null( $1, $2, $3, $4, true );
$$ LANGUAGE SQL;

-- col_not_null( table, column, description )
CREATE OR REPLACE FUNCTION col_not_null ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT _col_is_null( $1, $2, $3, true );
$$ LANGUAGE SQL;

-- col_not_null( table, column )
CREATE OR REPLACE FUNCTION col_not_null ( NAME, NAME )
RETURNS TEXT AS $$
    SELECT _col_is_null( $1, $2, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should be NOT NULL', true );
$$ LANGUAGE SQL;

-- col_is_null( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_is_null ( NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT _col_is_null( $1, $2, $3, $4, false );
$$ LANGUAGE SQL;

-- col_is_null( schema, table, column )
CREATE OR REPLACE FUNCTION col_is_null ( NAME, NAME, NAME )
RETURNS TEXT AS $$
    SELECT _col_is_null( $1, $2, $3, false );
$$ LANGUAGE SQL;

-- col_is_null( table, column )
CREATE OR REPLACE FUNCTION col_is_null ( NAME, NAME )
RETURNS TEXT AS $$
    SELECT _col_is_null( $1, $2, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should allow NULL', false );
$$ LANGUAGE SQL;

-- col_type_is( schema, table, column, type, description )
CREATE OR REPLACE FUNCTION col_type_is ( NAME, NAME, NAME, TEXT, TEXT )
RETURNS TEXT AS $$
DECLARE
    actual_type TEXT;
BEGIN
    -- Get the data type.
    IF $1 IS NULL THEN
        IF NOT _cexists( $2, $3 ) THEN
            RETURN fail( $5 ) || E'\n'
            || diag ('   Column ' || quote_ident($2) || '.' || quote_ident($3) || ' does not exist' );
        END IF;

        SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) into actual_type
          FROM pg_catalog.pg_attribute a, pg_catalog.pg_class c
         WHERE a.attrelid = c.oid
           AND pg_table_is_visible(c.oid)
           AND CASE WHEN attisdropped THEN false ELSE pg_type_is_visible(a.atttypid) END
           AND c.relname = $2
           AND attnum > 0
           AND a.attname = $3;
    ELSE
        IF NOT _cexists( $1, $2, $3 ) THEN
            RETURN fail( $5 ) || E'\n'
            || diag ('   Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3) || ' does not exist' );
        END IF;

        SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) into actual_type
          FROM pg_catalog.pg_namespace n, pg_catalog.pg_class c, pg_catalog.pg_attribute a
         WHERE n.oid = c.relnamespace
           AND CASE WHEN attisdropped THEN false ELSE pg_type_is_visible(a.atttypid) END
           AND c.oid = a.attrelid
           AND n.nspname = $1
           AND c.relname = $2
           AND attnum > 0
           AND a.attname = $3;
    END IF;

    IF actual_type = LOWER($4) THEN
        -- We're good to go.
        RETURN ok( true, $5 );
    END IF;

    -- Wrong data type. tell 'em what we really got.
    RETURN ok( false, $5 ) || E'\n' || diag(
           '        have: ' || COALESCE( actual_type::text, 'NULL' ) ||
        E'\n        want: ' || $4::text
    );
END;
$$ LANGUAGE plpgsql;

-- col_type_is( table, column, type, description )
CREATE OR REPLACE FUNCTION col_type_is ( NAME, NAME, TEXT, TEXT )
RETURNS TEXT AS $$
    SELECT col_type_is( NULL, $1, $2, $3, $4 );
$$ LANGUAGE SQL;

-- col_type_is( table, column, type )
CREATE OR REPLACE FUNCTION col_type_is ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT col_type_is( $1, $2, $3, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should be type ' || $3 );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION _has_def ( NAME, NAME, NAME )
RETURNS boolean AS $$
    SELECT a.atthasdef
      FROM pg_catalog.pg_namespace n
      JOIN pg_catalog.pg_class c ON n.oid = c.relnamespace
      JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
     WHERE n.nspname = $1
       AND c.relname = $2
       AND a.attnum > 0
       AND NOT a.attisdropped
       AND a.attname = LOWER($3)
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _has_def ( NAME, NAME )
RETURNS boolean AS $$
    SELECT a.atthasdef
      FROM pg_catalog.pg_class c
      JOIN pg_catalog.pg_attribute a ON c.oid = a.attrelid
     WHERE c.relname = $1
       AND a.attnum > 0
       AND NOT a.attisdropped
       AND a.attname = LOWER($2)
$$ LANGUAGE sql;

-- col_has_default( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_has_default ( NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
BEGIN
    IF NOT _cexists( $1, $2, $3 ) THEN
        RETURN fail( $4 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3) || ' does not exist' );
    END IF;
    RETURN ok( _has_def( $1, $2, $3 ), $4 );
END
$$ LANGUAGE plpgsql;

-- col_has_default( table, column, description )
CREATE OR REPLACE FUNCTION col_has_default ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
BEGIN
    IF NOT _cexists( $1, $2 ) THEN
        RETURN fail( $3 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist' );
    END IF;
    RETURN ok( _has_def( $1, $2 ), $3 );
END;
$$ LANGUAGE plpgsql;

-- col_has_default( table, column )
CREATE OR REPLACE FUNCTION col_has_default ( NAME, NAME )
RETURNS TEXT AS $$
    SELECT col_has_default( $1, $2, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should have a default' );
$$ LANGUAGE SQL;

-- col_hasnt_default( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_hasnt_default ( NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
BEGIN
    IF NOT _cexists( $1, $2, $3 ) THEN
        RETURN fail( $4 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3) || ' does not exist' );
    END IF;
    RETURN ok( NOT _has_def( $1, $2, $3 ), $4 );
END;
$$ LANGUAGE plpgsql;

-- col_hasnt_default( table, column, description )
CREATE OR REPLACE FUNCTION col_hasnt_default ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
BEGIN
    IF NOT _cexists( $1, $2 ) THEN
        RETURN fail( $3 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist' );
    END IF;
    RETURN ok( NOT _has_def( $1, $2 ), $3 );
END;
$$ LANGUAGE plpgsql;

-- col_hasnt_default( table, column )
CREATE OR REPLACE FUNCTION col_hasnt_default ( NAME, NAME )
RETURNS TEXT AS $$
    SELECT col_hasnt_default( $1, $2, 'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should not have a default' );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION _def_is( TEXT, TEXT, anyelement, TEXT )
RETURNS TEXT AS $$
DECLARE
    thing text;
BEGIN
    IF $1 ~ '^[^'']+[(]' THEN
        -- It's a functional default.
        RETURN is( $1, $3, $4 );
    END IF;

    EXECUTE 'SELECT is(' 
             || COALESCE($1, 'NULL' || '::' || $2) || '::' || $2 || ', '
             || COALESCE(quote_literal($3), 'NULL') || '::' || $2 || ', '
             || COALESCE(quote_literal($4), 'NULL')
    || ')' INTO thing;
    RETURN thing;
END;
$$ LANGUAGE plpgsql;

-- _cdi( schema, table, column, default, description )
CREATE OR REPLACE FUNCTION _cdi ( NAME, NAME, NAME, anyelement, TEXT )
RETURNS TEXT AS $$
BEGIN
    IF NOT _cexists( $1, $2, $3 ) THEN
        RETURN fail( $5 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3) || ' does not exist' );
    END IF;

    IF NOT _has_def( $1, $2, $3 ) THEN
        RETURN fail( $5 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3) || ' has no default' );
    END IF;

    RETURN _def_is(
        pg_catalog.pg_get_expr(d.adbin, d.adrelid),
        pg_catalog.format_type(a.atttypid, a.atttypmod),
        $4, $5
    )
      FROM pg_catalog.pg_namespace n, pg_catalog.pg_class c, pg_catalog.pg_attribute a,
           pg_catalog.pg_attrdef d
     WHERE n.oid = c.relnamespace
       AND c.oid = a.attrelid
       AND a.atthasdef
       AND a.attrelid = d.adrelid
       AND a.attnum = d.adnum
       AND n.nspname = $1
       AND c.relname = $2
       AND a.attnum > 0
       AND NOT a.attisdropped
       AND a.attname = $3;
END;
$$ LANGUAGE plpgsql;

-- _cdi( table, column, default, description )
CREATE OR REPLACE FUNCTION _cdi ( NAME, NAME, anyelement, TEXT )
RETURNS TEXT AS $$
BEGIN
    IF NOT _cexists( $1, $2 ) THEN
        RETURN fail( $4 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || ' does not exist' );
    END IF;

    IF NOT _has_def( $1, $2 ) THEN
        RETURN fail( $4 ) || E'\n'
            || diag ('    Column ' || quote_ident($1) || '.' || quote_ident($2) || ' has no default' );
    END IF;

    RETURN _def_is(
        pg_catalog.pg_get_expr(d.adbin, d.adrelid),
        pg_catalog.format_type(a.atttypid, a.atttypmod),
        $3, $4
    )
      FROM pg_catalog.pg_class c, pg_catalog.pg_attribute a, pg_catalog.pg_attrdef d
     WHERE c.oid = a.attrelid
       AND pg_table_is_visible(c.oid)
       AND a.atthasdef
       AND a.attrelid = d.adrelid
       AND a.attnum = d.adnum
       AND c.relname = $1
       AND a.attnum > 0
       AND NOT a.attisdropped
       AND a.attname = $2;
END;
$$ LANGUAGE plpgsql;

-- _cdi( table, column, default )
CREATE OR REPLACE FUNCTION _cdi ( NAME, NAME, anyelement )
RETURNS TEXT AS $$
    SELECT col_default_is(
        $1, $2, $3,
        'Column ' || quote_ident($1) || '.' || quote_ident($2) || ' should default to ' 
        || COALESCE( quote_literal($3), 'NULL')
    );
$$ LANGUAGE sql;

-- col_default_is( schema, table, column, default, description )
CREATE OR REPLACE FUNCTION col_default_is ( NAME, NAME, NAME, anyelement, TEXT )
RETURNS TEXT AS $$
    SELECT _cdi( $1, $2, $3, $4, $5 );
$$ LANGUAGE sql;

-- col_default_is( schema, table, column, default, description )
CREATE OR REPLACE FUNCTION col_default_is ( NAME, NAME, NAME, TEXT, TEXT )
RETURNS TEXT AS $$
    SELECT _cdi( $1, $2, $3, $4, $5 );
$$ LANGUAGE sql;

-- col_default_is( table, column, default, description )
CREATE OR REPLACE FUNCTION col_default_is ( NAME, NAME, anyelement, TEXT )
RETURNS TEXT AS $$
    SELECT _cdi( $1, $2, $3, $4 );
$$ LANGUAGE sql;

-- col_default_is( table, column, default, description )
CREATE OR REPLACE FUNCTION col_default_is ( NAME, NAME, TEXT, TEXT )
RETURNS TEXT AS $$
    SELECT _cdi( $1, $2, $3, $4 );
$$ LANGUAGE sql;

-- col_default_is( table, column, default )
CREATE OR REPLACE FUNCTION col_default_is ( NAME, NAME, anyelement )
RETURNS TEXT AS $$
    SELECT _cdi( $1, $2, $3 );
$$ LANGUAGE sql;

-- col_default_is( table, column, default::text )
CREATE OR REPLACE FUNCTION col_default_is ( NAME, NAME, text )
RETURNS TEXT AS $$
    SELECT _cdi( $1, $2, $3 );
$$ LANGUAGE sql;

-- _hasc( schema, table, constraint_type )
CREATE OR REPLACE FUNCTION _hasc ( NAME, NAME, CHAR )
RETURNS BOOLEAN AS $$
    SELECT EXISTS(
            SELECT true
              FROM pg_catalog.pg_namespace n, pg_catalog.pg_class c,
                   pg_catalog.pg_constraint x
             WHERE n.oid = c.relnamespace
               AND c.oid = x.conrelid
               AND pg_table_is_visible(c.oid)
               AND c.relhaspkey = true
               AND n.nspname = $1
               AND c.relname = $2
               AND x.contype = $3
    );
$$ LANGUAGE sql;

-- _hasc( table, constraint_type )
CREATE OR REPLACE FUNCTION _hasc ( NAME, CHAR )
RETURNS BOOLEAN AS $$
    SELECT EXISTS(
            SELECT true
              FROM pg_catalog.pg_class c
              JOIN pg_catalog.pg_constraint x ON c.oid = x.conrelid
             WHERE c.relhaspkey = true
               AND c.relname = $1
               AND x.contype = $2
    );
$$ LANGUAGE sql;

-- has_pk( schema, table, description )
CREATE OR REPLACE FUNCTION has_pk ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _hasc( $1, $2, 'p' ), $3 );
$$ LANGUAGE sql;

-- has_pk( table, description )
CREATE OR REPLACE FUNCTION has_pk ( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _hasc( $1, 'p' ), $2 );
$$ LANGUAGE sql;

-- has_pk( table )
CREATE OR REPLACE FUNCTION has_pk ( NAME )
RETURNS TEXT AS $$
    SELECT has_pk( $1, 'Table ' || quote_ident($1) || ' should have a primary key' );
$$ LANGUAGE sql;

-- hasnt_pk( schema, table, description )
CREATE OR REPLACE FUNCTION hasnt_pk ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _hasc( $1, $2, 'p' ), $3 );
$$ LANGUAGE sql;

-- hasnt_pk( table, description )
CREATE OR REPLACE FUNCTION hasnt_pk ( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _hasc( $1, 'p' ), $2 );
$$ LANGUAGE sql;

-- hasnt_pk( table )
CREATE OR REPLACE FUNCTION hasnt_pk ( NAME )
RETURNS TEXT AS $$
    SELECT hasnt_pk( $1, 'Table ' || quote_ident($1) || ' should not have a primary key' );
$$ LANGUAGE sql;

-- _ckeys( schema, table, constraint_type )
CREATE OR REPLACE FUNCTION _ckeys ( NAME, NAME, CHAR )
RETURNS NAME[] AS $$
    SELECT ARRAY (
      SELECT a.attname
        FROM pg_catalog.pg_namespace n
        JOIN pg_catalog.pg_class c       ON n.oid = c.relnamespace
        JOIN pg_catalog.pg_attribute a   ON c.oid = a.attrelid
        JOIN pg_catalog.pg_constraint x  ON c.oid = x.conrelid AND a.attnum = ANY( x.conkey )
       WHERE n.nspname = $1
         AND c.relname = $2
         AND x.contype = $3
    );
$$ LANGUAGE sql;

-- _ckeys( table, constraint_type )
CREATE OR REPLACE FUNCTION _ckeys ( NAME, CHAR )
RETURNS NAME[] AS $$
    SELECT ARRAY (
      SELECT a.attname
        FROM pg_catalog.pg_class c
        JOIN pg_catalog.pg_attribute a   ON c.oid = a.attrelid
        JOIN pg_catalog.pg_constraint x  ON c.oid = x.conrelid AND a.attnum = ANY( x.conkey )
         AND c.relname = $1
         AND x.contype = $2
    );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _ident_array_to_string( name[], text )
RETURNS text AS $$
    SELECT array_to_string(ARRAY(
        SELECT quote_ident($1[i])
          FROM generate_series(1, array_upper($1, 1)) s(i)
         ORDER BY i
    ), $2);
$$ LANGUAGE SQL immutable;

-- Borrowed from newsysviews: http://pgfoundry.org/projects/newsysviews/
CREATE OR REPLACE FUNCTION _pg_sv_column_array( OID, SMALLINT[] )
RETURNS NAME[] AS $$
    SELECT ARRAY(
        SELECT a.attname
          FROM pg_catalog.pg_attribute a
          JOIN generate_series(1, 32) s(i) ON (a.attnum = $2[i])
         WHERE attrelid = $1
         ORDER BY i
    )
$$ LANGUAGE SQL stable;

-- Borrowed from newsysviews: http://pgfoundry.org/projects/newsysviews/
CREATE OR REPLACE FUNCTION _pg_sv_table_accessible( OID, OID )
RETURNS BOOLEAN AS $$
    SELECT CASE WHEN has_schema_privilege($1, 'USAGE') THEN (
                  has_table_privilege($2, 'SELECT')
               OR has_table_privilege($2, 'INSERT')
               or has_table_privilege($2, 'UPDATE')
               OR has_table_privilege($2, 'DELETE')
               OR has_table_privilege($2, 'RULE')
               OR has_table_privilege($2, 'REFERENCES')
               OR has_table_privilege($2, 'TRIGGER')
           ) ELSE FALSE
    END;
$$ LANGUAGE SQL immutable strict;

-- Borrowed from newsysviews: http://pgfoundry.org/projects/newsysviews/
CREATE OR REPLACE VIEW pg_all_foreign_keys
AS
  SELECT n1.nspname                                   AS fk_schema_name,
         c1.relname                                   AS fk_table_name,
         k1.conname                                   AS fk_constraint_name,
         c1.oid                                       AS fk_table_oid,
         _pg_sv_column_array(k1.conrelid,k1.conkey)   AS fk_columns,
         n2.nspname                                   AS pk_schema_name,
         c2.relname                                   AS pk_table_name,
         k2.conname                                   AS pk_constraint_name,
         c2.oid                                       AS pk_table_oid,
         ci.relname                                   AS pk_index_name,
         _pg_sv_column_array(k1.confrelid,k1.confkey) AS pk_columns,
         CASE k1.confmatchtype WHEN 'f' THEN 'FULL'
                               WHEN 'p' THEN 'PARTIAL'
                               WHEN 'u' THEN 'NONE'
                               else null
         END AS match_type,
         CASE k1.confdeltype WHEN 'a' THEN 'NO ACTION'
                             WHEN 'c' THEN 'CASCADE'
                             WHEN 'd' THEN 'SET DEFAULT'
                             WHEN 'n' THEN 'SET NULL'
                             WHEN 'r' THEN 'RESTRICT'
                             else null
         END AS on_delete,
         CASE k1.confupdtype WHEN 'a' THEN 'NO ACTION'
                             WHEN 'c' THEN 'CASCADE'
                             WHEN 'd' THEN 'SET DEFAULT'
                             WHEN 'n' THEN 'SET NULL'
                             WHEN 'r' THEN 'RESTRICT'
                             ELSE NULL
         END AS on_update,
         k1.condeferrable AS is_deferrable,
         k1.condeferred   AS is_deferred
    FROM pg_catalog.pg_constraint k1
    JOIN pg_catalog.pg_namespace n1 ON (n1.oid = k1.connamespace)
    JOIN pg_catalog.pg_class c1     ON (c1.oid = k1.conrelid)
    JOIN pg_catalog.pg_class c2     ON (c2.oid = k1.confrelid)
    JOIN pg_catalog.pg_namespace n2 ON (n2.oid = c2.relnamespace)
    JOIN pg_catalog.pg_depend d    ON (
                 d.classid = 'pg_constraint'::regclass
             AND d.objid = k1.oid
             AND d.objsubid = 0
             AND d.deptype = 'n'
             AND d.refclassid = 'pg_class'::regclass
             AND d.refobjsubid=0
         )
    JOIN pg_catalog.pg_class ci ON (ci.oid = d.refobjid AND ci.relkind = 'i')
    LEFT JOIN pg_depend d2 ON (
                 d2.classid = 'pg_class'::regclass
             AND d2.objid = ci.oid
             AND d2.objsubid = 0
             AND d2.deptype = 'i'
             AND d2.refclassid = 'pg_constraint'::regclass
             AND d2.refobjsubid = 0
         )
    LEFT JOIN pg_catalog.pg_constraint k2 ON (
                 k2.oid = d2.refobjid
             AND k2.contype IN ('p', 'u')
         )
   WHERE k1.conrelid != 0
     AND k1.confrelid != 0
     AND k1.contype = 'f'
     AND _pg_sv_table_accessible(n1.oid, c1.oid);

-- col_is_pk( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_is_pk ( NAME, NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT is( _ckeys( $1, $2, 'p' ), $3, $4 );
$$ LANGUAGE sql;

-- col_is_pk( table, column, description )
CREATE OR REPLACE FUNCTION col_is_pk ( NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT is( _ckeys( $1, 'p' ), $2, $3 );
$$ LANGUAGE sql;

-- col_is_pk( table, column[] )
CREATE OR REPLACE FUNCTION col_is_pk ( NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT col_is_pk( $1, $2, 'Columns ' || quote_ident($1) || '(' || _ident_array_to_string($2, ', ') || ') should be a primary key' );
$$ LANGUAGE sql;

-- col_is_pk( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_is_pk ( NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT col_is_pk( $1, $2, ARRAY[$3], $4 );
$$ LANGUAGE sql;

-- col_is_pk( table, column, description )
CREATE OR REPLACE FUNCTION col_is_pk ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT col_is_pk( $1, ARRAY[$2], $3 );
$$ LANGUAGE sql;

-- col_is_pk( table, column )
CREATE OR REPLACE FUNCTION col_is_pk ( NAME, NAME )
RETURNS TEXT AS $$
    SELECT col_is_pk( $1, $2, 'Column ' || quote_ident($1) || '(' || quote_ident($2) || ') should be a primary key' );
$$ LANGUAGE sql;

-- col_isnt_pk( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_isnt_pk ( NAME, NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT isnt( _ckeys( $1, $2, 'p' ), $3, $4 );
$$ LANGUAGE sql;

-- col_isnt_pk( table, column, description )
CREATE OR REPLACE FUNCTION col_isnt_pk ( NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT isnt( _ckeys( $1, 'p' ), $2, $3 );
$$ LANGUAGE sql;

-- col_isnt_pk( table, column[] )
CREATE OR REPLACE FUNCTION col_isnt_pk ( NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT col_isnt_pk( $1, $2, 'Columns ' || quote_ident($1) || '(' || _ident_array_to_string($2, ', ') || ') should not be a primary key' );
$$ LANGUAGE sql;

-- col_isnt_pk( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_isnt_pk ( NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT col_isnt_pk( $1, $2, ARRAY[$3], $4 );
$$ LANGUAGE sql;

-- col_isnt_pk( table, column, description )
CREATE OR REPLACE FUNCTION col_isnt_pk ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT col_isnt_pk( $1, ARRAY[$2], $3 );
$$ LANGUAGE sql;

-- col_isnt_pk( table, column )
CREATE OR REPLACE FUNCTION col_isnt_pk ( NAME, NAME )
RETURNS TEXT AS $$
    SELECT col_isnt_pk( $1, $2, 'Column ' || quote_ident($1) || '(' || quote_ident($2) || ') should not be a primary key' );
$$ LANGUAGE sql;

-- has_fk( schema, table, description )
CREATE OR REPLACE FUNCTION has_fk ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _hasc( $1, $2, 'f' ), $3 );
$$ LANGUAGE sql;

-- has_fk( table, description )
CREATE OR REPLACE FUNCTION has_fk ( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _hasc( $1, 'f' ), $2 );
$$ LANGUAGE sql;

-- has_fk( table )
CREATE OR REPLACE FUNCTION has_fk ( NAME )
RETURNS TEXT AS $$
    SELECT has_fk( $1, 'Table ' || quote_ident($1) || ' should have a foreign key constraint' );
$$ LANGUAGE sql;

-- hasnt_fk( schema, table, description )
CREATE OR REPLACE FUNCTION hasnt_fk ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _hasc( $1, $2, 'f' ), $3 );
$$ LANGUAGE sql;

-- hasnt_fk( table, description )
CREATE OR REPLACE FUNCTION hasnt_fk ( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _hasc( $1, 'f' ), $2 );
$$ LANGUAGE sql;

-- hasnt_fk( table )
CREATE OR REPLACE FUNCTION hasnt_fk ( NAME )
RETURNS TEXT AS $$
    SELECT hasnt_fk( $1, 'Table ' || quote_ident($1) || ' should not have a foreign key constraint' );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _fkexists ( NAME, NAME, NAME[] )
RETURNS BOOLEAN AS $$
    SELECT EXISTS(
        SELECT TRUE
           FROM pg_all_foreign_keys
          WHERE fk_schema_name    = $1
            AND quote_ident(fk_table_name)     = quote_ident($2)
            AND fk_columns = $3
    );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION _fkexists ( NAME, NAME[] )
RETURNS BOOLEAN AS $$
    SELECT EXISTS(
        SELECT TRUE
           FROM pg_all_foreign_keys
          WHERE quote_ident(fk_table_name)     = quote_ident($1)
            AND fk_columns = $2
    );
$$ LANGUAGE SQL;

-- col_is_fk( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_is_fk ( NAME, NAME, NAME[], TEXT )
RETURNS TEXT AS $$
DECLARE
    names text[];
BEGIN
    IF _fkexists($1, $2, $3) THEN
        RETURN pass( $4 );
    END IF;

    -- Try to show the columns.
    SELECT ARRAY(
        SELECT _ident_array_to_string(fk_columns, ', ')
          FROM pg_all_foreign_keys
         WHERE fk_schema_name = $1
           AND fk_table_name  = $2
         ORDER BY fk_columns
    ) INTO names;

    IF NAMES[1] IS NOT NULL THEN
        RETURN fail($4) || E'\n' || diag(
            '    Table ' || quote_ident($1) || '.' || quote_ident($2) || E' has foreign key constraints on these columns:\n        '
            ||  array_to_string( names, E'\n        ' )
        );
    END IF;

    -- No FKs in this table.
    RETURN fail($4) || E'\n' || diag(
        '    Table ' || quote_ident($1) || '.' || quote_ident($2) || ' has no foreign key columns'
    );
END;
$$ LANGUAGE plpgsql;

-- col_is_fk( table, column, description )
CREATE OR REPLACE FUNCTION col_is_fk ( NAME, NAME[], TEXT )
RETURNS TEXT AS $$
DECLARE
    names text[];
BEGIN
    IF _fkexists($1, $2) THEN
        RETURN pass( $3 );
    END IF;

    -- Try to show the columns.
    SELECT ARRAY(
        SELECT _ident_array_to_string(fk_columns, ', ')
          FROM pg_all_foreign_keys
         WHERE fk_table_name  = $1
         ORDER BY fk_columns
    ) INTO names;

    IF NAMES[1] IS NOT NULL THEN
        RETURN fail($3) || E'\n' || diag(
            '    Table ' || quote_ident($1) || E' has foreign key constraints on these columns:\n        '
            || array_to_string( names, E'\n        ' )
        );
    END IF;

    -- No FKs in this table.
    RETURN fail($3) || E'\n' || diag(
        '    Table ' || quote_ident($1) || ' has no foreign key columns'
    );
END;
$$ LANGUAGE plpgsql;

-- col_is_fk( table, column[] )
CREATE OR REPLACE FUNCTION col_is_fk ( NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT col_is_fk( $1, $2, 'Columns ' || quote_ident($1) || '(' || _ident_array_to_string($2, ', ') || ') should be a foreign key' );
$$ LANGUAGE sql;

-- col_is_fk( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_is_fk ( NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT col_is_fk( $1, $2, ARRAY[$3], $4 );
$$ LANGUAGE sql;

-- col_is_fk( table, column, description )
CREATE OR REPLACE FUNCTION col_is_fk ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT col_is_fk( $1, ARRAY[$2], $3 );
$$ LANGUAGE sql;

-- col_is_fk( table, column )
CREATE OR REPLACE FUNCTION col_is_fk ( NAME, NAME )
RETURNS TEXT AS $$
    SELECT col_is_fk( $1, $2, 'Column ' || quote_ident($1) || '(' || quote_ident($2) || ') should be a foreign key' );
$$ LANGUAGE sql;

-- col_isnt_fk( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_isnt_fk ( NAME, NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _fkexists( $1, $2, $3 ), $4 );
$$ LANGUAGE SQL;

-- col_isnt_fk( table, column, description )
CREATE OR REPLACE FUNCTION col_isnt_fk ( NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _fkexists( $1, $2 ), $3 );
$$ LANGUAGE SQL;

-- col_isnt_fk( table, column[] )
CREATE OR REPLACE FUNCTION col_isnt_fk ( NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT col_isnt_fk( $1, $2, 'Columns ' || quote_ident($1) || '(' || _ident_array_to_string($2, ', ') || ') should not be a foreign key' );
$$ LANGUAGE sql;

-- col_isnt_fk( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_isnt_fk ( NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT col_isnt_fk( $1, $2, ARRAY[$3], $4 );
$$ LANGUAGE sql;

-- col_isnt_fk( table, column, description )
CREATE OR REPLACE FUNCTION col_isnt_fk ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT col_isnt_fk( $1, ARRAY[$2], $3 );
$$ LANGUAGE sql;

-- col_isnt_fk( table, column )
CREATE OR REPLACE FUNCTION col_isnt_fk ( NAME, NAME )
RETURNS TEXT AS $$
    SELECT col_isnt_fk( $1, $2, 'Column ' || quote_ident($1) || '(' || quote_ident($2) || ') should not be a foreign key' );
$$ LANGUAGE sql;

-- has_unique( schema, table, description )
CREATE OR REPLACE FUNCTION has_unique ( TEXT, TEXT, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _hasc( $1, $2, 'u' ), $3 );
$$ LANGUAGE sql;

-- has_unique( table, description )
CREATE OR REPLACE FUNCTION has_unique ( TEXT, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _hasc( $1, 'u' ), $2 );
$$ LANGUAGE sql;

-- has_unique( table )
CREATE OR REPLACE FUNCTION has_unique ( TEXT )
RETURNS TEXT AS $$
    SELECT has_unique( $1, 'Table ' || quote_ident($1) || ' should have a unique constraint' );
$$ LANGUAGE sql;

-- col_is_unique( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_is_unique ( NAME, NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT is( _ckeys( $1, $2, 'u' ), $3, $4 );
$$ LANGUAGE sql;

-- col_is_unique( table, column, description )
CREATE OR REPLACE FUNCTION col_is_unique ( NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT is( _ckeys( $1, 'u' ), $2, $3 );
$$ LANGUAGE sql;

-- col_is_unique( table, column[] )
CREATE OR REPLACE FUNCTION col_is_unique ( NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT col_is_unique( $1, $2, 'Columns ' || quote_ident($1) || '(' || _ident_array_to_string($2, ', ') || ') should have a unique constraint' );
$$ LANGUAGE sql;

-- col_is_unique( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_is_unique ( NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT col_is_unique( $1, $2, ARRAY[$3], $4 );
$$ LANGUAGE sql;

-- col_is_unique( table, column, description )
CREATE OR REPLACE FUNCTION col_is_unique ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT col_is_unique( $1, ARRAY[$2], $3 );
$$ LANGUAGE sql;

-- col_is_unique( table, column )
CREATE OR REPLACE FUNCTION col_is_unique ( NAME, NAME )
RETURNS TEXT AS $$
    SELECT col_is_unique( $1, $2, 'Column ' || quote_ident($1) || '(' || quote_ident($2) || ') should have a unique constraint' );
$$ LANGUAGE sql;

-- has_check( schema, table, description )
CREATE OR REPLACE FUNCTION has_check ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _hasc( $1, $2, 'c' ), $3 );
$$ LANGUAGE sql;

-- has_check( table, description )
CREATE OR REPLACE FUNCTION has_check ( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _hasc( $1, 'c' ), $2 );
$$ LANGUAGE sql;

-- has_check( table )
CREATE OR REPLACE FUNCTION has_check ( NAME )
RETURNS TEXT AS $$
    SELECT has_check( $1, 'Table ' || quote_ident($1) || ' should have a check constraint' );
$$ LANGUAGE sql;

-- col_has_check( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_has_check ( NAME, NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT is( _ckeys( $1, $2, 'c' ), $3, $4 );
$$ LANGUAGE sql;

-- col_has_check( table, column, description )
CREATE OR REPLACE FUNCTION col_has_check ( NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT is( _ckeys( $1, 'c' ), $2, $3 );
$$ LANGUAGE sql;

-- col_has_check( table, column[] )
CREATE OR REPLACE FUNCTION col_has_check ( NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT col_has_check( $1, $2, 'Columns ' || quote_ident($1) || '(' || _ident_array_to_string($2, ', ') || ') should have a check constraint' );
$$ LANGUAGE sql;

-- col_has_check( schema, table, column, description )
CREATE OR REPLACE FUNCTION col_has_check ( NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT col_has_check( $1, $2, ARRAY[$3], $4 );
$$ LANGUAGE sql;

-- col_has_check( table, column, description )
CREATE OR REPLACE FUNCTION col_has_check ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT col_has_check( $1, ARRAY[$2], $3 );
$$ LANGUAGE sql;

-- col_has_check( table, column )
CREATE OR REPLACE FUNCTION col_has_check ( NAME, NAME )
RETURNS TEXT AS $$
    SELECT col_has_check( $1, $2, 'Column ' || quote_ident($1) || '(' || quote_ident($2) || ') should have a check constraint' );
$$ LANGUAGE sql;

-- fk_ok( fk_schema, fk_table, fk_column[], pk_schema, pk_table, pk_column[], description )
CREATE OR REPLACE FUNCTION fk_ok ( NAME, NAME, NAME[], NAME, NAME, NAME[], TEXT )
RETURNS TEXT AS $$
DECLARE
    sch  name;
    tab  name;
    cols name[];
BEGIN
    SELECT pk_schema_name, pk_table_name, pk_columns
      FROM pg_all_foreign_keys
      WHERE fk_schema_name = $1
        AND fk_table_name  = $2
        AND fk_columns     = $3
      INTO sch, tab, cols;

    RETURN is(
        -- have
        quote_ident($1) || '.' || quote_ident($2) || '(' || _ident_array_to_string( $3, ', ' )
        || ') REFERENCES ' || COALESCE ( sch || '.' || tab || '(' || _ident_array_to_string( cols, ', ' ) || ')', 'NOTHING' ),
        -- want
        quote_ident($1) || '.' || quote_ident($2) || '(' || _ident_array_to_string( $3, ', ' )
        || ') REFERENCES ' ||
        $4 || '.' || $5 || '(' || _ident_array_to_string( $6, ', ' ) || ')',
        $7
    );
END;
$$ LANGUAGE plpgsql;

-- fk_ok( fk_table, fk_column[], pk_table, pk_column[], description )
CREATE OR REPLACE FUNCTION fk_ok ( NAME, NAME[], NAME, NAME[], TEXT )
RETURNS TEXT AS $$
DECLARE
    tab  name;
    cols name[];
BEGIN
    SELECT pk_table_name, pk_columns
      FROM pg_all_foreign_keys
      WHERE fk_table_name = $1
        AND fk_columns    = $2
      INTO tab, cols;

    RETURN is(
        -- have
        $1 || '(' || _ident_array_to_string( $2, ', ' )
        || ') REFERENCES ' || COALESCE( tab || '(' || _ident_array_to_string( cols, ', ' ) || ')', 'NOTHING'),
        -- want
        $1 || '(' || _ident_array_to_string( $2, ', ' )
        || ') REFERENCES ' ||
        $3 || '(' || _ident_array_to_string( $4, ', ' ) || ')',
        $5
    );
END;
$$ LANGUAGE plpgsql;

-- fk_ok( fk_schema, fk_table, fk_column[], fk_schema, pk_table, pk_column[] )
CREATE OR REPLACE FUNCTION fk_ok ( NAME, NAME, NAME[], NAME, NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT fk_ok( $1, $2, $3, $4, $5, $6,
        quote_ident($1) || '.' || quote_ident($2) || '(' || _ident_array_to_string( $3, ', ' )
        || ') should reference ' ||
        $4 || '.' || $5 || '(' || _ident_array_to_string( $6, ', ' ) || ')'
    );
$$ LANGUAGE sql;

-- fk_ok( fk_table, fk_column[], pk_table, pk_column[] )
CREATE OR REPLACE FUNCTION fk_ok ( NAME, NAME[], NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT fk_ok( $1, $2, $3, $4,
        $1 || '(' || _ident_array_to_string( $2, ', ' )
        || ') should reference ' ||
        $3 || '(' || _ident_array_to_string( $4, ', ' ) || ')'
    );
$$ LANGUAGE sql;

-- fk_ok( fk_schema, fk_table, fk_column, pk_schema, pk_table, pk_column, description )
CREATE OR REPLACE FUNCTION fk_ok ( NAME, NAME, NAME, NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT fk_ok( $1, $2, ARRAY[$3], $4, $5, ARRAY[$6], $7 );
$$ LANGUAGE sql;

-- fk_ok( fk_schema, fk_table, fk_column, pk_schema, pk_table, pk_column )
CREATE OR REPLACE FUNCTION fk_ok ( NAME, NAME, NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT fk_ok( $1, $2, ARRAY[$3], $4, $5, ARRAY[$6] );
$$ LANGUAGE sql;

-- fk_ok( fk_table, fk_column, pk_table, pk_column, description )
CREATE OR REPLACE FUNCTION fk_ok ( NAME, NAME, NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT fk_ok( $1, ARRAY[$2], $3, ARRAY[$4], $5 );
$$ LANGUAGE sql;

-- fk_ok( fk_table, fk_column, pk_table, pk_column )
CREATE OR REPLACE FUNCTION fk_ok ( NAME, NAME, NAME, NAME )
RETURNS TEXT AS $$
    SELECT fk_ok( $1, ARRAY[$2], $3, ARRAY[$4] );
$$ LANGUAGE sql;

-- can_ok( schema, func_name, args[], description )
CREATE OR REPLACE FUNCTION can_ok ( NAME, NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT ok(
        EXISTS(
            SELECT true
              FROM pg_catalog.pg_proc p
              JOIN pg_catalog.pg_namespace n ON p.pronamespace = n.oid
             WHERE n.nspname = $1
               AND p.proname = $2
               AND array_to_string(p.proargtypes::regtype[], ',') = array_to_string($3, ',')
        ), $4
    );
$$ LANGUAGE SQL;

-- can_ok( schema, func_name, args[] )
CREATE OR REPLACE FUNCTION can_ok( NAME, NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT can_ok( $1, $2, $3, 'Function ' || quote_ident($1) || '.' || quote_ident($2) || '(' ||
    array_to_string($3, ', ') || ') should exist' );
$$ LANGUAGE sql;

-- can_ok( schema, func_name, description )
CREATE OR REPLACE FUNCTION can_ok ( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok(
        EXISTS(
            SELECT true
              FROM pg_catalog.pg_proc p
              JOIN pg_catalog.pg_namespace n ON p.pronamespace = n.oid
             WHERE n.nspname = $1
               AND p.proname = $2
        ), $3
    );
$$ LANGUAGE SQL;

-- can_ok( schema, func_name )
CREATE OR REPLACE FUNCTION can_ok( NAME, NAME )
RETURNS TEXT AS $$
    SELECT can_ok( $1, $2, 'Function ' || quote_ident($1) || '.' || quote_ident($2) || '() should exist' );
$$ LANGUAGE sql;

-- can_ok( func_name, args[], description )
CREATE OR REPLACE FUNCTION can_ok ( NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT ok(
        EXISTS(
            SELECT true
              FROM pg_catalog.pg_proc p
             WHERE p.proname = $1
               AND pg_catalog.pg_function_is_visible(p.oid)
               AND array_to_string(p.proargtypes::regtype[], ',') = array_to_string($2, ',')
        ), $3
    );
$$ LANGUAGE SQL;

-- can_ok( func_name, args[] )
CREATE OR REPLACE FUNCTION can_ok( NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT can_ok( $1, $2, 'Function ' || quote_ident($1) || '(' ||
    array_to_string($2, ', ') || ') should exist' );
$$ LANGUAGE sql;

-- can_ok( func_name, description )
CREATE OR REPLACE FUNCTION can_ok( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok(
        EXISTS(
            SELECT true
              FROM pg_catalog.pg_proc p
             WHERE p.proname = $1
               AND pg_catalog.pg_function_is_visible(p.oid)
        ), $2
    );
$$ LANGUAGE sql;

-- can_ok( func_name )
CREATE OR REPLACE FUNCTION can_ok( NAME )
RETURNS TEXT AS $$
    SELECT can_ok( $1, 'Function ' || quote_ident($1) || '() should exist' );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _pg_sv_type_array( OID[] )
RETURNS NAME[] AS $$
    SELECT ARRAY(
        SELECT t.typname
          FROM pg_catalog.pg_type t
          JOIN generate_series(1, array_upper($1, 1)) s(i) ON (t.oid = $1[i])
         ORDER BY i
    )
$$ LANGUAGE SQL stable;

-- can( schema, func_names[], description )
CREATE OR REPLACE FUNCTION can ( NAME, NAME[], TEXT )
RETURNS TEXT AS $$
DECLARE
    missing text[];
BEGIN
    SELECT ARRAY(
        SELECT quote_ident($2[i])
          FROM generate_series(1, array_upper($2, 1)) s(i)
          LEFT JOIN pg_catalog.pg_proc p
            ON p.proname = $2[i]
           AND p.pronamespace = (
                   SELECT oid
                     FROM pg_catalog.pg_namespace
                    WHERE nspname = $1
         )
         WHERE p.oid IS NULL
         GROUP BY $2[i], s.i
         ORDER BY MIN(s.i)
    ) INTO missing;
    IF missing[1] IS NULL THEN
        RETURN ok( true, $3 );
    END IF;
    RETURN ok( false, $3 ) || E'\n' || diag(
        '    ' || quote_ident($1) || '.' ||
        array_to_string( missing, E'() missing\n    ' || quote_ident($1) || '.') ||
        '() missing'
    );
END;
$$ LANGUAGE plpgsql;

-- can( schema, func_names[] )
CREATE OR REPLACE FUNCTION can ( NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT can( $1, $2, 'Schema ' || quote_ident($1) || ' can' );
$$ LANGUAGE sql;

-- can( func_names[], description )
CREATE OR REPLACE FUNCTION can ( NAME[], TEXT )
RETURNS TEXT AS $$
DECLARE
    missing text[];
BEGIN
    SELECT ARRAY(
        SELECT quote_ident($1[i])
          FROM generate_series(1, array_upper($1, 1)) s(i)
          LEFT JOIN pg_catalog.pg_proc p
            ON $1[i] = p.proname
           AND pg_catalog.pg_function_is_visible(p.oid)
         WHERE p.oid IS NULL
         ORDER BY s.i
    ) INTO missing;
    IF missing[1] IS NULL THEN
        RETURN ok( true, $2 );
    END IF;
    RETURN ok( false, $2 ) || E'\n' || diag(
        '    ' ||
        array_to_string( missing, E'() missing\n    ') ||
        '() missing'
    );
END;
$$ LANGUAGE plpgsql;

-- can( func_names[] )
CREATE OR REPLACE FUNCTION can ( NAME[] )
RETURNS TEXT AS $$
    SELECT can( $1, 'Schema ' || _ident_array_to_string(current_schemas(true), ' or ') || ' can' );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _ikeys( NAME, NAME, NAME)
RETURNS NAME[] AS $$
    SELECT ARRAY(
        SELECT a.attname
          FROM pg_catalog.pg_index x
          JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
          JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
          JOIN pg_catalog.pg_namespace n ON (n.oid = ct.relnamespace)
          JOIN pg_catalog.pg_attribute a ON (ct.oid = a.attrelid)
         WHERE ct.relname = $2
           AND ci.relname = $3
           AND n.nspname  = $1
           AND a.attnum = ANY(x.indkey::int[])
    );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _ikeys( NAME, NAME)
RETURNS NAME[] AS $$
    SELECT ARRAY(
        SELECT a.attname
          FROM pg_catalog.pg_index x
          JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
          JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
          JOIN pg_catalog.pg_attribute a ON (ct.oid = a.attrelid)
         WHERE ct.relname = $1
           AND ci.relname = $2
           AND a.attnum = ANY(x.indkey::int[])
           AND pg_catalog.pg_table_is_visible(ct.oid)
    );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _iexpr( NAME, NAME, NAME)
RETURNS TEXT AS $$
    SELECT pg_catalog.pg_get_expr( x.indexprs, ct.oid )
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
      JOIN pg_catalog.pg_namespace n ON (n.oid = ct.relnamespace)
     WHERE ct.relname = $2
       AND ci.relname = $3
       AND n.nspname  = $1;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _iexpr( NAME, NAME)
RETURNS TEXT AS $$
    SELECT pg_catalog.pg_get_expr( x.indexprs, ct.oid )
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
     WHERE ct.relname = $1
       AND ci.relname = $2
       AND pg_catalog.pg_table_is_visible(ct.oid)
$$ LANGUAGE sql;

-- has_index( schema, table, index, columns[], description )
CREATE OR REPLACE FUNCTION has_index ( NAME, NAME, NAME, NAME[], text )
RETURNS TEXT AS $$
DECLARE
     index_cols name[];
BEGIN
    index_cols := _ikeys($1, $2, $3 );

    IF index_cols IS NULL OR index_cols = '{}'::name[] THEN
        RETURN ok( false, $5 ) || E'\n'
            || diag( 'Index ' || quote_ident($3) || ' ON ' || quote_ident($1) || '.' || quote_ident($2) || ' not found');
    END IF;

    RETURN is(
        quote_ident($3) || ' ON ' || quote_ident($1) || '.' || quote_ident($2) || '(' || _ident_array_to_string( index_cols, ', ' ) || ')',
        quote_ident($3) || ' ON ' || quote_ident($1) || '.' || quote_ident($2) || '(' || _ident_array_to_string( $4, ', ' ) || ')',
        $5
    );
END;
$$ LANGUAGE plpgsql;

-- has_index( schema, table, index, columns[] )
CREATE OR REPLACE FUNCTION has_index ( NAME, NAME, NAME, NAME[] )
RETURNS TEXT AS $$
   SELECT has_index( $1, $2, $3, $4, 'Index ' || quote_ident($3) || ' should exist' );
$$ LANGUAGE sql;

-- has_index( schema, table, index, column/expression, description )
CREATE OR REPLACE FUNCTION has_index ( NAME, NAME, NAME, NAME, text )
RETURNS TEXT AS $$
DECLARE
    expr text;
BEGIN
    IF $4 NOT LIKE '%(%' THEN
        -- Not a functional index.
        RETURN has_index( $1, $2, $3, ARRAY[$4], $5 );
    END IF;

    -- Get the functional expression.
    expr := _iexpr($1, $2, $3);

    IF expr IS NULL THEN
        RETURN ok( false, $5 ) || E'\n'
            || diag( 'Index ' || quote_ident($3) || ' ON ' || quote_ident($1) || '.' || quote_ident($2) || ' not found');
    END IF;

    RETURN is(
        quote_ident($3) || ' ON ' || quote_ident($1) || '.' || quote_ident($2) || '(' || expr || ')',
        quote_ident($3) || ' ON ' || quote_ident($1) || '.' || quote_ident($2) || '(' || $4 || ')',
        $5
    );
END;
$$ LANGUAGE plpgsql;

-- has_index( schema, table, index, columns/expression )
CREATE OR REPLACE FUNCTION has_index ( NAME, NAME, NAME, NAME )
RETURNS TEXT AS $$
   SELECT has_index( $1, $2, $3, $4, 'Index ' || quote_ident($3) || ' should exist' );
$$ LANGUAGE sql;

-- has_index( table, index, columns[], description )
CREATE OR REPLACE FUNCTION has_index ( NAME, NAME, NAME[], text )
RETURNS TEXT AS $$
DECLARE
     index_cols name[];
BEGIN
    index_cols := _ikeys($1, $2 );

    IF index_cols IS NULL OR index_cols = '{}'::name[] THEN
        RETURN ok( false, $4 ) || E'\n'
            || diag( 'Index ' || quote_ident($2) || ' ON ' || quote_ident($1) || ' not found');
    END IF;

    RETURN is(
        quote_ident($2) || ' ON ' || quote_ident($1) || '(' || _ident_array_to_string( index_cols, ', ' ) || ')',
        quote_ident($2) || ' ON ' || quote_ident($1) || '(' || _ident_array_to_string( $3, ', ' ) || ')',
        $4
    );
END;
$$ LANGUAGE plpgsql;

-- has_index( table, index, columns[], description )
CREATE OR REPLACE FUNCTION has_index ( NAME, NAME, NAME[] )
RETURNS TEXT AS $$
   SELECT has_index( $1, $2, $3, 'Index ' || quote_ident($2) || ' should exist' );
$$ LANGUAGE sql;

-- _is_schema( schema )
CREATE OR REPLACE FUNCTION _is_schema( NAME )
returns boolean AS $$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_namespace
          WHERE nspname = $1
    );
$$ LANGUAGE sql;

-- _has_index( schema, table, index )
CREATE OR REPLACE FUNCTION _has_index( NAME, NAME, NAME )
RETURNS boolean AS $$
    SELECT EXISTS ( SELECT _iexpr( $1, $2, $3 ) );
$$ LANGUAGE sql;

-- _has_index( table, index )
CREATE OR REPLACE FUNCTION _has_index( NAME, NAME )
RETURNS boolean AS $$
    SELECT EXISTS ( SELECT _iexpr( $1, $2 ) );
$$ LANGUAGE sql;

-- has_index( table, index, column/expression, description )
-- has_index( schema, table, index, column/expression )
CREATE OR REPLACE FUNCTION has_index ( NAME, NAME, NAME, text )
RETURNS TEXT AS $$
DECLARE
    want_expr text;
    descr text;
    have_expr text;
    idx name;
    tab text;
BEGIN
    IF $3 NOT LIKE '%(%' THEN
        -- Not a functional index.
        IF _is_schema( $1 ) THEN
            -- Looking for schema.table index.
            RETURN ok ( _has_index( $1, $2, $3 ), $4);
        END IF;
        -- Looking for particular columns.
        RETURN has_index( $1, $2, ARRAY[$3], $4 );
    END IF;

    -- Get the functional expression.
    IF _is_schema( $1 ) THEN
        -- Looking for an index within a schema.
        have_expr := _iexpr($1, $2, $3);
        want_expr := $4;
        descr     := 'Index ' || quote_ident($3) || ' should exist';
        idx       := $3;
        tab       := quote_ident($1) || '.' || quote_ident($2);
    ELSE
        -- Looking for an index without a schema spec.
        have_expr := _iexpr($1, $2);
        want_expr := $3;
        descr     := $4;
        idx       := $2;
        tab       := quote_ident($1);
    END IF;

    IF have_expr IS NULL THEN
        RETURN ok( false, descr ) || E'\n'
            || diag( 'Index ' || idx || ' ON ' || tab || ' not found');
    END IF;

    RETURN is(
        quote_ident(idx) || ' ON ' || tab || '(' || have_expr || ')',
        quote_ident(idx) || ' ON ' || tab || '(' || want_expr || ')',
        descr
    );
END;
$$ LANGUAGE plpgsql;

-- has_index( table, index, column/expression )
-- has_index( schema, table, index )
CREATE OR REPLACE FUNCTION has_index ( NAME, NAME, NAME )
RETURNS TEXT AS $$
BEGIN
   IF _is_schema($1) THEN
       -- ( schema, table, index )
       RETURN ok( _has_index( $1, $2, $3 ), 'Index ' || quote_ident($3) || ' should exist' );
   ELSE
       -- ( table, index, column/expression )
       RETURN has_index( $1, $2, $3, 'Index ' || quote_ident($2) || ' should exist' );
   END IF;
END;
$$ LANGUAGE plpgsql;

-- has_index( table, index, description )
CREATE OR REPLACE FUNCTION has_index ( NAME, NAME, text )
RETURNS TEXT AS $$
    SELECT CASE WHEN $3 LIKE '%(%'
           THEN has_index( $1, $2, $3::name )
           ELSE ok( _has_index( $1, $2 ), $3 )
           END;
$$ LANGUAGE sql;

-- has_index( table, index )
CREATE OR REPLACE FUNCTION has_index ( NAME, NAME )
RETURNS TEXT AS $$
    SELECT ok( _has_index( $1, $2 ), 'Index ' || quote_ident($2) || ' should exist' );
$$ LANGUAGE sql;

-- index_is_unique( schema, table, index, description )
CREATE OR REPLACE FUNCTION index_is_unique ( NAME, NAME, NAME, text )
RETURNS TEXT AS $$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisunique
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
      JOIN pg_catalog.pg_namespace n ON (n.oid = ct.relnamespace)
     WHERE ct.relname = $2
       AND ci.relname = $3
       AND n.nspname  = $1
      INTO res;

      RETURN ok( COALESCE(res, false), $4 );
END;
$$ LANGUAGE plpgsql;

-- index_is_unique( schema, table, index )
CREATE OR REPLACE FUNCTION index_is_unique ( NAME, NAME, NAME )
RETURNS TEXT AS $$
    SELECT index_is_unique(
        $1, $2, $3,
        'Index ' || quote_ident($3) || ' should be unique'
    );
$$ LANGUAGE sql;

-- index_is_unique( table, index )
CREATE OR REPLACE FUNCTION index_is_unique ( NAME, NAME )
RETURNS TEXT AS $$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisunique
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
     WHERE ct.relname = $1
       AND ci.relname = $2
       AND pg_catalog.pg_table_is_visible(ct.oid)
      INTO res;

      RETURN ok(
          COALESCE(res, false),
          'Index ' || quote_ident($2) || ' should be unique'
      );
END;
$$ LANGUAGE plpgsql;

-- index_is_unique( index )
CREATE OR REPLACE FUNCTION index_is_unique ( NAME )
RETURNS TEXT AS $$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisunique
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
      JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
     WHERE ci.relname = $1
       AND pg_catalog.pg_table_is_visible(ct.oid)
      INTO res;

      RETURN ok(
          COALESCE(res, false),
          'Index ' || quote_ident($1) || ' should be unique'
      );
END;
$$ LANGUAGE plpgsql;

-- index_is_primary( schema, table, index, description )
CREATE OR REPLACE FUNCTION index_is_primary ( NAME, NAME, NAME, text )
RETURNS TEXT AS $$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisprimary
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
      JOIN pg_catalog.pg_namespace n ON (n.oid = ct.relnamespace)
     WHERE ct.relname = $2
       AND ci.relname = $3
       AND n.nspname  = $1
      INTO res;

      RETURN ok( COALESCE(res, false), $4 );
END;
$$ LANGUAGE plpgsql;

-- index_is_primary( schema, table, index )
CREATE OR REPLACE FUNCTION index_is_primary ( NAME, NAME, NAME )
RETURNS TEXT AS $$
    SELECT index_is_primary(
        $1, $2, $3,
        'Index ' || quote_ident($3) || ' should be on a primary key'
    );
$$ LANGUAGE sql;

-- index_is_primary( table, index )
CREATE OR REPLACE FUNCTION index_is_primary ( NAME, NAME )
RETURNS TEXT AS $$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisprimary
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
     WHERE ct.relname = $1
       AND ci.relname = $2
       AND pg_catalog.pg_table_is_visible(ct.oid)
     INTO res;

      RETURN ok(
          COALESCE(res, false),
          'Index ' || quote_ident($2) || ' should be on a primary key'
      );
END;
$$ LANGUAGE plpgsql;

-- index_is_primary( index )
CREATE OR REPLACE FUNCTION index_is_primary ( NAME )
RETURNS TEXT AS $$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisprimary
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
      JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
     WHERE ci.relname = $1
       AND pg_catalog.pg_table_is_visible(ct.oid)
      INTO res;

      RETURN ok(
          COALESCE(res, false),
          'Index ' || quote_ident($1) || ' should be on a primary key'
      );
END;
$$ LANGUAGE plpgsql;

-- is_clustered( schema, table, index, description )
CREATE OR REPLACE FUNCTION is_clustered ( NAME, NAME, NAME, text )
RETURNS TEXT AS $$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisclustered
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
      JOIN pg_catalog.pg_namespace n ON (n.oid = ct.relnamespace)
     WHERE ct.relname = $2
       AND ci.relname = $3
       AND n.nspname  = $1
      INTO res;

      RETURN ok( COALESCE(res, false), $4 );
END;
$$ LANGUAGE plpgsql;

-- is_clustered( schema, table, index )
CREATE OR REPLACE FUNCTION is_clustered ( NAME, NAME, NAME )
RETURNS TEXT AS $$
    SELECT is_clustered(
        $1, $2, $3,
        'Table ' || quote_ident($1) || '.' || quote_ident($2) ||
        ' should be clustered on index ' || quote_ident($3)
    );
$$ LANGUAGE sql;

-- is_clustered( table, index )
CREATE OR REPLACE FUNCTION is_clustered ( NAME, NAME )
RETURNS TEXT AS $$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisclustered
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
     WHERE ct.relname = $1
       AND ci.relname = $2
      INTO res;

      RETURN ok(
          COALESCE(res, false),
          'Table ' || quote_ident($1) || ' should be clustered on index ' || quote_ident($2)
      );
END;
$$ LANGUAGE plpgsql;

-- is_clustered( index )
CREATE OR REPLACE FUNCTION is_clustered ( NAME )
RETURNS TEXT AS $$
DECLARE
    res boolean;
BEGIN
    SELECT x.indisclustered
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
     WHERE ci.relname = $1
      INTO res;

      RETURN ok(
          COALESCE(res, false),
          'Table should be clustered on index ' || quote_ident($1)
      );
END;
$$ LANGUAGE plpgsql;

-- index_is_type( schema, table, index, type, description )
CREATE OR REPLACE FUNCTION index_is_type ( NAME, NAME, NAME, NAME, text )
RETURNS TEXT AS $$
DECLARE
    aname name;
BEGIN
    SELECT am.amname
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
      JOIN pg_catalog.pg_namespace n ON (n.oid = ct.relnamespace)
      JOIN pg_catalog.pg_am am ON ( ci.relam = am.oid)
     WHERE ct.relname = $2
       AND ci.relname = $3
       AND n.nspname  = $1
      INTO aname;

      return is( aname, LOWER($4)::name, $5 );
END;
$$ LANGUAGE plpgsql;

-- index_is_type( schema, table, index, type )
CREATE OR REPLACE FUNCTION index_is_type ( NAME, NAME, NAME, NAME )
RETURNS TEXT AS $$
    SELECT index_is_type(
        $1, $2, $3, $4,
        'Index ' || quote_ident($3) || ' should be a ' || quote_ident($4) || ' index'
    );
$$ LANGUAGE SQL;

-- index_is_type( table, index, type )
CREATE OR REPLACE FUNCTION index_is_type ( NAME, NAME, NAME )
RETURNS TEXT AS $$
DECLARE
    aname name;
BEGIN
    SELECT am.amname
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ct ON (ct.oid = x.indrelid)
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
      JOIN pg_catalog.pg_am am ON ( ci.relam = am.oid)
     WHERE ct.relname = $1
       AND ci.relname = $2
      INTO aname;

      return is(
          aname,
          LOWER($3)::name,
          'Index ' || quote_ident($2) || ' should be a ' || quote_ident($3) || ' index'
      );
END;
$$ LANGUAGE plpgsql;

-- index_is_type( index, type )
CREATE OR REPLACE FUNCTION index_is_type ( NAME, NAME )
RETURNS TEXT AS $$
DECLARE
    aname name;
BEGIN
    SELECT am.amname
      FROM pg_catalog.pg_index x
      JOIN pg_catalog.pg_class ci ON (ci.oid = x.indexrelid)
      JOIN pg_catalog.pg_am am ON ( ci.relam = am.oid)
     WHERE ci.relname = $1
      INTO aname;

      return is(
          aname,
          LOWER($3)::name,
          'Index ' || quote_ident($1) || ' should be a ' || quote_ident($2) || ' index'
      );
END;
$$ LANGUAGE plpgsql;

-- has_trigger( schema, table, trigger, description )
CREATE OR REPLACE FUNCTION has_trigger ( NAME, NAME, NAME, NAME )
RETURNS TEXT AS $$
DECLARE
    res boolean;
BEGIN
    SELECT true
      FROM pg_catalog.pg_trigger t
      JOIN pg_catalog.pg_class c ON (c.oid = t.tgrelid)
      JOIN pg_catalog.pg_namespace n ON (n.oid = c.relnamespace)
     WHERE n.nspname = $1
       AND c.relname = $2
       AND t.tgname  = $3
      INTO res;

      RETURN ok( COALESCE(res, false), $4 );
END;
$$ LANGUAGE plpgsql;

-- has_trigger( schema, table, trigger )
CREATE OR REPLACE FUNCTION has_trigger ( NAME, NAME, NAME )
RETURNS TEXT AS $$
    SELECT has_trigger(
        $1, $2, $3,
        'Table ' || quote_ident($1) || '.' || quote_ident($2) || ' should have trigger ' || quote_ident($3)
    );
$$ LANGUAGE sql;

-- has_trigger( table, trigger )
CREATE OR REPLACE FUNCTION has_trigger ( NAME, NAME )
RETURNS TEXT AS $$
DECLARE
    res boolean;
BEGIN
    SELECT true
      FROM pg_catalog.pg_trigger t
      JOIN pg_catalog.pg_class c ON (c.oid = t.tgrelid)
     WHERE c.relname = $1
       AND t.tgname  = $2
       AND pg_catalog.pg_table_is_visible(c.oid)
      INTO res;

      RETURN ok(
          COALESCE(res, false),
          'Table ' || quote_ident($1) || ' should have trigger ' || quote_ident($2)
      );
END;
$$ LANGUAGE plpgsql;

-- trigger_is( schema, table, trigger, schema, function, description )
CREATE OR REPLACE FUNCTION trigger_is ( NAME, NAME, NAME, NAME, NAME, text )
RETURNS TEXT AS $$
DECLARE
    pname text;
BEGIN
    SELECT quote_ident(ni.nspname) || '.' || quote_ident(p.proname)
      FROM pg_catalog.pg_trigger t
      JOIN pg_catalog.pg_class ct ON (ct.oid = t.tgrelid)
      JOIN pg_catalog.pg_namespace nt ON (nt.oid = ct.relnamespace)
      JOIN pg_catalog.pg_proc p ON (p.oid = t.tgfoid)
      JOIN pg_catalog.pg_namespace ni ON (ni.oid = p.pronamespace)
     WHERE nt.nspname = $1
       AND ct.relname = $2
       AND t.tgname   = $3
      INTO pname;

    RETURN is( pname, quote_ident($4) || '.' || quote_ident($5), $6 );
END;
$$ LANGUAGE plpgsql;

-- trigger_is( schema, table, trigger, schema, function )
CREATE OR REPLACE FUNCTION trigger_is ( NAME, NAME, NAME, NAME, NAME )
RETURNS TEXT AS $$
    SELECT trigger_is(
        $1, $2, $3, $4, $5,
        'Trigger ' || quote_ident($3) || ' should call ' || quote_ident($4) || '.' || quote_ident($5) || '()'
    );
$$ LANGUAGE sql;

-- trigger_is( table, trigger, function, description )
CREATE OR REPLACE FUNCTION trigger_is ( NAME, NAME, NAME, text )
RETURNS TEXT AS $$
DECLARE
    pname text;
BEGIN
    SELECT p.proname
      FROM pg_catalog.pg_trigger t
      JOIN pg_catalog.pg_class ct ON (ct.oid = t.tgrelid)
      JOIN pg_catalog.pg_proc p ON (p.oid = t.tgfoid)
     WHERE ct.relname = $1
       AND t.tgname   = $2
       AND pg_catalog.pg_table_is_visible(ct.oid)
      INTO pname;

    RETURN is( pname, $3::text, $4 );
END;
$$ LANGUAGE plpgsql;

-- trigger_is( table, trigger, function )
CREATE OR REPLACE FUNCTION trigger_is ( NAME, NAME, NAME )
RETURNS TEXT AS $$
    SELECT trigger_is(
        $1, $2, $3,
        'Trigger ' || quote_ident($2) || ' should call ' || quote_ident($3) || '()'
    );
$$ LANGUAGE sql;

-- has_schema( schema, description )
CREATE OR REPLACE FUNCTION has_schema( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok(
        EXISTS(
            SELECT true
              FROM pg_catalog.pg_namespace
             WHERE nspname = $1
        ), $2
    );
$$ LANGUAGE sql;

-- has_schema( schema )
CREATE OR REPLACE FUNCTION has_schema( NAME )
RETURNS TEXT AS $$
    SELECT has_schema( $1, 'Schema ' || quote_ident($1) || ' should exist' );
$$ LANGUAGE sql;

-- hasnt_schema( schema, description )
CREATE OR REPLACE FUNCTION hasnt_schema( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok(
        NOT EXISTS(
            SELECT true
              FROM pg_catalog.pg_namespace
             WHERE nspname = $1
        ), $2
    );
$$ LANGUAGE sql;

-- hasnt_schema( schema )
CREATE OR REPLACE FUNCTION hasnt_schema( NAME )
RETURNS TEXT AS $$
    SELECT hasnt_schema( $1, 'Schema ' || quote_ident($1) || ' should not exist' );
$$ LANGUAGE sql;

-- has_tablespace( tablespace, location, description )
CREATE OR REPLACE FUNCTION has_tablespace( NAME, TEXT, TEXT )
RETURNS TEXT AS $$
    SELECT ok(
        EXISTS(
            SELECT true
              FROM pg_catalog.pg_tablespace
             WHERE spcname = $1
               AND spclocation = $2
        ), $3
    );
$$ LANGUAGE sql;

-- has_tablespace( tablespace, description )
CREATE OR REPLACE FUNCTION has_tablespace( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok(
        EXISTS(
            SELECT true
              FROM pg_catalog.pg_tablespace
             WHERE spcname = $1
        ), $2
    );
$$ LANGUAGE sql;

-- has_tablespace( tablespace )
CREATE OR REPLACE FUNCTION has_tablespace( NAME )
RETURNS TEXT AS $$
    SELECT has_tablespace( $1, 'Tablespace ' || quote_ident($1) || ' should exist' );
$$ LANGUAGE sql;

-- hasnt_tablespace( tablespace, description )
CREATE OR REPLACE FUNCTION hasnt_tablespace( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok(
        NOT EXISTS(
            SELECT true
              FROM pg_catalog.pg_tablespace
             WHERE spcname = $1
        ), $2
    );
$$ LANGUAGE sql;

-- hasnt_tablespace( tablespace )
CREATE OR REPLACE FUNCTION hasnt_tablespace( NAME )
RETURNS TEXT AS $$
    SELECT hasnt_tablespace( $1, 'Tablespace ' || quote_ident($1) || ' should not exist' );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _has_type( NAME, NAME, CHAR[] )
RETURNS BOOLEAN AS $$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_type t
          JOIN pg_catalog.pg_namespace n ON (t.typnamespace = n.oid)
         WHERE t.typisdefined
           AND n.nspname = $1
           AND t.typname = $2
           AND t.typtype = ANY( COALESCE($3, ARRAY['b', 'c', 'd', 'p', 'e']) )
    );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _has_type( NAME, CHAR[] )
RETURNS BOOLEAN AS $$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_type t
         WHERE t.typisdefined
           AND pg_catalog.pg_type_is_visible(t.oid)
           AND t.typname = $1
           AND t.typtype = ANY( COALESCE($2, ARRAY['b', 'c', 'd', 'p', 'e']) )
    );
$$ LANGUAGE sql;

-- has_type( schema, type, description )
CREATE OR REPLACE FUNCTION has_type( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _has_type( $1, $2, NULL ), $3 );
$$ LANGUAGE sql;

-- has_type( schema, type )
CREATE OR REPLACE FUNCTION has_type( NAME, NAME )
RETURNS TEXT AS $$
    SELECT has_type( $1, $2, 'Type ' || quote_ident($1) || '.' || quote_ident($2) || ' should exist' );
$$ LANGUAGE sql;

-- has_type( type, description )
CREATE OR REPLACE FUNCTION has_type( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _has_type( $1, NULL ), $2 );
$$ LANGUAGE sql;

-- has_type( type )
CREATE OR REPLACE FUNCTION has_type( NAME )
RETURNS TEXT AS $$
    SELECT ok( _has_type( $1, NULL ), ('Type ' || quote_ident($1) || ' should exist')::text );
$$ LANGUAGE sql;

-- hasnt_type( schema, type, description )
CREATE OR REPLACE FUNCTION hasnt_type( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _has_type( $1, $2, NULL ), $3 );
$$ LANGUAGE sql;

-- hasnt_type( schema, type )
CREATE OR REPLACE FUNCTION hasnt_type( NAME, NAME )
RETURNS TEXT AS $$
    SELECT hasnt_type( $1, $2, 'Type ' || quote_ident($1) || '.' || quote_ident($2) || ' should not exist' );
$$ LANGUAGE sql;

-- hasnt_type( type, description )
CREATE OR REPLACE FUNCTION hasnt_type( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _has_type( $1, NULL ), $2 );
$$ LANGUAGE sql;

-- hasnt_type( type )
CREATE OR REPLACE FUNCTION hasnt_type( NAME )
RETURNS TEXT AS $$
    SELECT ok( NOT _has_type( $1, NULL ), ('Type ' || quote_ident($1) || ' should not exist')::text );
$$ LANGUAGE sql;

-- has_domain( schema, domain, description )
CREATE OR REPLACE FUNCTION has_domain( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _has_type( $1, $2, ARRAY['d'] ), $3 );
$$ LANGUAGE sql;

-- has_domain( schema, domain )
CREATE OR REPLACE FUNCTION has_domain( NAME, NAME )
RETURNS TEXT AS $$
    SELECT has_domain( $1, $2, 'Domain ' || quote_ident($1) || '.' || quote_ident($2) || ' should exist' );
$$ LANGUAGE sql;

-- has_domain( domain, description )
CREATE OR REPLACE FUNCTION has_domain( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _has_type( $1, ARRAY['d'] ), $2 );
$$ LANGUAGE sql;

-- has_domain( domain )
CREATE OR REPLACE FUNCTION has_domain( NAME )
RETURNS TEXT AS $$
    SELECT ok( _has_type( $1, ARRAY['d'] ), ('Domain ' || quote_ident($1) || ' should exist')::text );
$$ LANGUAGE sql;

-- hasnt_domain( schema, domain, description )
CREATE OR REPLACE FUNCTION hasnt_domain( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _has_type( $1, $2, ARRAY['d'] ), $3 );
$$ LANGUAGE sql;

-- hasnt_domain( schema, domain )
CREATE OR REPLACE FUNCTION hasnt_domain( NAME, NAME )
RETURNS TEXT AS $$
    SELECT hasnt_domain( $1, $2, 'Domain ' || quote_ident($1) || '.' || quote_ident($2) || ' should not exist' );
$$ LANGUAGE sql;

-- hasnt_domain( domain, description )
CREATE OR REPLACE FUNCTION hasnt_domain( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _has_type( $1, ARRAY['d'] ), $2 );
$$ LANGUAGE sql;

-- hasnt_domain( domain )
CREATE OR REPLACE FUNCTION hasnt_domain( NAME )
RETURNS TEXT AS $$
    SELECT ok( NOT _has_type( $1, ARRAY['d'] ), ('Domain ' || quote_ident($1) || ' should not exist')::text );
$$ LANGUAGE sql;

-- has_enum( schema, enum, description )
CREATE OR REPLACE FUNCTION has_enum( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _has_type( $1, $2, ARRAY['e'] ), $3 );
$$ LANGUAGE sql;

-- has_enum( schema, enum )
CREATE OR REPLACE FUNCTION has_enum( NAME, NAME )
RETURNS TEXT AS $$
    SELECT has_enum( $1, $2, 'Enum ' || quote_ident($1) || '.' || quote_ident($2) || ' should exist' );
$$ LANGUAGE sql;

-- has_enum( enum, description )
CREATE OR REPLACE FUNCTION has_enum( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _has_type( $1, ARRAY['e'] ), $2 );
$$ LANGUAGE sql;

-- has_enum( enum )
CREATE OR REPLACE FUNCTION has_enum( NAME )
RETURNS TEXT AS $$
    SELECT ok( _has_type( $1, ARRAY['e'] ), ('Enum ' || quote_ident($1) || ' should exist')::text );
$$ LANGUAGE sql;

-- hasnt_enum( schema, enum, description )
CREATE OR REPLACE FUNCTION hasnt_enum( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _has_type( $1, $2, ARRAY['e'] ), $3 );
$$ LANGUAGE sql;

-- hasnt_enum( schema, enum )
CREATE OR REPLACE FUNCTION hasnt_enum( NAME, NAME )
RETURNS TEXT AS $$
    SELECT hasnt_enum( $1, $2, 'Enum ' || quote_ident($1) || '.' || quote_ident($2) || ' should not exist' );
$$ LANGUAGE sql;

-- hasnt_enum( enum, description )
CREATE OR REPLACE FUNCTION hasnt_enum( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _has_type( $1, ARRAY['e'] ), $2 );
$$ LANGUAGE sql;

-- hasnt_enum( enum )
CREATE OR REPLACE FUNCTION hasnt_enum( NAME )
RETURNS TEXT AS $$
    SELECT ok( NOT _has_type( $1, ARRAY['e'] ), ('Enum ' || quote_ident($1) || ' should not exist')::text );
$$ LANGUAGE sql;

-- enum_has_labels( schema, enum, labels, desc )
CREATE OR REPLACE FUNCTION enum_has_labels( NAME, NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT is(
        ARRAY(
            SELECT e.enumlabel
              FROM pg_catalog.pg_type t
              JOIN pg_catalog.pg_enum e ON (t.oid = e.enumtypid)
              JOIN pg_catalog.pg_namespace n ON (t.typnamespace = n.oid)
              WHERE t.typisdefined
               AND n.nspname = $1
               AND t.typname = $2
               AND t.typtype = 'e'
             ORDER BY e.oid
        ),
        $3,
        $4
    );
$$ LANGUAGE sql;

-- enum_has_labels( schema, enum, labels )
CREATE OR REPLACE FUNCTION enum_has_labels( NAME, NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT enum_has_labels(
        $1, $2, $3,
        'Enum ' || quote_ident($1) || '.' || quote_ident($2) || ' should have labels (' || array_to_string( $3, ', ' ) || ')'
    );
$$ LANGUAGE sql;

-- enum_has_labels( enum, labels, desc )
CREATE OR REPLACE FUNCTION enum_has_labels( NAME, NAME[], TEXT )
RETURNS TEXT AS $$
    SELECT is(
        ARRAY(
            SELECT e.enumlabel
              FROM pg_catalog.pg_type t
              JOIN pg_catalog.pg_enum e ON (t.oid = e.enumtypid)
              WHERE t.typisdefined
               AND pg_catalog.pg_type_is_visible(t.oid)
               AND t.typname = $1
               AND t.typtype = 'e'
             ORDER BY e.oid
        ),
        $2,
        $3
    );
$$ LANGUAGE sql;

-- enum_has_labels( enum, labels )
CREATE OR REPLACE FUNCTION enum_has_labels( NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT enum_has_labels(
        $1, $2,
        'Enum ' || quote_ident($1) || ' should have labels (' || array_to_string( $2, ', ' ) || ')'
    );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _has_role( NAME )
RETURNS BOOLEAN AS $$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_roles
         WHERE rolname = $1
    );
$$ LANGUAGE sql STRICT;

-- has_role( role, desc )
CREATE OR REPLACE FUNCTION has_role( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _has_role($1), $2 );
$$ LANGUAGE sql;

-- has_role( role )
CREATE OR REPLACE FUNCTION has_role( NAME )
RETURNS TEXT AS $$
    SELECT ok( _has_role($1), 'Role ' || quote_ident($1) || ' should exist' );
$$ LANGUAGE sql;

-- hasnt_role( role, desc )
CREATE OR REPLACE FUNCTION hasnt_role( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _has_role($1), $2 );
$$ LANGUAGE sql;

-- hasnt_role( role )
CREATE OR REPLACE FUNCTION hasnt_role( NAME )
RETURNS TEXT AS $$
    SELECT ok( NOT _has_role($1), 'Role ' || quote_ident($1) || ' should not exist' );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _is_super( NAME )
RETURNS BOOLEAN AS $$
    SELECT usesuper
      FROM pg_catalog.pg_user
     WHERE usename = $1
$$ LANGUAGE sql STRICT;

-- has_user( user, desc )
CREATE OR REPLACE FUNCTION has_user( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _is_super($1) IS NOT NULL, $2 );
$$ LANGUAGE sql;

-- has_user( user )
CREATE OR REPLACE FUNCTION has_user( NAME )
RETURNS TEXT AS $$
    SELECT ok( _is_super( $1 ) IS NOT NULL, 'User ' || quote_ident($1) || ' should exist');
$$ LANGUAGE sql;

-- hasnt_user( user, desc )
CREATE OR REPLACE FUNCTION hasnt_user( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _is_super($1) IS NULL, $2 );
$$ LANGUAGE sql;

-- hasnt_user( user )
CREATE OR REPLACE FUNCTION hasnt_user( NAME )
RETURNS TEXT AS $$
    SELECT ok( _is_super( $1 ) IS NULL, 'User ' || quote_ident($1) || ' should not exist');
$$ LANGUAGE sql;

-- is_superuser( user, desc )
CREATE OR REPLACE FUNCTION is_superuser( NAME, TEXT )
RETURNS TEXT AS $$
DECLARE
    is_super boolean := _is_super($1);
BEGIN
    IF is_super IS NULL THEN
        RETURN fail( $2 ) || E'\n' || diag( '    User ' || quote_ident($1) || ' does not exist') ;
    END IF;
    RETURN ok( is_super, $2 );
END;
$$ LANGUAGE plpgsql;

-- is_superuser( user )
CREATE OR REPLACE FUNCTION is_superuser( NAME )
RETURNS TEXT AS $$
    SELECT is_superuser( $1, 'User ' || quote_ident($1) || ' should be a super user' );
$$ LANGUAGE sql;

-- isnt_superuser( user, desc )
CREATE OR REPLACE FUNCTION isnt_superuser( NAME, TEXT )
RETURNS TEXT AS $$
DECLARE
    is_super boolean := _is_super($1);
BEGIN
    IF is_super IS NULL THEN
        RETURN fail( $2 ) || E'\n' || diag( '    User ' || quote_ident($1) || ' does not exist') ;
    END IF;
    RETURN ok( NOT is_super, $2 );
END;
$$ LANGUAGE plpgsql;

-- isnt_superuser( user )
CREATE OR REPLACE FUNCTION isnt_superuser( NAME )
RETURNS TEXT AS $$
    SELECT isnt_superuser( $1, 'User ' || quote_ident($1) || ' should not be a super user' );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _has_group( NAME )
RETURNS BOOLEAN AS $$
    SELECT EXISTS(
        SELECT true
          FROM pg_catalog.pg_group
         WHERE groname = $1
    );
$$ LANGUAGE sql STRICT;

-- has_group( group, desc )
CREATE OR REPLACE FUNCTION has_group( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( _has_group($1), $2 );
$$ LANGUAGE sql;

-- has_group( group )
CREATE OR REPLACE FUNCTION has_group( NAME )
RETURNS TEXT AS $$
    SELECT ok( _has_group($1), 'Group ' || quote_ident($1) || ' should exist' );
$$ LANGUAGE sql;

-- hasnt_group( group, desc )
CREATE OR REPLACE FUNCTION hasnt_group( NAME, TEXT )
RETURNS TEXT AS $$
    SELECT ok( NOT _has_group($1), $2 );
$$ LANGUAGE sql;

-- hasnt_group( group )
CREATE OR REPLACE FUNCTION hasnt_group( NAME )
RETURNS TEXT AS $$
    SELECT ok( NOT _has_group($1), 'Group ' || quote_ident($1) || ' should not exist' );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _grolist ( NAME )
RETURNS oid[] AS $$
    SELECT grolist FROM pg_catalog.pg_group WHERE groname = $1;
$$ LANGUAGE sql;

-- is_member_of( group, user[], desc )
CREATE OR REPLACE FUNCTION is_member_of( NAME, NAME[], TEXT )
RETURNS TEXT AS $$
DECLARE
    missing text[];
BEGIN
    IF NOT _has_group($1) THEN
        RETURN fail( $3 ) || E'\n' || diag (
            '    Group ' || quote_ident($1) || ' does not exist'
        );
    END IF;

    SELECT ARRAY(
        SELECT quote_ident($2[i])
          FROM generate_series(1, array_upper($2, 1)) s(i)
          LEFT JOIN pg_catalog.pg_user ON usename = $2[i]
         WHERE usesysid IS NULL
            OR usesysid <> ANY ( _grolist($1) )
         ORDER BY s.i
    ) INTO missing;
    IF missing[1] IS NULL THEN
        RETURN ok( true, $3 );
    END IF;
    RETURN ok( false, $3 ) || E'\n' || diag(
        '    Users missing from the ' || quote_ident($1) || E' group:\n        ' ||
        array_to_string( missing, E'\n        ')
    );
END;
$$ LANGUAGE plpgsql;

-- is_member_of( group, user, desc )
CREATE OR REPLACE FUNCTION is_member_of( NAME, NAME, TEXT )
RETURNS TEXT AS $$
    SELECT is_member_of( $1, ARRAY[$2], $3 ); 
$$ LANGUAGE SQL;

-- is_member_of( group, user[] )
CREATE OR REPLACE FUNCTION is_member_of( NAME, NAME[] )
RETURNS TEXT AS $$
    SELECT is_member_of( $1, $2, 'Should have members of group ' || quote_ident($1) ); 
$$ LANGUAGE SQL;

-- is_member_of( group, user )
CREATE OR REPLACE FUNCTION is_member_of( NAME, NAME )
RETURNS TEXT AS $$
    SELECT is_member_of( $1, ARRAY[$2] );
$$ LANGUAGE SQL;

-- check_test( test_output, pass, name, description, diag )
CREATE OR REPLACE FUNCTION check_test( TEXT, BOOLEAN, TEXT, TEXT, TEXT )
RETURNS SETOF TEXT AS $$
DECLARE
    tnumb  INTEGER;
    aok    BOOLEAN;
    adescr TEXT;
    res    BOOLEAN;
    descr  TEXT;
    adiag  TEXT;
    have   ALIAS FOR $1;
    eok    ALIAS FOR $2;
    name   ALIAS FOR $3;
    edescr ALIAS FOR $4;
    ediag  ALIAS FOR $5;
BEGIN
    -- What test was it that just ran?
    tnumb := currval('__tresults___numb_seq');

    -- Fetch the results.
    EXECUTE 'SELECT aok, descr FROM __tresults__ WHERE numb = ' || tnumb
       INTO aok, adescr;

    -- Now delete those results.
    EXECUTE 'DELETE FROM __tresults__ WHERE numb = ' || tnumb;
    EXECUTE 'ALTER SEQUENCE __tresults___numb_seq RESTART WITH ' || tnumb;

    -- Set up the description.
    descr := coalesce( name || ' ', 'Test ' ) || 'should ';

    -- So, did the test pass?
    RETURN NEXT is(
        aok,
        eok,
        descr || CASE eok WHEN true then 'pass' ELSE 'fail' END
    );

    -- Was the description as expected?
    IF edescr IS NOT NULL THEN
        RETURN NEXT is(
            adescr,
            edescr,
            descr || 'have the proper description'
        );
    END IF;

    -- Were the diagnostics as expected?
    IF ediag IS NOT NULL THEN
        -- Remove ok and the test number.
        adiag := substring(
            have
            FROM CASE WHEN aok THEN 4 ELSE 9 END + char_length(tnumb::text)
        );

        -- Remove the description, if there is one.
        IF adescr <> '' THEN
            adiag := substring( adiag FROM 3 + char_length( diag( adescr ) ) );
        END IF;

        -- Remove failure message from ok().
        IF NOT aok THEN
           adiag := substring(
               adiag
               FROM 14 + char_length(tnumb::text)
                       + CASE adescr WHEN '' THEN 3 ELSE 3 + char_length( diag( adescr ) ) END
           );
        END IF;

        -- Remove the #s.
        adiag := replace( substring(adiag from 3), E'\n# ', E'\n' );

        -- Now compare the diagnostics.
        RETURN NEXT is(
            adiag,
            ediag,
            descr || 'have the proper diagnostics'
        );
    END IF;

    -- And we're done
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- check_test( test_output, pass, name, description )
CREATE OR REPLACE FUNCTION check_test( TEXT, BOOLEAN, TEXT, TEXT )
RETURNS SETOF TEXT AS $$
    SELECT * FROM check_test( $1, $2, $3, $4, NULL );
$$ LANGUAGE sql;

-- check_test( test_output, pass, name )
CREATE OR REPLACE FUNCTION check_test( TEXT, BOOLEAN, TEXT )
RETURNS SETOF TEXT AS $$
    SELECT * FROM check_test( $1, $2, $3, NULL, NULL );
$$ LANGUAGE sql;

-- check_test( test_output, pass )
CREATE OR REPLACE FUNCTION check_test( TEXT, BOOLEAN )
RETURNS SETOF TEXT AS $$
    SELECT * FROM check_test( $1, $2, NULL, NULL, NULL );
$$ LANGUAGE sql;


CREATE OR REPLACE FUNCTION findfuncs( NAME, TEXT )
RETURNS TEXT[] AS $$
    SELECT ARRAY(
        SELECT DISTINCT quote_ident(n.nspname) || '.' || quote_ident(p.proname) AS pname
          FROM pg_catalog.pg_proc p
          JOIN pg_catalog.pg_namespace n ON p.pronamespace = n.oid
         WHERE n.nspname = $1
           AND p.proname ~ $2
         ORDER BY pname
    );
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION findfuncs( TEXT )
RETURNS TEXT[] AS $$
    SELECT ARRAY(
        SELECT DISTINCT quote_ident(n.nspname) || '.' || quote_ident(p.proname) AS pname
          FROM pg_catalog.pg_proc p
          JOIN pg_catalog.pg_namespace n ON p.pronamespace = n.oid
         WHERE pg_catalog.pg_function_is_visible(p.oid)
           AND p.proname ~ $1
         ORDER BY pname
    );
$$ LANGUAGE sql;
   
CREATE OR REPLACE FUNCTION _runem( text[], boolean )
RETURNS SETOF TEXT AS $$
DECLARE
    tap    text;
    lbound int := array_lower($1, 1);
BEGIN
    IF lbound IS NULL THEN RETURN; END IF;
    FOR i IN lbound..array_upper($1, 1) LOOP
        -- Send the name of the function to diag if warranted.
        IF $2 THEN RETURN NEXT diag( $1[i] || '()' ); END IF;
        -- Execute the tap function and return its results.
        FOR tap IN EXECUTE 'SELECT * FROM ' || $1[i] || '()' LOOP
            RETURN NEXT tap;
        END LOOP;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION _is_verbose()
RETURNS BOOLEAN AS $$
    SELECT current_setting('client_min_messages') NOT IN (
        'warning', 'error', 'fatal', 'panic'
    );
$$ LANGUAGE sql STABLE;

-- do_tap( schema, pattern )
CREATE OR REPLACE FUNCTION do_tap( name, text )
RETURNS SETOF TEXT AS $$
    SELECT * FROM _runem( findfuncs($1, $2), _is_verbose() );
$$ LANGUAGE sql;

-- do_tap( schema )
CREATE OR REPLACE FUNCTION do_tap( name )
RETURNS SETOF TEXT AS $$
    SELECT * FROM _runem( findfuncs($1, '^test'), _is_verbose() );
$$ LANGUAGE sql;

-- do_tap( pattern )
CREATE OR REPLACE FUNCTION do_tap( text )
RETURNS SETOF TEXT AS $$
    SELECT * FROM _runem( findfuncs($1), _is_verbose() );
$$ LANGUAGE sql;

-- do_tap()
CREATE OR REPLACE FUNCTION do_tap( )
RETURNS SETOF TEXT AS $$
    SELECT * FROM _runem( findfuncs('^test'), _is_verbose());
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _currtest()
RETURNS INTEGER AS $$
BEGIN
    RETURN currval('__tresults___numb_seq');
EXCEPTION
    WHEN object_not_in_prerequisite_state THEN RETURN 0;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION _cleanup()
RETURNS boolean AS $$
DECLARE
    cmm    text := current_setting('client_min_messages');
BEGIN
    PERFORM set_config('client_min_messages', 'warning', true);
    DROP TABLE __tresults__;
    DROP TABLE __tcache__;
    PERFORM set_config('client_min_messages', cmm, true);
    RETURN TRUE;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION _runner( text[], text[], text[], text[], text[] )
RETURNS SETOF TEXT AS $$
DECLARE
    startup  ALIAS FOR $1;
    shutdown ALIAS FOR $2;
    setup    ALIAS FOR $3;
    teardown ALIAS FOR $4;
    tests    ALIAS FOR $5;
    tap      text;
    verbosity  boolean := _is_verbose();
    num_faild INTEGER := 0;
BEGIN
    BEGIN
        -- No plan support.
        PERFORM * FROM no_plan();
        FOR tap IN SELECT * FROM _runem(startup, false) LOOP RETURN NEXT tap; END LOOP;
    EXCEPTION
        -- Catch all exceptions and simply rethrow custom exceptions. This
        -- will roll back everything in the above block.
        WHEN raise_exception THEN
            RAISE EXCEPTION '%', SQLERRM;
    END;

    BEGIN
        FOR i IN 1..array_upper(tests, 1) LOOP
            BEGIN
                -- What test are we running?
                IF verbosity THEN RETURN NEXT diag(tests[i] || '()'); END IF;

                -- Run the setup functions.
                FOR tap IN SELECT * FROM _runem(setup, false) LOOP RETURN NEXT tap; END LOOP;

                -- Run the actual test function.
                FOR tap IN EXECUTE 'SELECT * FROM ' || tests[i] || '()' LOOP
                    RETURN NEXT tap;
                END LOOP;

                -- Run the teardown functions.
                FOR tap IN SELECT * FROM _runem(teardown, false) LOOP RETURN NEXT tap; END LOOP;

                -- Remember how many failed and then roll back.
                num_faild := num_faild + num_failed();
                RAISE EXCEPTION '__TAP_ROLLBACK__';

            EXCEPTION WHEN raise_exception THEN
                IF SQLERRM <> '__TAP_ROLLBACK__' THEN
                    -- We didn't raise it, so propagate it.
                    RAISE EXCEPTION '%', SQLERRM;
                END IF;
            END;
        END LOOP;

        -- Run the shutdown functions.
        FOR tap IN SELECT * FROM _runem(shutdown, false) LOOP RETURN NEXT tap; END LOOP;

        -- Raise an exception to rollback any changes.
        RAISE EXCEPTION '__TAP_ROLLBACK__';
    EXCEPTION WHEN raise_exception THEN
        IF SQLERRM <> '__TAP_ROLLBACK__' THEN
            -- We didn't raise it, so propagate it.
            RAISE EXCEPTION '%', SQLERRM;
        END IF;
    END;
    -- Finish up.
    FOR tap IN SELECT * FROM _finish( currval('__tresults___numb_seq')::integer, 0, num_faild ) LOOP
        RETURN NEXT tap;
    END LOOP;

    -- Clean up and return.
    PERFORM _cleanup();
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- runtests( schema, match )
CREATE OR REPLACE FUNCTION runtests( NAME, TEXT )
RETURNS SETOF TEXT AS $$
    SELECT * FROM _runner(
        findfuncs( $1, '^startup' ),
        findfuncs( $1, '^shutdown' ),
        findfuncs( $1, '^setup' ),
        findfuncs( $1, '^teardown' ),
        findfuncs( $1, $2 )
    );
$$ LANGUAGE sql;

-- runtests( schema )
CREATE OR REPLACE FUNCTION runtests( NAME )
RETURNS SETOF TEXT AS $$
    SELECT * FROM runtests( $1, '^test' );
$$ LANGUAGE sql;

-- runtests( match )
CREATE OR REPLACE FUNCTION runtests( TEXT )
RETURNS SETOF TEXT AS $$
    SELECT * FROM _runner(
        findfuncs( '^startup' ),
        findfuncs( '^shutdown' ),
        findfuncs( '^setup' ),
        findfuncs( '^teardown' ),
        findfuncs( $1 )
    );
$$ LANGUAGE sql;

-- runtests( )
CREATE OR REPLACE FUNCTION runtests( )
RETURNS SETOF TEXT AS $$
    SELECT * FROM runtests( '^test' );
$$ LANGUAGE sql;
