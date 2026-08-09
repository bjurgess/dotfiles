return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "Git hunk" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Debug" },
        { "<leader>s", group = "Split" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>b", group = "Buffer" },
        { "<leader>h", group = "Harpoon" },
        { "<leader>r", group = "Rust/Rename" },
      },
    },
  },
}
