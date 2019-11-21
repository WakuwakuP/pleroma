# pleroma

docker pleroma

## install

nginx-proxyを作成する

```
git clone --recursive https://github.com/WakuwakuP/my-pleroma.git
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
