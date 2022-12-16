#!/bin/sh
CMD=$1

cd "$(dirname "$0")"

usage() {
cat <<USAGE
Usage: $0 [command]
        setup           - build, configure, initialize
        build           - build images
        configure       - generate config files
        initialize      - initialize database
        start           - start Pleroma
        stop            - stop Pleroma
USAGE
}

build() {
        echo
        echo Building images
        docker-compose build
}

mk_pleroma_config() {
        echo
        echo Generating Pleroma config
        echo "DBのホスト名は postgres にしてください"
        echo "DBのパスワードは事前に設定したものを使用してください"
        echo "Pleromaのlisten address は 0.0.0.0 にしてください"
        echo
        mkdir -p data/pleroma/config/
        mkdir -p data/pleroma/content/uploads/
        mkdir -p data/pleroma/content/static/emoji/
        sudo chown -R 911:911 data/pleroma/content/uploads/
        sudo chown -R 911:911 data/pleroma/content/static/emoji/
        touch data/pleroma/config/config.exs
        PLEROMA_CFG_CMD='/opt/pleroma/bin/pleroma_ctl instance gen --force --output /tmp/config/config.exs --output-psql /tmp/config/setup_db.psql'
        docker-compose -f docker-compose.yml -f docker-compose-init.yml run --no-deps --user root --entrypoint /bin/sh --rm web $PLEROMA_CFG_CMD
}

mk_config() {
        mk_pleroma_config
}

init_db() {
        echo
        echo Initializing database

        docker-compose -f docker-compose.yml -f docker-compose-init.yml up -d postgres
        sleep 10
        docker-compose exec --user postgres db psql -f /tmp/config/setup_db.psql
        docker-compose run --rm --entrypoint='/opt/pleroma/bin/pleroma_ctl migrate' web
        docker-compose stop postgres
        docker-compose rm --force postgres
}

start() {
        docker-compose up -d
        docker-compose ps
}

stop() {
        docker-compose stop
}

if [ -z "$CMD" ]; then
        usage
        exit 1
fi
case "$CMD" in
        setup)
                build
                mk_config
                init_db
        ;;
        build)
                build
        ;;
        configure)
                mk_config
        ;;
        pleroma-config)
                mk_pleroma_config
        ;;
        initialize)
                init_db
        ;;
        start)
                start
        ;;
        stop)
                stop
        ;;
        *)
                usage
                exit 1
        ;;
esac