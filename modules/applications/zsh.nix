{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.zsh;
in {
  options.zsh = {
    enable = lib.mkEnableOption "Enable zsh and all related config";
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    stylix.targets.fzf.enable = true;
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      useTheme = "nordtron"; # Will be ignored if 'settings' is used
      settings =
        builtins.fromJSON (builtins.readFile (builtins.toFile "kim-nord.omp.json" (builtins.readFile ./../../assets/configs/oh-my-posh/kim-nord.omp.json)));
    };
    programs.zsh = {
      enable = true;
      initExtra = ''
        # Set the directory to store Zinit and plugins
        ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"

        # Download Zinit, if required
        if [ ! -d "$ZINIT_HOME" ]; then
           mkdir -p "$(dirname $ZINIT_HOME)"
           git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
        fi

        # Source/load Zinit
        source "''${ZINIT_HOME}/zinit.zsh"

        # Add zsh plugins
        zinit light zsh-users/zsh-syntax-highlighting
        zinit light zsh-users/zsh-completions
        zinit light zsh-users/zsh-autosuggestions
        zinit light Aloxaf/fzf-tab

        # Add snippets
        zinit snippet OMZP::git
        zinit snippet OMZP::sudo

        # Load completions
        autoload -Uz compinit && compinit
        zinit cdreplay -q

        # Keybindings
        bindkey '^f' autosuggest-accept
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward

        # History
        HISTSIZE=5000
        HISTFILE=~/.zsh_history
        SAVEHIST=$HISTSIZE
        HISTDUP=erase
        setopt appendhistory
        setopt sharehistory
        setopt hist_ignore_space
        setopt hist_ignore_all_dups
        setopt hist_save_no_dups
        setopt hist_ignore_dups
        setopt hist_find_no_dups

        # Completion styling
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # Auto-completion is now case-insensitive
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}" # Use LS_COLORS for completion coloring
        zstyle ':completion:*' menu no # Disable completion menu
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

        # Aliases from initExtra
        alias ls='ls --color -2'
        alias c='clear'
      '';
    };
  };
}
