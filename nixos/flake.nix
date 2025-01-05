{
  inputs = {
    nixpkgs.url          = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url   = "github:NixOS/nixos-hardware";

    fjordlauncher.url    = "github:unmojang/FjordLauncher";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      motherboard = with builtins; readFile "/sys/devices/virtual/dmi/id/product_name"
        |> replaceStrings [ " " "\n" "\t" ] [ "" "" "" ];
      nixos-hardware = inputs.nixos-hardware.nixosModules;
    in {
      
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
        ] ++ ( if motherboard == "MS-7C51"    then [
          ./MS-7C51.nix
          nixos-hardware.common-cpu-amd
          nixos-hardware.common-gpu-amd
        ] else if motherboard == "20L8S7GJ05" then [
          nixos-hardware.lenovo-thinkpad-t480s
        ] else []
        ) ++ builtins.trace "Motherboard: `${motherboard}`" [];
      };
    };
}
