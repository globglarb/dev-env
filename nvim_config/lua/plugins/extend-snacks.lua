return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        win = {
          list = { wo = { wrap = true } },
          preview = {
            wo = {
              wrap = true, -- Enables line wrapping in the preview window
            },
          },
        },
      },
    },
  },
}
