{ config, lib, pkgs, ... }:

let
  cfg = config.services.logrelay;
in {
  # All configurable options exposed to the NixOS system configuration
  options.services.logrelay = {

    enable = lib.mkEnableOption "LogRelay telemetry ingestion service";

    # Serial port where ArduPilot MAVLink telemetry comes in
    serialPort = lib.mkOption {
      type = lib.types.str;
      default = "/dev/ttyUSB0";
      description = "Serial port for MAVLink telemetry ingestion";
    };

    # Baud rate must match what ArduPilot is configured to output
    baudRate = lib.mkOption {
      type = lib.types.int;
      default = 57600;
      description = "Baud rate for the serial connection";
    };

    # Flight logs are written here on the Orin filesystem
    logPath = lib.mkOption {
      type = lib.types.str;
      default = "/var/log/logrelay";
      description = "Directory where flight logs are written";
    };

  };

  # Only apply this configuration if the service is enabled
  config = lib.mkIf cfg.enable {

    systemd.services.logrelay = {
      description = "LogRelay MAVLink Telemetry Service";

      # Start after the system reaches multi-user mode
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.logrelay}/bin/logrelay --port ${cfg.serialPort} --baud ${toString cfg.baudRate} --log ${cfg.logPath}";

        # Restart automatically on failure with a short delay
        Restart = "on-failure";
        RestartSec = "5s";

        # Send all output to the systemd journal, readable with journalctl
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

  };
}