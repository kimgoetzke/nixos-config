{
  config,
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
    stylix.targets.fzf.enable = false;
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      extraOptions = [
        "--group-directories-first"
        "--long"
        "--no-time"
        "--no-user"
      ];
      git = true;
      icons = "always";
    };
    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      # useTheme = "nordtron"; # Will be ignored if 'settings' is used
      settings =
        builtins.fromJSON (builtins.readFile (builtins.toFile "kim-nord.omp.json" (builtins.readFile ./../../assets/configs/oh-my-posh/kim-nord.omp.json)));
    };
    programs.zsh = {
      enable = true;
      dotDir = "${config.home.homeDirectory}/.config/zsh";
      initContent = ''
        # Zinit (the zsh plugin manager)
        ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
        if [ ! -d "$ZINIT_HOME" ]; then
           mkdir -p "$(dirname $ZINIT_HOME)"
           git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
        fi
        source "''${ZINIT_HOME}/zinit.zsh"

        # Add zsh plugins
        zinit light zsh-users/zsh-syntax-highlighting
        zinit light zsh-users/zsh-completions
        zinit light zsh-users/zsh-autosuggestions
        zinit light Aloxaf/fzf-tab

        # Add snippets
        zinit snippet OMZP::sudo

        # Load completions
        autoload -Uz compinit && compinit
        zinit cdreplay -q

        # Keybindings
        # (Thanks to https://stackoverflow.com/questions/5407916/zsh-zle-shift-selection)

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

        bindkey '^f' expand-or-complete              # Ctrl + F to expand or accept zsh completion suggestions
        bindkey "^I" autosuggest-accept              # Tab to accept autosuggestion
        bindkey '^[[C' autosuggest-accept            # Right arrow to accept in-line autosuggestion
        bindkey '^[[OC' autosuggest-accept           # Right arrow to accept in-line autosuggestion
        bindkey '^ ' autosuggest-execute             # Ctrl + Space to accept and then execute autosuggestion
        bindkey '^[[Z' fzf-tab-complete              # Shift-Tab to launch fzf-tab
        bindkey -M isearch '^?' backward-delete-char # Restore backward-delete-char for Backspace in the
                                                     # incremental search keymap so it keeps working there

        # History
        HISTSIZE=5000
        HISTFILE=$HOME/.config/zsh/.zsh_history
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
        zstyle ':autocomplete:*' default-context history-incremental-search-backward
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#acb1ba' # Highlight autosuggestions in yellow

        # fzf
        show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
        export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
          --color=fg:#e5e9f0,fg+:#d0d0d0,bg:-1,bg+:#4c566a
          --color=hl:#81a1c1,hl+:#5fd7ff,info:#eacb8a,marker:#a3be8b
          --color=prompt:#bf6069,spinner:#b48dac,pointer:#b48dac,header:#a3be8b
          --color=border:#d8dee9,scrollbar:#eceff4,label:#aeaeae,query:#d9d9d9
          --preview-window="border-rounded" --prompt="> " --marker=">" --pointer="◆"
          --separator="─" --scrollbar="│"'
        export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
        export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

        _fzf_comprun() {
          local command=$1
          shift

          case "$command" in
            cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
            export|unset) fzf --preview "eval 'echo $\{}'"         "$@" ;;
            ssh)          fzf --preview 'dig {}'                   "$@" ;;
            *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
          esac
        }

        # Aliases from initExtra
        alias ls='eza --group-directories-first --git --long --no-time --no-user --icons=always'
        alias c='clear'

        # Allow folder navigation with 'fo' using the 'folder' script
        fo() {
          cd "$(folder "$1")"
        }
      '';
    };
  };
}
