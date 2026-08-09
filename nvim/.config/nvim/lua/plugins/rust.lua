return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        -- dap.adapter defaults to auto-detecting a mason-installed codelldb
        server = {
          on_attach = function(_, bufnr)
            local map = function(keys, func, desc)
              vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Rust: " .. desc })
            end
            map("<leader>ca", function()
              vim.cmd.RustLsp("codeAction")
            end, "Code action")
            map("<leader>rr", function()
              vim.cmd.RustLsp("runnables")
            end, "Runnables")
            map("<leader>rd", function()
              vim.cmd.RustLsp("debuggables")
            end, "Debuggables")
            map("K", function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end, "Hover actions")
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = true,
              check = { command = "clippy" },
              inlayHints = { lifetimeElisionHints = { enable = "skip_trivial" } },
            },
          },
        },
      }
    end,
  },
}
