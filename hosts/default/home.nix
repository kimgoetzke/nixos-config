{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.username = "kgoe";
  home.homeDirectory = "/home/kgoe";
  home.stateVersion = "24.05";
  home.packages = [
    # Development
    pkgs.jetbrains-toolbox
    pkgs.postman

    # Art
    pkgs.aseprite

    # Keyboard bindings
    pkgs.xorg.xmodmap
    pkgs.xorg.xev

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
  # TODO: Fix below
  #  ++ lib.optionals kd-gnome.kd-gnome.enable [
  #    # To customising keys mappings
  #    pkgs.xbindkeys
  #    pkgs.xte
  #  ];

  nixpkgs = {
    overlays = [
      inputs.nur.overlay
    ];
    config = {
      allowUnfree = true;
    };
  };

  imports = [
    ./../../modules/applications/_all.nix
  ];

  # Applications
  vscode.enable = true;
  vscode.withExtensions = true;
  firefox.enable = true;
  firefox.withProfile = true;
  alacritty.enable = true;
  git.enable = true;
  java.enable = true;

  # Shell
  # You must also update configuration.nix when changing the shell
  bash.enable = false;
  zsh.enable = true;
  home.shellAliases = {
    ls = "ls --color";
    c = "clear";
    nht = "nh os test ~/projects/nixos-config -H default";
    nhs = "nh os switch ~/projects/nixos-config -H default";
    proper = "cd ~/projects && ls -1";
    idea = "~/.local/share/JetBrains/Toolbox/apps/intellij-idea-ultimate/bin/idea.sh";
    anw = "alacritty msg create-window";
    ".2" = "cd ../..";
    ".3" = "cd ../../..";
    ".4" = "cd ../../../..";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kgoe/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;
}
