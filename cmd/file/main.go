package main

import (
	"log"
	"net/http"
	"os"
	"github.com/pressly/chi"
	"github.com/ChaosXu/nerv/lib/env"
	chttp "github.com/ChaosXu/nerv/lib/net/http/file"
)

var (
	Version = "main.min.build"
)

func main() {
	log.Println(os.Getwd())
	log.Println("Version:" + Version)
	env.Init()

	port := env.Config().GetMapString("http", "port")
	if port == "" {
		log.Fatalln("http_port isn't setted")
	}

	r := chi.NewRouter()
	routing(r)

	log.Fatalln(http.ListenAndServe(":" + port, r))
}

func routing(r *chi.Mux) {

	for url, file := range env.Config().GetMap("files") {
		log.Printf("file router: %s -> %s", url, file)
		FileServer(r, url, chttp.Dir(file.(string)))
	}

	for url, file := range env.Config().GetMap("uploads") {
		log.Printf("upload router: %s -> %s", url, file)
		chttp.UploadServer(r, url, file.(string))
	}
}
