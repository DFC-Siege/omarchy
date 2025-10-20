return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        enabled = true,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders=true",
          "--query-driver=**",
          "--enable-config",
        },
      },
      ccls = {
        enabled = false,
      },
    },
  },
}
