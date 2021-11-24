start:
	npm run dev

clean:
	docker rm backend-blog -vf || true
	docker image rm backend-image || true
	docker rm database-blog -vf || true
	docker image ls

build: clean
	docker build -t backend-image .

run: build
	docker run -v `pwd`:/app:ro -d -v /app/node_modules --env-file ./.env -p 3000:3000 --name backend-blog backend-image

bash-node:
	docker inspect -f '{{ .Mounts }}' backend-blog
	docker exec -it backend-blog bash

bash-mongo:
	docker exec -it database-blog mongo -u "pqtrng" -p "devpassword"

down:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml down

dev:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build

prod:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build