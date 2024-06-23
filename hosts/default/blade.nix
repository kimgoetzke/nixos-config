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
    # See https://nixos.wiki/wiki/Hardware/Razer for some more information.

    # Enabled NVIDIA drivers
    # See https://nixos.wiki/wiki/Nvidia for more information.
    hardware.opengl.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        sync.enable = true;
        amdgpuBusId = "PCI:0:1:0";
        nvidiaBusId = "PCI:0:4:0";
        # TODO: Find out the real values from output below
        #  *-display
        #       description: amdgpudrmfb
        #       product: nouveaudrmfb
        #       physical id: 0
        #       bus info: pci@0000:01:00.0
        #       logical name: /dev/fb1
        #       logical name: /dev/fb0
        #       version: a1
        #       width: 64 bits
        #       clock: 33MHz
        #       capabilities: pm msi pciexpress bus_master cap_list rom fb
        #       configuration: depth=32 driver=nouveau latency=0 mode=2560x1440 resolution=2560,1440 visual=truecolor xres=2560 yres=1440
        #       resources: iomemory:f80-f7f iomemory:fc0-fbf irq:92 memory:fb000000-fbffffff memory:f800000000-fbffffffff memory:fc00000000-fc01ffffff ioport:f000(size=128) memory:fc000000-fc07ffff
        #  *-display
        #       product: amdgpudrmfb
        #       physical id: 0
        #       bus info: pci@0000:04:00.0
        #       logical name: /dev/fb0
        #       version: c4
        #       width: 64 bits
        #       clock: 33MHz
        #       capabilities: pm pciexpress msi msix bus_master cap_list fb
        #       configuration: depth=32 driver=amdgpu latency=0 resolution=2560,1440
        #       resources: iomemory:fc0-fbf iomemory:fc0-fbf irq:41 memory:fc10000000-fc1fffffff memory:fc20000000-fc201fffff ioport:e000(size=256) memory:fc500000-fc57ffff
      };
    };
  };
}
