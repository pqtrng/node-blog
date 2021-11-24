start:
	npm run dev

clean:
	docker rm node-blog -vf || true
	docker image rm node-blog-image || true
	docker rm mongo-blog -vf || true
	docker image ls

build: clean
	docker build -t node-blog-image .

run: build
	docker run -v `pwd`:/app:ro -d -v /app/node_modules --env-file ./.env -p 3000:3000 --name node-blog node-blog-image

bash-node:
	docker inspect -f '{{ .Mounts }}' node-blog
	docker exec -it node-blog bash

bash-mongo:
	docker exec -it mongo-blog mongo -u "pqtrng" -p "devpassword"

down:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml down

dev:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build

prod:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
