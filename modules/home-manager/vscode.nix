{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.vscode;
in {
  options.vscode = {
    enable = lib.mkEnableOption "Enable VS Code";
    withExtensions = lib.mkEnableOption "Enable extensions for VS Code";
  };

  config = lib.mkIf cfg.enable {
    stylix.targets.vscode.enable = false;
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      mutableExtensionsDir = false;
      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        extensions = lib.mkIf cfg.withExtensions (with pkgs.vscode-extensions; [
          # Miscellaneous
          k--kato.intellij-idea-keybindings
          github.copilot
          github.copilot-chat
          esbenp.prettier-vscode
          eamodio.gitlens
          tamasfe.even-better-toml
          mkhl.direnv

          # Languages
          bbenoist.nix
          jnoortheen.nix-ide
          rust-lang.rust-analyzer
          vadimcn.vscode-lldb # Rust and C++ debugger

          # UI
          arcticicestudio.nord-visual-studio-code
          pkief.material-icon-theme
          gruntfuggly.todo-tree
        ]);
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
          "editor.mouseWheelZoom" = true;
          "window.customTitleBarVisibility" = "never";
          "window.menuBarVisibility" = "toggle";
          "workbench.editor.editorActionsLocation" = "hidden";
          "workbench.colorTheme" = lib.mkDefault "Nord";
          "workbench.colorCustomizations" = {
            "editor.background" = lib.mkForce "#232831";
            "editorGutter.background" = lib.mkForce "#232831";
            "editorInlayHint.background" = lib.mkForce "#232831";
            "editorInlayHint.foreground" = lib.mkForce "#4c566a";
            "minimap.background" = lib.mkForce "#232831";
          };
          "editor.fontSize" = lib.mkDefault 18;
          "editor.fontFamily" = lib.mkDefault "'JetBrainsMono Nerd Font', 'FiraCode Nerd Font Mono', 'monospace', monospace";

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
  };
}
