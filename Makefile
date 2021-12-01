ifneq (,$(wildcard ./.env))
    include .env
    export
endif

start:
	npm run dev

clean:
	docker rm $(BACKEND_CONTAINER) -vf || true
	docker image rm $(BACKEND_IMAGE) || true
	docker rm $(DATABASE_CONTAINER) -vf || true
	docker rm $(AUTH_CONTAINER) -vf || true
	docker image ls

build: clean
	docker build -t $(BACKEND_IMAGE) .

run: build
	docker run -v `pwd`:/app:ro -d -v /app/node_modules --env-file ./.env -p 3000:3000 --name $(BACKEND_CONTAINER) $(BACKEND_IMAGE)

bash-node:
	docker inspect -f '{{ .Mounts }}' $(BACKEND_CONTAINER)
	docker exec -it $(BACKEND_CONTAINER) bash

bash-mongo:
	docker exec -it $(DATABASE_CONTAINER) mongo -u $(DATABASE_USER) -p $(DATABASE_PASSWORD)

bash-redis:
	docker exec -it $(AUTH_CONTAINER) redis-cli

down:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml down

down-v:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml down -v

dev:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build

log: dev
	docker logs $(BACKEND_CONTAINER) -f

dev-v:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build -V

prod:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build