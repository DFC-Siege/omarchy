-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.keymap.set({ "v", "x" }, "<leader>y", [["+y]], {
  desc = "Yank to system clipboard (No motion)",
  noremap = true,
})
