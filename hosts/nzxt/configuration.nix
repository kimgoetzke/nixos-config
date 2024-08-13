{
  config,
  pkgs,
  lib,
  inputs,
  userSettings,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/hardware/_all.nix
    ./../../modules/modes/_all.nix
    (import ./../../modules/desktop/_all.nix {inherit config pkgs lib inputs userSettings;})
  ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.nixos.label = "X"; # Reduces lengths of label so there's enough space to see "built on" in boot loader

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = userSettings.hostName;
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

  # Enable printing with auto-discovery (see https://wiki.nixos.org/wiki/Printing)
  services.printing = {
    enable = true;
    drivers = [pkgs.hplip]; # For HP printers only (magically works)
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # General hardware configuration
  nzxt.enable = true;
  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    bluetooth.enable = true;
  };

  # Modes
  gaming.enable = userSettings.modes.isGamingEnabled;

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
  users.users.${userSettings.user} = {
    isNormalUser = true;
    description = userSettings.userName;
    extraGroups = ["networkmanager" "wheel" "docker" "gamemode"];
    shell = pkgs.${userSettings.defaultShell};
  };

  # Environment variables
  environment.sessionVariables = {
    FLAKE = "${userSettings.baseDirectory}";
    NIXOS_OZONE_WL = "1"; # Enable Ozone-Wayland for VS Code to run on Wayland
    WLR_NO_HARDWARE_CURSORS = "1"; # Fixes incomplete and inaccurate cursors on Hyprland
  };

  # Allow running unpatched dynamic binaries i.e. IDEs downloaded via JetBrains Toolbox instead of Nix
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Desktop environment
  de-gnome.enable = userSettings.desktopEnvironments.isGnomeEnabled;
  de-hyprland.enable = userSettings.desktopEnvironments.isHyprlandEnabled;

  # System profile packages
  environment.systemPackages = with pkgs;
    [
      unzip
      zip
      curl
      jq
      neofetch
      obsidian
      _1password-gui
      _1password
      lshw # Tool to list hardware
      bat # Cat with syntax highlighting
      # kooha # GIF screen recorder TODO: Research Kooha's segmentation fault
      pulsemixer # PulseAudio mixer and audio controller
    ]
    ++ lib.optionals userSettings.desktopEnvironments.isGnomeEnabled [
      xorg.xev # Input event listener for X
      xorg.xmodmap
      gnomeExtensions.clipboard-history
      gnomeExtensions.space-bar
    ]
    ++ lib.optionals userSettings.desktopEnvironments.isHyprlandEnabled [
      wdisplays # GUI for on-the-fly display configuration
      slurp # Tool to select regions on screen
      grim # Tool to grap images from screen
      satty # Screenshot annotation tool
      wf-recorder # Screen recorder
      ffmpeg # Video and audio converter e.g. mp4 recorded with wf-recorder to gif
    ];

  # Shell
  programs.zsh.enable = userSettings.shells.isZshEnabled;

  # Docker
  virtualisation.docker = {
    enable = userSettings.isDockerEnabled;
  };

  # Home manager
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      userSettings = userSettings;
    };
    backupFileExtension = "0001";
    users.${userSettings.user} = {
      imports = [./home.nix];
    };
  };

  # Yet Another Nix Helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "all --keep 4";
  };

  # Fonts
  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts-emoji
    jetbrains-mono
  ];

  # Stylix
  stylix = {
    enable = true;
    # TODO: Find out why 'image = userSettings.wallpaper' doesn't work and then fix the below
    image = ./../../assets/images/${userSettings.wallpaperFile};
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    fonts.sizes.terminal = 16;
    opacity.terminal =
      if userSettings.desktopEnvironments.isHyprlandEnabled
      then 0.6
      else 1.0;
    targets.gnome.enable = userSettings.desktopEnvironments.isGnomeEnabled;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 26;
    };
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  # Storage optimization
  nix.settings.auto-optimise-store = true;

  # System configuration
  system.stateVersion = "24.05";
}
