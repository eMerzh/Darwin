BEGIN;
set search_path=darwin2,public;

alter table gtu add column loc POINT;
DROP INDEX IF EXISTS idx_gtu_location;
DROP INDEX IF EXISTS idx_gtu_location_geom;

alter table specimens add column gtu_loc POINT;
DROP INDEX IF EXISTS idx_gist_specimens_gtu_location_geom;
DROP INDEX IF EXISTS idx_gist_specimens_gtu_location;

SET SESSION session_replication_role = replica;

update gtu set loc = POINT(latitude, longitude) where latitude is not null;

update specimens s set gtu_loc = (select loc from gtu g where g.id = s.gtu_ref and latitude is not null) where s.gtu_ref is not null;


SET SESSION session_replication_role = origin;

drop view labeling;

alter table gtu drop column location;
alter table gtu rename column loc to location;

alter table specimens drop column gtu_location;
alter table specimens rename column gtu_loc to gtu_location;

\i reports/ticketing/labeling.sql

CREATE INDEX idx_gtu_location on gtu using gist(location);
CREATE INDEX idx_gist_specimens_gtu_location on specimens using gist(gtu_location);

COMMIT;

SELECT 'CLEANUP Postgis';
BEGIN;

\i /usr/share/postgresql/9.1/contrib/postgis-1.5/uninstall_postgis.sql

COMMIT;
