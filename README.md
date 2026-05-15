# LogRelay-Nix

NixOS flake and service module for LogRelay on NVIDIA Jetson Orin.

## Overview

Packages and deploys LogRelay as a systemd service on aarch64-linux targets like Jetson Orin Nano. Built for Group 1-3 UAS operations with ArduPilot and future Anduril LatticeOS integration.

## Structure

- `flake.nix` — flake inputs, outputs, and NixOS module definition
- `modules/logrelay.nix` — systemd service configuration
- `pkgs/logrelay.nix` — Rust package derivation

## Roadmap

- [ ] Rust package derivation via buildRustPackage
- [ ] NixOS service module with systemd unit
- [ ] Configuration options (serial port, baud rate, log path)
- [ ] aarch64-linux cross-compilation for Jetson Orin
- [ ] Lattice entity publisher integration
- [ ] jetpack-nixos compatibility

## Related

- [LogRelay](https://github.com/trzaidi/LogRelay)
- [jetpack-nixos](https://github.com/anduril/jetpack-nixos)