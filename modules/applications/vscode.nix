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
      package = pkgs.vscode.fhs;
      # If extensions don't work, try https://github.com/arvigeus/nixos-config/blob/master/apps/vscode.nix
      extensions = with pkgs.vscode-extensions; [] ++ lib.optional cfg.withExtensions [
        # Miscellanous
        k--kato.intellij-idea-keybindings
        github.copilot
        github.copilot-chat

        # Languages
        bbenoist.nix
        jnoortheen.nix-ide

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
      userSettings = {
        # General
        "editor.inlineSuggest.enabled" = true;
        "window.titleBarStyle" = "custom";
        # "editor.fontFamily" = "'FiraCode Nerd Font', 'FiraCode Nerd Font Mono', 'monospace', monospace";

        # Git
        "git.autofetch" = true;
        "git.confirmSync" = false;

        # Formatters
        "[html]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[css]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[markdown]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[scss]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[typescriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      
        # Nix
        "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
        "nix.serverSettings"."nil"."formatting"."command" = ["${pkgs.alejandra}/bin/alejandra"];
      };
    };
  };
}
