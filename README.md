# my-pleroma

docker pleroma

## install

### nginx-proxy

<https://github.com/WakuwakuP/my-proxy-nginx>

```shell
git clone https://github.com/WakuwakuP/my-proxy-nginx.git
docker network create --driver front
docker-compose build
docker-compose up -d
```

### Pleroma起動

```shell
git clone --recursive https://github.com/WakuwakuP/my-pleroma.git
cp .env.sample .env
vi .env
```

```shell
docker network create --driver bridge back-pleroma
docker-compose build
docker-compose up -d
```

## Update

```shell
docker-compose exec web /opt/pleroma/bin/pleroma_ctl update
docker-compose exec web /opt/pleroma/bin/pleroma_ctl migrate
```

## Backup / Restore

```sh
# db backup
docker-compose exec db pg_dump -d pleroma -U pleroma --format=custom -f /pgdump/pleroma.pgdump

# db restore
docker-compose exec db pg_restore -d pleroma -U pleroma -v -1 /pgdump/pleroma.pgdump
```

## ~~update~~ (archived)

```sh
git submodule foreach git pull origin stable
docker-compose build

# build終了まで待つ

docker-compose run --rm web mix ecto.migrate
docker-compose down
docker-compose up -d
```
