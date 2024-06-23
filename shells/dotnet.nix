with import <nixpkgs> {};
  mkShell {
    # Assuming that Rider is installed, you can start the shell with:
    # nix-shell ./shells/dotnet.nix --run 'nohup jetbrains-toolbox &'
    name = "dotnet-env";
    packages = [
      dotnet-sdk_8
      powershell
    ];
  }
