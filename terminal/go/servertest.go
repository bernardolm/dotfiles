package main

import (
	"fmt"
	"net/http"
	"os"
	"time"
)

func main() {
	fmt.Printf("serving on %s\n", os.Getenv("PORT"))
	http.HandleFunc("/", HelloServer)
	http.ListenAndServe(":"+os.Getenv("PORT"), nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "%v", time.Now())
}
