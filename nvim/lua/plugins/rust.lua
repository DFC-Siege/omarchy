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
          end

          return settings
        end,
      },
    },
  },
}
