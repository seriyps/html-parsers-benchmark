// Created by github.com/programmerby on 2012-12-26
// Part of github.com/seriyps/html-parsers-benchmark
package main

import (
	exp_html "exp/html"
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
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
	html := string(file)

	start := time.Now()
	for i := 0; i < n; i++ {
		doc, err := exp_html.Parse(strings.NewReader(html))
		if err != nil {
			panic(err)
		}
		if doc.FirstChild != nil {
		}
	}
	end := time.Now()

	fmt.Printf("%f s\n", end.Sub(start).Seconds())
}
