# pleroma

docker pleroma

## install

[nginx-proxy](https://github.com/wakuwakup/nginx-proxy-docker-compose)を作成する

```
git clone --recursive https://github.com/WakuwakuP/pleroma.git
docker network create --driver bridge back-pleroma
docker-compose build
docker-compose up -d
```

## update

```sh
git submodule foreach git pull origin stable
docker-compose build

# build終了まで待つ

docker-compose run --rm web mix ecto.migrate
docker-compose down
docker-compose up -d
```

```sh
# db backup
docker-compose exec db pg_dump -d pleroma -U pleroma --format=custom -f /pgdump/pleroma.pgdump

# db restore
docker-compose exec db pg_restore -d pleroma -U pleroma -v -1 /pgdump/pleroma.pgdump
```
