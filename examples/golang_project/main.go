// from https://templ.guide/server-side-rendering/creating-an-http-server-with-templ
package main

import (
	"log"
	"net/http"

	"github.com/a-h/templ"
)

func main() {
	http.Handle("/", templ.Handler(hello()))

	log.Println("listening on :8080")
	http.ListenAndServe(":8080", nil)
}
