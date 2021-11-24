start:
	npm run dev

clean:
	docker rm node-blog -vf || true
	docker image rm node-blog-image || true
	docker image ls

build: clean
	docker build -t node-blog-image .

run: build
	docker run -v `pwd`:/app:ro -d -v /app/node_modules --env-file ./.env -p 3000:3000 --name node-blog node-blog-image

bash:
	docker inspect -f '{{ .Mounts }}' $(docker ps -aqf "name=^node-blog?")
	docker exec -it node-blog bash

down:
	docker-compose down -v

dev:
	docker-compose up -d --build