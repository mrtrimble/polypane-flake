# Polypane Nix Flake

A Nix flake for packaging Polypane browser.

## Usage

### Direct run
```bash
nix run github:yourusername/polypane-flake
```

### Install to profile
```bash
nix profile install github:yourusername/polypane-flake
```

### Use in NixOS configuration
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    polypane.url = "github:yourusername/polypane-flake";
  };

  outputs = { self, nixpkgs, polypane }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        {
          environment.systemPackages = [
            polypane.packages.x86_64-linux.polypane
          ];
        }
      ];
    };
  };
}
```

### Use in Home Manager
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    polypane.url = "github:yourusername/polypane-flake";
  };

  outputs = { nixpkgs, home-manager, polypane, ... }: {
    homeConfigurations.youruser = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./home.nix
        {
          home.packages = [
            polypane.packages.x86_64-linux.polypane
          ];
        }
      ];
    };
  };
}
```

## Development

```bash
nix develop
nix build
nix run
```