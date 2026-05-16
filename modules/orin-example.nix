{ modulesPath, lib, pkgs, ... }:

{
  imports = [
    # Base NixOS configuration for aarch64 systems
    "${modulesPath}/installer/scan/not-detected.nix"
  ];

  # Target architecture is Jetson Orin
  nixpkgs.hostPlatform = "aarch64-linux";

  # Jetson devices use extlinux rather than grub for bootloading
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Root filesystem pointing to the first partition on the Orin eMMC
  # Adjust this to match your actual storage device, NVMe would be /dev/nvme0n1p1
  fileSystems."/" = {
    device = "/dev/mmcblk0p1";
    fsType = "ext4";
  };

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