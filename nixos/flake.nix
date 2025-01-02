{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url          = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    fjordlauncher.url    = "github:unmojang/FjordLauncher";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.orest-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
