{
  description = "Was it really worth it?";

  inputs = {
    pre-commit-hooks = { 
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:mateushmd/nixvim";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs system; };
      modules = [
        ./configuration.nix 
      ];
    };
  };

  outputs = 
    inputs: 
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./configuration.nix
      ];

      perSystem = 
        { pkgs, ... }: {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.nixfmt-rfc-style
              pkgs.git
            ];
          };

          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
