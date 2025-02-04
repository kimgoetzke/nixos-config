return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'gbprod/nord.nvim', },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'nord'
        }
      }
    end
  }
}
