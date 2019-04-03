build:
	docker-compose build

run: build
	docker-compose down && docker-compose up

