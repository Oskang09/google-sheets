package main

import (
	"log"
)

// IndexData :
type IndexData struct {
	One   string `gs:"0"`
	Two   string `gs:"0"`
	Three string `gs:"0"`
}

func main() {
	data := make([]IndexData, 0)
	gs := NewGS("https://docs.google.com/spreadsheets/d/1uV032Lgm-HfQ-mAgcb7PPHdLcOATNYA1NYDI557xZWk")
	gs.Get(&data)
	log.Println(data)

	data2 := make([]*IndexData, 0)
	gs.Get(&data2)
	log.Println(data2)
}
