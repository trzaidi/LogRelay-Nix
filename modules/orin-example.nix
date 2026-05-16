{ modulesPath, lib, pkgs, ... }:

{
  imports = [
    # Base NixOS configuration for aarch64 systems
    "${modulesPath}/installer/scan/not-detected.nix"
  ];

  # Target architecture is Jetson Orin
  nixpkgs.hostPlatform = "aarch64-linux";

  # Enable the LogRelay telemetry service
  services.logrelay = {
    enable = true;

    # Adjust to match the serial port on your Orin carrier board
    serialPort = "/dev/ttyUSB0";

    # Must match ArduPilot telemetry output baud rate
    baudRate = 57600;

    # Flight logs written here on the Orin filesystem
    logPath = "/var/log/logrelay";
  };

  # Allow unfree packages needed for NVIDIA drivers via jetpack-nixos
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
