-- Roslyn floods publishDiagnostics for the whole solution (~1300 files) on load,
-- creating a phantom buffer per URI and storming the main loop with redraws.
-- Drop diagnostics for any file that isn't currently open in a loaded buffer.
local function drop_unopened(handler)
  return function(err, result, ctx, config)
    if result and result.uri then
      local bufnr = vim.fn.bufnr(vim.uri_to_fname(result.uri))
      if bufnr == -1 or not vim.api.nvim_buf_is_loaded(bufnr) then
        return
      end
    end
    return handler(err, result, ctx, config)
  end
end

return {
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {
      filewatching = "off",
    },
    init = function()
      vim.lsp.config("roslyn", {
        cmd_env = {
          DOTNET_gcServer = "0",
          DOTNET_GCConserveMemory = "9",
          DOTNET_GCRetainVM = "0",
          DOTNET_GCHeapHardLimit = "100000000",
        },
        handlers = {
          ["textDocument/publishDiagnostics"] = drop_unopened(
            vim.lsp.handlers["textDocument/publishDiagnostics"]
          ),
        },
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = false,
            dotnet_enable_tests_code_lens = false,
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = false,
            dotnet_provide_regex_completions = false,
          },
          ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = false,
          },
          ["navigation"] = {
            dotnet_navigate_to_decompiled_sources = false,
          },
        },
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "roslyn-language-server" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = { enabled = false },
        -- nvim-lspconfig auto-enables its own roslyn (roslyn_ls); we use
        -- seblyng/roslyn.nvim instead. Two servers double-analyze and flood
        -- diagnostics, pegging the main loop.
        roslyn_ls = { enabled = false },
      },
    },
    init = function()
      vim.lsp.enable("roslyn_ls", false)
    end,
  },
}
