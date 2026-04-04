{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.obsidian;
  jetbrainsIslandsDarkPalette = {
    base00 = "#191A1C";
    base01 = "#1F2024";
    base02 = "#2B2D30";
    base03 = "#393B40";
    base04 = "#7A7E85";
    base05 = "#BCBEC4";
    base06 = "#CED0D6";
    base07 = "#DFE1E5";
    base08 = "#F75464";
    base09 = "#CF8E6D";
    base0A = "#E0BB65";
    base0B = "#6AAB73";
    base0C = "#2AACB8";
    base0D = "#56A8F5";
    base0E = "#C77DBB";
    base0F = "#D5B778";
  };
  themePalette =
    if lib.attrByPath ["stylix" "enable"] false config
    then config.lib.stylix.colors.withHashtag
    else jetbrainsIslandsDarkPalette;
  emptyAppearance = pkgs.writeText "obsidian-appearance-empty.json" "{}";
  stylixSnippet = ''
    .theme-dark {
      --background-primary: ${themePalette.base00};
      --background-primary-alt: ${themePalette.base01};
      --background-secondary: ${themePalette.base01};
      --background-secondary-alt: ${themePalette.base02};
      --background-modifier-border: ${themePalette.base03};
      --background-modifier-border-hover: ${themePalette.base04};
      --background-modifier-border-focus: ${themePalette.base0D};
      --background-modifier-form-field: ${themePalette.base01};
      --background-modifier-form-field-highlighted: ${themePalette.base02};
      --background-modifier-box-shadow: rgba(0, 0, 0, 0.35);
      --background-modifier-success: ${themePalette.base0B};
      --background-modifier-error: ${themePalette.base08};
      --text-normal: ${themePalette.base05};
      --text-muted: ${themePalette.base04};
      --text-faint: ${themePalette.base03};
      --text-on-accent: ${themePalette.base00};
      --text-accent: ${themePalette.base0D};
      --text-accent-hover: ${themePalette.base0C};
      --text-selection: ${themePalette.base02};
      --text-highlight-bg: ${themePalette.base02};
      --interactive-normal: ${themePalette.base01};
      --interactive-hover: ${themePalette.base02};
      --interactive-accent: ${themePalette.base0D};
      --interactive-accent-hover: ${themePalette.base0C};
      --scrollbar-bg: ${themePalette.base01};
      --scrollbar-thumb-bg: ${themePalette.base03};
      --scrollbar-active-thumb-bg: ${themePalette.base04};
      --inline-title-color: ${themePalette.base06};
      --h1-color: ${themePalette.base0D};
      --h2-color: ${themePalette.base0C};
      --h3-color: ${themePalette.base0A};
      --h4-color: ${themePalette.base0E};
      --h5-color: ${themePalette.base09};
      --h6-color: ${themePalette.base04};
      --link-color: ${themePalette.base0D};
      --link-color-hover: ${themePalette.base0C};
      --link-external-color: ${themePalette.base0C};
      --link-external-color-hover: ${themePalette.base0D};
      --code-normal: ${themePalette.base05};
      --code-background: ${themePalette.base01};
      --blockquote-border-color: ${themePalette.base0D};
      --blockquote-background-color: ${themePalette.base01};
      --tag-color: ${themePalette.base0A};
      --tag-background: ${themePalette.base01};
      --tag-border-color: ${themePalette.base03};
    }

    .theme-dark .workspace-tab-header.is-active .workspace-tab-header-inner,
    .theme-dark .mod-sidedock .workspace-tab-header.is-active .workspace-tab-header-inner,
    .theme-dark .mod-root .workspace-tab-header.is-active .workspace-tab-header-inner {
      color: ${themePalette.base06};
    }

    .theme-dark .cm-line.HyperMD-header,
    .theme-dark .markdown-rendered :is(h1, h2, h3, h4, h5, h6) {
      font-weight: 700;
    }

    .theme-dark .callout {
      border-color: ${themePalette.base03};
      background-color: ${themePalette.base01};
    }
  '';
  snippetFiles = lib.listToAttrs (map (vaultPath: {
      name = "${vaultPath}/.obsidian/snippets/stylix.css";
      value = {
        text = stylixSnippet;
      };
    })
    cfg.vaultPaths);
  vaultPathsJson = builtins.toJSON cfg.vaultPaths;
in {
  options.obsidian = {
    enable = lib.mkEnableOption "Enable Obsidian with theming derived from Stylix colours";
    vaultPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["Documents/Obsidian/Personal"];
      example = ["Documents/Obsidian/Personal"];
      description = "Vault paths relative to the home directory that should receive the theming snippet.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.obsidian];
    home.file = snippetFiles;
    home.activation.obsidianStylix = lib.hm.dag.entryAfter ["writeBoundary"] ''
      vault_paths_json='${vaultPathsJson}'

      printf '%s\n' "$vault_paths_json" | ${pkgs.jq}/bin/jq -r '.[]' | while IFS= read -r relative_vault_path; do
        vault_config_dir="${config.home.homeDirectory}/$relative_vault_path/.obsidian"
        appearance_file="$vault_config_dir/appearance.json"
        source_appearance_file="$appearance_file"
        temporary_file="$(${pkgs.coreutils}/bin/mktemp)"

        if [ ! -e "$appearance_file" ]; then
          source_appearance_file="${emptyAppearance}"
        fi

        ${pkgs.jq}/bin/jq \
          --arg accent_color '${themePalette.base0C}' \
          '
            .theme = "obsidian"
            | .cssTheme = ""
            | .accentColor = $accent_color
            | .enabledCssSnippets = (((.enabledCssSnippets // []) + ["stylix"]) | unique)
          ' \
          "$source_appearance_file" > "$temporary_file"

        $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -Dm644 "$temporary_file" "$appearance_file"
        ${pkgs.coreutils}/bin/rm -f "$temporary_file"
      done
    '';
  };
}


