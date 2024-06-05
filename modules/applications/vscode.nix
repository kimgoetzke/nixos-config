{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.vscode;
in {
  options.vscode = {
    enable = lib.mkEnableOption "Enable VS Code";
    withExtensions = lib.mkEnableOption "Enable extensions for VS Code"; # TODO: Implement this
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        # Miscellanous
        k--kato.intellij-idea-keybindings
        github.copilot
        github.copilot-chat

        # Languages
        bbenoist.nix

        # UI
        arcticicestudio.nord-visual-studio-code
        pkief.material-icon-theme
      ];
      keybindings = [
        {
          "key" = "ctrl+oem_5 ctrl+c";
          "command" = "editor.action.commentLine";
          "when" = "editorTextFocus && !editorReadonly";
        }
        {
          "key" = "ctrl+oem_5 ctrl+v";
          "command" = "editor.action.blockComment";
          "when" = "editorTextFocus && !editorReadonly";
        }
        {
          "key" = "ctrl+oem_5 ctrl+f";
          "command" = "workbench.action.findInFiles";
        }
        {
          "key" = "ctrl+oem_5 ctrl+r";
          "command" = "editor.action.rename";
          "when" = "editorHasRenameProvider && editorTextFocus && !editorReadonly";
        }
        {
          "key" = "ctrl+oem_5 ctrl+d";
          "command" = "editor.action.clipboardCutAction";
        }
        {
          "key" = "ctrl+shift+alt+]";
          "command" = "workbench.panel.chat.view.copilot.focus";
        }
      ];
    };
  };
}
