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
        # (Thanks to https://stackoverflow.com/questions/5407916/zsh-zle-shift-selection)

        # Cut
        zle -N widget::cut-selection
        function widget::cut-selection() {
            if ((REGION_ACTIVE)) then
                zle kill-region
                printf "%s" $CUTBUFFER | xclip -selection clipboard
            fi
        }
        bindkey '^X' widget::cut-selection

        # Clear
        r-delregion() {
          if ((REGION_ACTIVE)) then
             zle kill-region
          else
            local widget_name=$1
            shift
            zle $widget_name -- $@
          fi
        }

        # Deselect
        r-deselect() {
          ((REGION_ACTIVE = 0))
          local widget_name=$1
          shift
          zle $widget_name -- $@
        }

        # Select
        r-select() {
          ((REGION_ACTIVE)) || zle set-mark-command
          local widget_name=$1
          shift
          zle $widget_name -- $@
        }

        for key     kcap    seq        mode      widget (
            sleft   kLFT    $'\e[1;2D' select    backward-char
            sright  kRIT    $'\e[1;2C' select    forward-char
            sup     kri     $'\e[1;2A' select    up-line-or-history
            sdown   kind    $'\e[1;2B' select    down-line-or-history
            send    kEND    $'\E[1;2F' select    end-of-line
            send2   x       $'\E[4;2~' select    end-of-line
            shome   kHOM    $'\E[1;2H' select    beginning-of-line
            shome2  x       $'\E[1;2~' select    beginning-of-line
        #   left    kcub1   $'\EOD'    deselect  backward-char  # Deselect during selection but interferes with autosuggest-accept
        #   right   kcuf1   $'\EOC'    deselect  forward-char   # Deselect during selection but interferes with autosuggest-accept
            end     kend    $'\EOF'    deselect  end-of-line
            end2    x       $'\E4~'    deselect  end-of-line
            home    khome   $'\EOH'    deselect  beginning-of-line
            home2   x       $'\E1~'    deselect  beginning-of-line
            csleft  x       $'\E[1;6D' select    backward-word
            csright x       $'\E[1;6C' select    forward-word
            csend   x       $'\E[1;6F' select    end-of-line
            cshome  x       $'\E[1;6H' select    beginning-of-line
            cleft   x       $'\E[1;5D' deselect  backward-word
            cright  x       $'\E[1;5C' deselect  forward-word
            del     kdch1   $'\E[3~'   delregion delete-char
            bs      x       $'^?'      delregion backward-delete-char
          ) {
          eval "key-$key() {
            r-$mode $widget \$@
          }"
          zle -N key-$key
          bindkey ''${terminfo[$kcap]-$seq} key-$key
        }

        bindkey '^f' autosuggest-accept
        bindkey '^[[C' autosuggest-accept            # Right arrow to accept autosuggestion
        bindkey '^[[OC' autosuggest-accept           # Right arrow to accept autosuggestion
        bindkey '^ ' autosuggest-execute             # Ctrl + Space to accept and then execute autosuggestion
        bindkey '^[[Z' fzf-tab-complete              # Shift-Tab to launch fzf-tab
        bindkey "^I" expand-or-complete              # Tab to expand or complete regular zsh completions
        bindkey -M isearch '^?' backward-delete-char # Restore backward-delete-char for Backspace in the
                                                     # incremental search keymap so it keeps working there

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

        # Autocompletion options
        setopt auto_list # Automatically list choices on ambiguous completion
        setopt auto_menu # Automatically use menu completion
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # Auto-completion is now case-insensitive
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}" # Use LS_COLORS for completion coloring
        zstyle ':completion:*' menu no # Disable completion menu
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

        # Aliases from initExtra
        alias ls='ls --color -2'
        alias c='clear'

        # Auto-start Hyprland on first startup
        IS_FIRST_LAUNCH="/run/user/$(id -u)/zshrc_current_session"
        if [ ! -f "$IS_FIRST_LAUNCH" ]; then
            touch "$IS_FIRST_LAUNCH"
            echo "Launching Hyprland..."
            dbus-run-session Hyprland
        fi

        # Allow folder navigation with 'fo' using the 'folder' script
        fo() {
          cd "$(folder "$1")"
        }
      '';
    };
  };
}
