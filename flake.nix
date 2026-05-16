{
  description = "NixOS flake and service module for LogRelay on NVIDIA Jetson Orin";

  inputs = {
    // Main Nix package collection, pinned to nixos-unstable for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    // Reduces boilerplate when targeting multiple systems like x86 and aarch64
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        // Pull the package set for whatever system we're building on
        pkgs = nixpkgs.legacyPackages.${system};

        // Cross-compilation package set targeting Jetson Orin (aarch64-linux)
        pkgsCross = nixpkgs.legacyPackages.${system}.pkgsCross.aarch64-multiplatform;
      in {
        // Builds LogRelay from source using the derivation in pkgs/logrelay.nix
        packages.logrelay = pkgs.callPackage ./pkgs/logrelay.nix {};

        // Cross-compiled LogRelay binary targeting Jetson Orin
        packages.logrelay-aarch64 = pkgsCross.callPackage ./pkgs/logrelay.nix {};

        // Local dev shell with everything needed to work on LogRelay in Rust
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustc
            cargo
            rust-analyzer
          ];
        };
      }
    ) // {
      // Expose the NixOS module so other flakes can import and use it
      nixosModules.logrelay = import ./modules/logrelay.nix;

      // Example NixOS system configuration for Jetson Orin with LogRelay running on boot
      nixosConfigurations.orin-example = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          self.nixosModules.logrelay
          ./modules/orin-example.nix
        ];
      };
    };
}