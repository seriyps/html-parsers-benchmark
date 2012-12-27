// Created by github.com/programmerby on 2012-12-26
// Part of github.com/seriyps/html-parsers-benchmark
package main

import (
	"fmt"
	"github.com/moovweb/gokogiri"
	"io/ioutil"
	"os"
	"strconv"
	"time"
)

func main() {
	if len(os.Args) < 3 {
		fmt.Println("Usage:", os.Args[0], "filename iterations")
		os.Exit(1)
	}

	filename := os.Args[1]
	n, _ := strconv.Atoi(os.Args[2])

	file, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}

	start := time.Now()
	for i := 0; i < n; i++ {
		doc, err := gokogiri.ParseHtml(file)
		if err != nil {
			panic(err)
		}
		doc.Root()
		doc.Free()
	}
	end := time.Now()

	fmt.Printf("%f s\n", end.Sub(start).Seconds())
}
