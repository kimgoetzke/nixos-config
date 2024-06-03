{pkgs, inputs, ...}: 

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      github.copilot
      github.copilot-chat

      # Languages
      bbenoist.nix

      # UI
      arcticicestudio.nord-visual-studio-code
      pkief.material-icon-theme
    ];
  };
}