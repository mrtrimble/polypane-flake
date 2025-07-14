{
  description = "Polypane browser for developers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        packages = {
          polypane = pkgs.callPackage ./package.nix { };
          default = self.packages.${system}.polypane;
        };

        apps = {
          polypane = flake-utils.lib.mkApp {
            drv = self.packages.${system}.polypane;
          };
          default = self.apps.${system}.polypane;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixpkgs-fmt
          ];
        };
      });
}