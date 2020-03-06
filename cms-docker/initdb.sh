#!/bin/bash

psql --username=cmsuser --dbname=cmsdb --command='ALTER SCHEMA public OWNER TO cmsuser'
psql --username=cmsuser --dbname=cmsdb --command='GRANT SELECT ON pg_largeobject TO cmsuser'
