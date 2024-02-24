package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
)

func printHelp() {
	fmt.Println("usage: servomatic -p <port> -d <directory>")
}

func main() {
	help := flag.Bool("h", false, "help")
	port := flag.Int("p", 8083, "port")
	directory := flag.String("d", ".", "directory")
	flag.Parse()
	if *help {
		printHelp()
		return
	}
	http.Handle("/", http.FileServer(http.Dir(*directory)))
	fmt.Printf("Serving %s on HTTP port: %d\n", *directory, *port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", *port), nil))
}
