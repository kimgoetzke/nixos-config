{
  pkgs,
  config,
  lib,
  userSettings,
  ...
}: {
  options = {
    nzxt.enable = lib.mkEnableOption "Enable specific hardware support for my desktop";
  };

  config = lib.mkIf config.nzxt.enable {

    # Update AMD microcode to fix hardware vulnerabilities
    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    hardware.cpu.amd.updateMicrocode = true;
    services.ucodenix = {
      enable = true;
      cpuSerialNumber = "00A2-0F10-0000-0000-0000-0000";
    };

    # Enabled NVIDIA drivers
    # See https://wiki.nixos.org/wiki/Nvidia for more information.
    hardware.opengl.enable = true;

    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management -turns off GPU when not in use
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver)
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      open = false;

      # Enable the Nvidia settings menu, accessible via `nvidia-settings`
      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
