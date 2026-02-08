return {
    {
        "bjarneo/aether.nvim",
        branch = "v2",
        name = "aether",
        priority = 1000,
        opts = {
            transparent = false,
            colors = {
                -- Background colors
                bg = "#151317",
                bg_dark = "#151317",
                bg_highlight = "#88828d",

                -- Foreground colors
                -- fg: Object properties, builtin types, builtin variables, member access, default text
                fg = "#fcf8f1",
                -- fg_dark: Inactive elements, statusline, secondary text
                fg_dark = "#e7d3aa",
                -- comment: Line highlight, gutter elements, disabled states
                comment = "#88828d",

                -- Accent colors
                -- red: Errors, diagnostics, tags, deletions, breakpoints
                red = "#be6e6a",
                -- orange: Constants, numbers, current line number, git modifications
                orange = "#dcaaa8",
                -- yellow: Types, classes, constructors, warnings, numbers, booleans
                yellow = "#cf9b6d",
                -- green: Comments, strings, success states, git additions
                green = "#ecbf75",
                -- cyan: Parameters, regex, preprocessor, hints, properties
                cyan = "#b6b2c3",
                -- blue: Functions, keywords, directories, links, info diagnostics
                blue = "#9ea3b8",
                -- purple: Storage keywords, special keywords, identifiers, namespaces
                purple = "#c0a5b7",
                -- magenta: Function declarations, exception handling, tags
                magenta = "#e6dae2",
            },
        },
        config = function(_, opts)
            require("aether").setup(opts)
            vim.cmd.colorscheme("aether")

            -- Enable hot reload
            require("aether.hotreload").setup()
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "aether",
        },
    },
}
