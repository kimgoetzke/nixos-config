{
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;
      window = {
        position = "left";
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<C-n>";
        action = "<cmd>Neotree toggle<cr>";
        options = {
          desc = "NeoTree toggle";
          remap = true;
        };
      }
    ];
  };
}
