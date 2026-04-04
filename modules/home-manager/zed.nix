{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.zed;
  defaultSettings = ./../../assets/configs/zed/settings.json;
  defaultKeymap = ./../../assets/configs/zed/keymap.json;
in {
  options.zed = {
    enable = lib.mkEnableOption "Enable Zed Editor defaults";
    withDefaultConfig = lib.mkEnableOption "Bootstrap a mutable default Zed config";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zed-editor
    ];

    home.activation.zedBootstrapConfig = lib.mkIf cfg.withDefaultConfig (lib.hm.dag.entryAfter ["writeBoundary"] ''
      zedConfigDir="${config.xdg.configHome}/zed"
      zedSettingsFile="$zedConfigDir/settings.json"
      zedKeymapFile="$zedConfigDir/keymap.json"

      if [ ! -e "$zedSettingsFile" ]; then
        $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -Dm644 ${defaultSettings} "$zedSettingsFile"
      fi

      if [ ! -e "$zedKeymapFile" ]; then
        $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -Dm644 ${defaultKeymap} "$zedKeymapFile"
      fi
    '');
  };
}
