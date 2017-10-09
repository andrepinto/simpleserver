package main

import (
	"fmt"
	"log"
	"net/http"
	"github.com/gorilla/mux"
	"os"
	"net"
	"encoding/json"
	"github.com/gorilla/handlers"
)

type HttpResponse struct{
	Data 		interface{} 	`json:"data"`
	Ip 		[]string 	`json:"ip"`
	Environment 	string  	`json:"environment"`
}

func main() {


	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/", Index)
	router.HandleFunc("/{data}", Info)

	log.Println("server: localhost:3000")

	loggedRouter := handlers.LoggingHandler(os.Stdout, router)

	log.Fatal(http.ListenAndServe(":3000", loggedRouter))
}

func Index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "Simple Server!\n")
}

func Info(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	data := vars["data"]

	ips := []string{}

	host, _ := os.Hostname()
	addrs, _ := net.LookupIP(host)
	for _, addr := range addrs {
		if ipv4 := addr.To4(); ipv4 != nil {
			ips = append(ips, ipv4.String())
			//fmt.Println("IPv4: ", ipv4)
		}
	}

	response := &HttpResponse{
		Data: data,
		Ip: ips,
		Environment: os.Getenv("K8S_NAMESPACE"),
	}

	json.NewEncoder(w).Encode(response)
}
