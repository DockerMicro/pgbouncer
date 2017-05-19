#!/bin/sh
if [ -n "$PG_USER" ]; then
    /usr/bin/pgbouncer -u ${PG_USER} /pgbouncer.ini
else
    /usr/bin/pgbouncer /pgbouncer.ini
fi