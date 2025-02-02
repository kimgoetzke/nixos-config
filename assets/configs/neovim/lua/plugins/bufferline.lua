return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'gbprod/nord.nvim',
  },
  config = function()
    require('bufferline').setup {
      options = {
        separator_style = "thin",
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
        highlights = require("nord.plugins.bufferline").akinsho(),
      },
    }
  end,
}
