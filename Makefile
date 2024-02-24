help:
	@echo "Usage:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ":" | sed -e 's/^/  /'

## tests: Run unit tests
tests:
	go test -v ./...

## tests-coverage: Generate report for unit test coverage
tests-coverage:
	go test -coverprofile cover.out ./...
	go tool cover -html=cover.out

## tests-report: View report of all tests results
tests-report:
	go test ./... -json | tparse -all

## build: Builds the binary
build:
	go build -o bin/servomatic main.go

## start: Starts the web server. Used for local development
start:
	go run main.go -p=8084 -d=.

## clean: Cleans the bin folder and build artefacts
clean:
	@echo "Cleaning bin folder..."
	@rm -rf build

## compile: Compiles the production binaries
compile: clean
	@echo "Compiling for supported platforms..."
	GOOS=linux GOARCH=386 go build -ldflags="-extldflags=-static" -o build/servomatci-linux-386 main.go
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-extldflags=-static" -o build/servomatci-linux-amd64 main.go
	GOOS=windows GOARCH=386 go build -o build/servomatci-windows-386.exe main.go

install: compile
	@echo "Installing..."
	@sudo mkdir -p /usr/local/bin
	@sudo cp build/servomatci-linux-386 /usr/local/bin/servomatic

all: build
