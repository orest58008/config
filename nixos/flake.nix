{
  inputs = {
    nixpkgs.url          = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url   = "github:NixOS/nixos-hardware";

    fjordlauncher.url    = "github:unmojang/FjordLauncher";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs:
  let
    motherboard = with builtins; replaceStrings ["\n"] [""] <|
    readFile "/sys/devices/virtual/dmi/id/product_name";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
      ] ++ ( if motherboard == "MS-7C51"    then [
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-gpu-amd
      ] else if motherboard == "20L8S7GJ05" then [
        nixos-hardware.nixosModules.lenovo-thinkpad-t480s
      ] else []);
    };
  };
}
