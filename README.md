# pleroma
my pleroma config

## update

```sh
git submodule foreach git pull origin develop
docker-compose up -d --build

# build終了まで待つ

docker-compose exec web mix ecto.migrate
docker-compose restart web
```
