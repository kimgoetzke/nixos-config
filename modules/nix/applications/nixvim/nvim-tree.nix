{
  programs.nixvim = {
    plugins.nvim-tree = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<C-n>";
        action = "<cmd>NvimTreeToggle<cr>";
        options = {
          desc = "Move focus to the upper window";
          remap = true;
        };
      }
    ];
  };
}
