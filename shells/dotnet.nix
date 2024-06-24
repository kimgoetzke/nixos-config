with import <nixpkgs> {};
  mkShell {
    # Assuming that Rider is installed, you can start the shell with:
    # nix-shell ./shells/dotnet.nix --run 'nohup jetbrains-toolbox &'
    name = "dotnet-env";
    packages = [
      dotnet-sdk_8
      powershell
    ];
    shellHook = ''
      export DOTNET_NOLOGO=1
      export DOTNET_ROOT=${dotnet-sdk_8}
      export PATH=${dotnet-sdk_8}/bin:$PATH
      echo "Welcome to your .NET development environment!"
    '';
  }
