# my-pleroma

docker pleroma

## install

```
git clone --recursive https://github.com/WakuwakuP/my-pleroma.git
docker network create --driver bridge back-pleroma
docker-compose build
docker-compose up -d
```

## update

```sh
git submodule foreach git pull origin develop
docker-compose up -d --build

# build終了まで待つ

docker-compose exec web mix ecto.migrate
docker-compose restart web
```
