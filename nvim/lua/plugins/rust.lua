local ESP_SYSROOT = os.getenv("HOME") .. "/.rustup/toolchains/esp"

local function channel_at(dir)
  local f = io.open(dir .. "/rust-toolchain.toml", "r")
  if not f then
    return nil
  end
  local channel
  for line in f:lines() do
    channel = channel or line:match('^%s*channel%s*=%s*"([^"]+)"')
  end
  f:close()
  return channel
end

return {
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
            },
            cargo = {
              allFeatures = false,
              features = "all",
            },
          },
        },
        settings = function(project_root, default_settings)
          local settings = vim.deepcopy(default_settings)
          local ra = settings["rust-analyzer"]

          -- Cross-compile / no_std projects pin a build target in .cargo/config.toml.
          -- Point rust-analyzer at that target and stop it building the test harness
          -- (the `test` crate needs std, which no_std targets don't have).
          local target
          local fd = io.open(project_root .. "/.cargo/config.toml", "r")
          if fd then
            for line in fd:lines() do
              if not line:match("^%s*%[") then
                target = target or line:match('^%s*target%s*=%s*"([^"]+)"')
              end
            end
            fd:close()
          end

          if target then
            ra.cargo.target = target
            ra.cargo.allTargets = false
            ra.check = ra.check or {}
            ra.check.allTargets = false
            -- Isolate RA's clippy cache from terminal `cargo build`/espflash runs.
            -- Sharing one target dir makes rustc and clippy artifacts invalidate
            -- each other, forcing repeated build-std `core` recompiles.
            ra.check.extraArgs = { "--target-dir", "target/ra-check" }
          end

          if channel_at(project_root) == "esp" then
            -- The esp channel is a rustc fork. Its proc-macros have an ABI the stock
            -- rust-analyzer can't load (the frontend/expander are too far ahead), and
            -- no matching RA is shipped for the esp toolchain. So real expansion is a
            -- lost cause here. Instead, treat the entry-point attribute macros as
            -- identity (`ignored`) — handled in the RA frontend, no expander needed —
            -- so RA still analyzes the `fn main` body (gd/completion) instead of
            -- treating the whole macro-annotated item as opaque.
            if vim.uv.fs_stat(ESP_SYSROOT) then
              ra.cargo.sysroot = ESP_SYSROOT
            end
            ra.procMacro = ra.procMacro or {}
            ra.procMacro.enable = true
            ra.procMacro.ignored = {
              esp_hal_procmacros = { "main", "ram", "handler" },
              xtensa_lx_rt_proc_macros = { "entry", "exception", "interrupt" },
            }
            -- Every derive/function-like macro from esp-built deps (thiserror, etc.)
            -- fails to expand with the same ABI error. Since no proc-macro can expand
            -- on the esp fork with the stock RA, that code is pure noise — suppress it.
            -- Real type/borrow errors use other diagnostic codes and still show.
            ra.diagnostics = ra.diagnostics or {}
            ra.diagnostics.disabled = { "macro-error", "unresolved-proc-macro" }
          end

          return settings
        end,
      },
    },
  },
}
