start:
	node index.js

clean:
	docker rm node-blog -f
	docker image rm node-blog-image
	docker image ls

build: clean
	docker build -t node-blog-image .

dev: build
	docker run -d -p 3000:3000 --name node-blog node-blog-image
	docker exec -it node-blog bash