package docker

import future.keywords.if
import future.keywords.in

deny[msg] {
	not found_nonroot_user
	msg := "not found nonroot user from the last stage"
}

deny[msg] {
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

# Debug statements
debug_nonroot[msg] {
	not found_nonroot_user
	msg := "not found nonroot user"
}
