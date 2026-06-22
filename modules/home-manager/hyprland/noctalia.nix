{
  inputs,
  config,
  lib,
  ...
}: {
  options = {
    hyprland-noctalia.enable = lib.mkEnableOption "Enable Noctalia shell for Hyprland";
  };

  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf config.hyprland-noctalia.enable {
    programs.noctalia = {
      enable = true;
      settings = ./../../../assets/configs/noctalia/config.toml;
    };

    xdg.configFile."noctalia/palettes/kim.json".source = ./../../../assets/configs/noctalia/kim.json;
  };
}
