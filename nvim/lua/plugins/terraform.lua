return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          root_markers = { { ".terraform.lock.hcl", "main.tf" }, ".git" },
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
