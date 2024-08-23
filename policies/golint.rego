package golint

import future.keywords.in
import future.keywords.if

default msg = []

# policies

deny[msg] {
	not found_errcheck
	msg := "golint errcheck must be enabled"
}
deny[msg] {
	not found_gosimple
	msg := "golint gosimple must be enabled"
}
deny[msg] {
	not found_gofmt
	msg := "golint gofmt must be enabled"
}
deny[msg] {
	not found_gosec
	msg := "golint gosec must be enabled"
}
deny[msg] {
	not found_ineffassign
	msg := "golint ineffassign must be enabled"
}
deny[msg] {
	not found_misspell
	msg := "golint misspell must be enabled"
}
deny[msg] {
	not found_revive
	msg := "golint revive must be enabled"
}
deny[msg] {
	not found_staticcheck
	msg := "golint staticcheck must be enabled"
}
deny[msg] {
	not found_unused
	msg := "golint unused must be enabled"
}


# helpers

found_bodyclose if {
    some lint in input.linters.enable
	lint == "bodyclose"
}
found_errcheck if {
    some lint in input.linters.enable
	lint == "errcheck"
}
found_gocyclo if {
    some lint in input.linters.enable
	lint == "gocyclo"
}
found_gofmt if {
    some lint in input.linters.enable
	lint == "gofmt"
    
}
found_goimports if {
    some lint in input.linters.enable
	lint == "goimports"
}
found_revive if {
    some lint in input.linters.enable
	lint == "revive"
}
found_gomnd if {
    some lint in input.linters.enable
	lint == "gomnd"
}
found_gosimple if {
    some lint in input.linters.enable
	lint == "gosimple"  
}
found_ineffassign if {
    some lint in input.linters.enable
	lint == "ineffassign"    
}
found_prealloc if {
    some lint in input.linters.enable
	lint == "prealloc"    
}
found_exportloopref if {
    some lint in input.linters.enable
	lint == "exportloopref"    
}
found_staticcheck if {
    some lint in input.linters.enable
	lint == "staticcheck"    
}
found_unconvert if {
    some lint in input.linters.enable
	lint == "unconvert"    
}
found_unparam if {
    some lint in input.linters.enable
	lint == "unparam"    
}
found_wsl if {
    some lint in input.linters.enable
	lint == "wsl"    
}
found_govet if {
    some lint in input.linters.enable
	lint == "govet"    
}
found_unused if {
    some lint in input.linters.enable
	lint == "unused"    
}
found_gosec if {
    some lint in input.linters.enable
	lint == "gosec"    
}
found_gci if {
    some lint in input.linters.enable
	lint == "gci"    
}
found_misspell if {
    some lint in input.linters.enable
	lint == "misspell"    
}
