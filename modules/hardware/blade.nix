{
  pkgs,
  config,
  lib,
  userSettings,
  ...
}: {
  options = {
    razer-blade.enable = lib.mkEnableOption "Enable Razor Blade 14 2021 specific hardware support";
  };

  config = lib.mkIf config.razer-blade.enable {
    # Update AMD microcode to fix hardware vulnerabilities
    hardware.enableRedistributableFirmware = true;
    hardware.cpu.amd.updateMicrocode = true;
    services.ucodenix = {
      enable = true;
      cpuSerialNumber = "00A5-0F00-0000-0000-0000-0000";
    };

    # See https://wiki.nixos.org/wiki/Hardware/Razer for some more information.

    # Enabled NVIDIA drivers
    # See https://wiki.nixos.org/wiki/Nvidia for more information.
    hardware.opengl.enable = true;
    # Temporarily commented out to see if it stops the system from crashing randomly
    #    services.xserver.videoDrivers = ["nvidia"];
    #    hardware.nvidia = {
    #      modesetting.enable = true;
    #
    #      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    #      # Enable this if you have graphical corruption issues or application crashes after waking
    #      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    #      # of just the bare essentials.
    #      powerManagement.enable = false;
    #
    #      # Fine-grained power management. Turns off GPU when not in use.
    #      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    #      powerManagement.finegrained = false;
    #
    #      # Use the NVidia open source kernel module (not to be confused with the
    #      # independent third-party "nouveau" open source driver).
    #      # Support is limited to the Turing and later architectures. Full list of
    #      # supported GPUs is at:
    #      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    #      # Currently alpha-quality/buggy, so false is currently the recommended setting.
    #      open = false;
    #
    #      # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    #      nvidiaSettings = true;
    #
    #      # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #      package = config.boot.kernelPackages.nvidiaPackages.stable;
    #
    #      prime = {
    #        sync.enable = true;
    #
    #        # Get your bus IDs by running this: nix shell nixpkgs#pciutils -c lspci | grep ' VGA '"
    #        amdgpuBusId = "PCI:4:0:0";
    #        nvidiaBusId = "PCI:1:0:0";
    #      };
    #    };
  };
}
