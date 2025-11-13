{
  description = "Basic example of Nix-on-Droid system config.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nixpkgs-future = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-future, nix-on-droid }: {

    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs { system = "aarch64-linux"; };
      modules = [ 
        ./nix-on-droid.nix
        {
          environment.packages = with nixpkgs-future.legacyPackages.aarch64-linux; [
            neovim
            nodejs_24
            corepack_24
          ];
        }
      ];
    };

  };
}
