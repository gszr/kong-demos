/*
A "hello world" plugin in Go,
which reads a request header and sets a response header.
*/
package main

import (
	"fmt"
	"log"

	"github.com/Kong/go-pdk"
	"github.com/Kong/go-pdk/server"
)

type Config struct {
	Message string
}

func main() {
	server.StartServer(func() interface{} {
		return &Config{}
	}, "0.1", 1)
}

func (conf Config) Access(kong *pdk.PDK) {
	name, err := kong.Request.GetQueryArg("name")
	if err != nil {
		log.Printf(err.Error())
		return
	}

	message := conf.Message
	if message == "" {
		message = "hello"
	}

	kong.Response.SetHeader("x-hello-from-go",
		fmt.Sprintf("Go says %s to %s", message, name))
}
