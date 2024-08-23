package golintv2

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
