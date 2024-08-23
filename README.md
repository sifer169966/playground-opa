# POC - Open Policy Agent
try the taste of OPA(Open Policy Agent) to see if its adoption can be fit in our cases

## Introduction

The Open Policy Agent is a powerful policy-based that uses True/False engine, which makes it convenient to read and understand the policy. Since it’s a policy that can be applied to the digital world we can apply it anywhere we want

## Glossary

<b>Conftest</b> is a utility to helps you write tests against structured configuration data in many formats since the OPA only supports the input as the JSON format. See more detail

<b>OPA</b> - or Open Policy Agent, is a policy language and framework designed to be language-agnostic. OPA provides a declarative policy language called Rego (pronounced "ray-go") for expressing policies. Rego is specifically designed for expressing complex policy logic concisely.

<b>Rego</b> - Rego is a declarative policy language specifically designed for use with the Open Policy Agent (OPA)

## Installation

since we use conftest to test our policy, let’s install it by choosing your preferred installation

Use Cases

Golang-CI Configuration

we can write the policy against our.golangci.yaml file to apply our policy for the configuration of that file. This an example of usage the policy for this file

golint.rego

```sh
package golint

import future.keywords.in

default msg = []

lint_must_enable_msg(lintCtx) := sprintf("%v must be enabled",[lintCtx])

# policies

deny[msg] {
    lint := "bodyclose"
    not found_lint(lint)
    msg := lint_must_enable_msg(lint)
}
deny[msg] {
    lint := "gosimple"
    not found_lint(lint)
    msg := lint_must_enable_msg(lint)
}
deny[msg] {
    lint := "gofmt"
    not found_lint(lint)
    msg := lint_must_enable_msg(lint)
}
deny[msg] {
    lint := "gosec"
    not found_lint(lint)
    msg := lint_must_enable_msg(lint)
}
deny[msg] {
    lint := "ineffassign"
    not found_lint(lint)
    msg := lint_must_enable_msg(lint)
}
deny[msg] {
    lint := "misspell"
    not found_lint(lint)
    msg := lint_must_enable_msg(lint)
}
deny[msg] {
    lint := "revive"
    not found_lint(lint)
    msg := lint_must_enable_msg(lint)
}
deny[msg] {
    lint := "staticcheck"
    not found_lint(lint)
    msg := lint_must_enable_msg(lint)
}
deny[msg] {
    lint := "unused"
    not found_lint(lint)
    msg := lint_must_enable_msg(lint)
}


# helpers

found_lint(lint) {
    input.linters.enable[_] == lint
}
```

you can copy this file to your local and try it for your .golangci.yaml file by running this command below

```sh
conftest test -p golint.rego -n golint .golangci.yaml
```



## Dockerfile

we can write the policy against our Dockerfile file to apply our policy for the Dockerfile instruction. This is an example of usage the policy for this file

docker.rego

```sh
package docker

import future.keywords.if
import future.keywords.in

deny[msg] {
	not found_nonroot_user
	msg := "not found nonroot user from the last stage"
}

warn[msg] {
    found_latest_image
    msg := "avoid using of the latest of image version"
}


found_latest_image if {
    some cmds in input
    cmds.Cmd == "from"
    some v in cmds.Value
    contains(v, "latest")
}

found_nonroot_user if {
    last_stage := input[count(input) - 1].Stage
    some cmds in input
    cmds.Stage == last_stage
    cmds.Cmd == "user"
}
```

The above policy forces the Dockerfile instruction to run the container as a non-root user and warns when we use the latest tag for any images

you can copy this file content to your local and try it for your Dockerfile file by running this command below

```sh
conftest test -p docker.rego -n docker Dockerfile
```



## Apply in Golang


```go
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
	denys, err := q.Eval(ctx, rego.EvalInput(inputData[0]))
	if err != nil {
		log.Fatal(err)
	}
	var denyResons []string
	for _, deny := range denys {
		v, ok := deny.Bindings["msg"].(string)
		if ok {
			denyResons = append(denyResons, v)
		}
	}
	for i, reason := range denyResons {
		fmt.Printf("denial reason(%v) - %v\n", i, reason)
	}
}
```

from the above, we use the same policy of docker.rego but apply it to our Golang application.



## Conclusion

OPA, or the Open Policy Agent, is a policy language and framework designed to be language-agnostic. OPA itself provides a declarative policy language called Rego. so, we can apply the same policy across all stack