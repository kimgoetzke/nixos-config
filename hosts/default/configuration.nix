{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ./../../modules/desktop/_all.nix
  ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Time zone, locale, keymap
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  console.keyMap = "uk";

  # Enable flake support
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable CUPS to print documents
  services.printing.enable = true;

  # General hardware configuration
  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
  };

  # Enable sound with pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Main user account
  users.users.kgoe = {
    isNormalUser = true;
    description = "Kim";
    extraGroups = ["networkmanager" "wheel"];
  };

  # Environment variables
  environment.sessionVariables = {
    FLAKE = "~/projects/nixos-config";
    NIXOS_OZONE_WL = "1"; # Enable Ozone-Wayland for VS Code to run on Wayland
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Desktop environment
  kd-gnome.enable = true;

  # Packages installed in system profile
  environment.systemPackages = with pkgs; [
    wget
    obsidian
    _1password-gui
  ];

  # Home manager
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    backupFileExtension = "0001";
    users.kgoe = {
      imports = [./home.nix];
    };
  };

  # Yet Another Nix Helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
  };

  # Storage optimization
  nix.settings.auto-optimise-store = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon
  # services.openssh.enable = true;

  system.stateVersion = "24.05";
}
