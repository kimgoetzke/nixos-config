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

    xdg.configFile."noctalia/palettes/jetbrains-dark-islands.json".source =
      ./../../../assets/configs/noctalia/jetbrains-dark-islands.json;
  };
}
