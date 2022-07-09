postgres:
	docker run --name postgres14 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=password -p 5557:5432 -d postgres:14-alpine

createdb:
	docker exec -it postgres14 createdb --username=root --owner=root simple_bank 

dropdb:
	docker exec -it postgres14 dropdb simple_bank

migrateup:
	migrate -path db/migration/ -database "postgresql://root:password@localhost:5557/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration/ -database "postgresql://root:password@localhost:5557/simple_bank?sslmode=disable" -verbose down

makeFileDir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

sqlc:
	docker run --rm -v $(makeFileDir):/src -w /src kjconroy/sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc