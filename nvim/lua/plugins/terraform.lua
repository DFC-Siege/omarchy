return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(".terraform.lock.hcl", "main.tf")(fname)
              or util.find_git_ancestor(fname)
          end,
          init_options = {
            indexing = {
              ignorePaths = { ".terraform/**", "**/.terraform/**" },
            },
          },
        },
      },
    },
  },
}
