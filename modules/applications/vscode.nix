{pkgs, inputs, config, lib, ...}:

{
  options.vscode = {
    enable = lib.mkEnableOption "Enable Visual Studio Code";
  };

  config = lib.mkIf config.vscode.enable {
    programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # Miscellanous
      github.copilot
      github.copilot-chat

      # Languages
      bbenoist.nix

      # UI
      arcticicestudio.nord-visual-studio-code
      pkief.material-icon-theme
    ];
  };
  };
}
