return {
  {
    'nvim-mini/mini.base16',
    lazy = false,
    priority = 1000,
    config = function()
      require('mini.base16').setup {
        palette = require('custom.theme'),
      }
    end,
  },
}
