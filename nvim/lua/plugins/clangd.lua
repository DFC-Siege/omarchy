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
          "--function-arg-placeholders",
          "--fallback-style=llvm",
          "--compile-commands-dir=.",
          "--query-driver=**",
          "--enable-config",
        },
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern(
            "platformio.ini",
            "compile_commands.json",
            ".clangd",
            ".clang-format"
          )(fname)
        end,
      },
      ccls = {
        enabled = false,
      },
    },
  },
}
