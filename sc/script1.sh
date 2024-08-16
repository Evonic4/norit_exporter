#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
fhome=/usr/share/norit/

psql "postgresql://user1:c4r45ty56y67tyfftyu67ty@1.2.3.4:5432/db1" -c " \
with tbl as ( \
  SELECT table_schema,table_name \
  FROM information_schema.tables \
  WHERE table_name not like 'pg_%' AND table_schema IN ('public') \
) \
SELECT \
  table_schema, \
  table_name, \
  (xpath('/row/c/text()', \
    query_to_xml(format('select count(*) AS c from %I.%I', table_schema, table_name), \
    false, \
    true, \
    '')))[1]::text::int AS rows_n \
FROM tbl ORDER BY 3 DESC;" > $fhome"otv/1.txt"

