package main

default allowed = false


allowed {

}

# allowed {
#   input.file.path == ".golangci.yml"
#   input.file.exists
#     print("File Contents:", input.file.contents)
#   validConfiguration(input.file.contents)
# }

# validConfiguration(contents) {
    
#   contains(contents, "linters:")
#   contains(contents, "enable:")
# }

# contains(s, substr) {
#   indexOf := indexof(s, substr)
#   indexOf != -1
# }