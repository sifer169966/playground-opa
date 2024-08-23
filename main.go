package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"

	"github.com/open-policy-agent/opa/rego"
)

type Command struct {
	Cmd    string   `json:"Cmd"`
	Flags  []string `json:"Flags"`
	JSON   bool     `json:"JSON"`
	Stage  int      `json:"Stage"`
	SubCmd string   `json:"SubCmd"`
	Value  []string `json:"Value"`
}

func main() {
	input := `
	[
    	[
			{
				"Cmd": "from",
				"Flags": [],
				"JSON": false,
				"Stage": 0,
				"SubCmd": "",
				"Value": [
				"golang:latest",
				"AS",
				"builder"
				]
			},
			{
				"Cmd": "userxx",
				"Flags": [],
				"JSON": false,
				"Stage": 1,
				"SubCmd": "",
				"Value": [
				"$NONROOT_USER:$NONROOT_GROUP"
				]
			}
    	]
  	]
	`
	var inputData [][]Command
	err := json.Unmarshal([]byte(input), &inputData)
	if err != nil {
		log.Fatal(err)
	}
	r := rego.New(
		rego.Query("data.docker.deny[msg]"),
		rego.Load([]string{"./docker.rego"}, nil),
	)
	ctx := context.Background()
	q, err := r.PrepareForEval(ctx)
	if err != nil {
		log.Fatal(err)
	}
	results, err := q.Eval(ctx, rego.EvalInput(inputData[0]))
	if err != nil {
		log.Fatal(err)
	}
	var denyResons []string
	for _, result := range results {
		v, ok := result.Bindings["msg"].(string)
		if ok {
			denyResons = append(denyResons, v)
		}
	}
	if len(denyResons) > 0 {
		for i, reason := range denyResons {
			fmt.Printf("denial reason(%v) - %v\n", i, reason)
		}
	}
}
