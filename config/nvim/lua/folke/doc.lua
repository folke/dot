local docgen = require("babelfish")
local metadata = {
  input_file = "./README.md",
  output_file = "doc/lsp-trouble.txt",
  project_name = "lsp-trouble",
}
docgen.generate_readme(metadata)
