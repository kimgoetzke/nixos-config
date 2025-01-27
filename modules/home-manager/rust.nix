{
  pkgs,
  config,
  lib,
  ...
}: {
  options.rust = {
    enable = lib.mkEnableOption "Enable packages for Rust development (incl. Bevy and Audacity)";
  };

  config = lib.mkIf config.rust.enable {
    home = {
      packages = with pkgs; [
        just
        openssl
        pkg-config
        rust-analyzer
        cargo
        rustc
        udev
        libudev-zero
        alsa-lib
        vulkan-loader
        libxkbcommon
        wayland
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr
        glibc.dev
        libGL
        gcc
        clippy
        audacity
      ];
      sessionVariables = {
        CARGO_HOME = "${config.home.homeDirectory}/.cargo/bin";
        CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG = "true";
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
        # TODO: Fix this module because it won't find wayland related packages when using Bevy
        # PKG_CONFIG_PATH = "${pkgs.wayland}:${pkgs.wayland}/lib/pkgconfig:${pkgs.pkg-config}/lib/pkgconfig:${pkgs.pkg-config}";
        LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [
          pkgs.just
          pkgs.openssl
          pkgs.pkg-config
          pkgs.rust-analyzer
          pkgs.cargo
          pkgs.rustc
          pkgs.udev
          pkgs.libudev-zero
          pkgs.alsa-lib
          pkgs.vulkan-loader
          pkgs.libxkbcommon
          pkgs.wayland
          pkgs.xorg.libX11
          pkgs.xorg.libXcursor
          pkgs.xorg.libXi
          pkgs.xorg.libXrandr
          pkgs.glibc.dev
          pkgs.libGL
          pkgs.gcc
          pkgs.clippy
        ]}";
      };
      sessionPath = [
        "${config.home.homeDirectory}/.cargo/bin"
      ];
    };
  };
}
