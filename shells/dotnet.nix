{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "dotnet-env";
  nativeBuildInputs = with pkgs; [
    dotnet-sdk_8
    powershell
  ];
  shellHook = ''
    export DOTNET_NOLOGO=1
    export DOTNET_ROOT=${dotnet-sdk_8}
    export PATH=${dotnet-sdk_8}/bin:$PATH
    alias ide='nohup jetbrains-toolbox &'
    echo ""
    echo "Welcome to your .NET development environment!" | ${pkgs.lolcat}/bin/lolcat
    echo "Start JetBrains Toolbox with: nohup jetbrains-toolbox &"
    echo ""
  '';
}
