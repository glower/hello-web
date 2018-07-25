package handlers

import (
	"fmt"
	"net/http"
)

// ping is a simple HTTP handler function which writes a response.
func ping(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "pong")
}
