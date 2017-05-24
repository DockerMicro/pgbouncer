#!/bin/sh
if [ ! -f /databases.ini ]; then
    echo "/databases.ini doesn't exist"

    if [ -z ${POSTGRES_PORT_5432_TCP_ADDR} ]; then
        env
        echo "POSTGRES_PORT_5432_TCP_ADDR is not set - can't generate default databases.ini"
        exit 1
    fi

    printf "\
[databases]
* = host=${POSTGRES_PORT_5432_TCP_ADDR} port=${POSTGRES_PORT_5432_TCP_PORT} auth_user=pgbouncer
" > /databases.ini

    echo -e "POSTGRES_PORT_5432_TCP_ADDR is set - generated default databases.ini pooling all connections to any DB\n"
fi

if [ ! -f /pg_hba.conf ]; then
    echo "/pg_hba.conf doesn't exist'"

    printf "\
local       all     all     peer
host        all     all     0.0.0.0/0       md5
" > /pg_hba.conf

    echo -e "Generated default pg_hba.conf allowing peer authenticated local (socket) connections and password md5 authenticated remote connections from any host to any database\n"
fi


echo "Starting pgbouncer..."
if [ -n "$PG_USER" ]; then
    exec /usr/bin/pgbouncer -u $PG_USER /pgbouncer.ini
else
    exec /usr/bin/pgbouncer -u postgres /pgbouncer.ini
fi