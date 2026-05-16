{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "logrelay";
  version = "0.1.0";

  # Fetch LogRelay source directly from GitHub
  src = fetchFromGitHub {
    owner = "trzaidi";
    repo = "LogRelay";
    rev = "main";
    hash = lib.fakeHash;
  };

  # Hash of the cargo dependencies, use lib.fakeHash until first real build
  cargoHash = lib.fakeHash;

  meta = {
    description = "MAVLink telemetry ingestion and relay for Group 1-3 UAS";
    homepage = "https://github.com/trzaidi/LogRelay";
    license = lib.licenses.mit;
    maintainers = [ "trzaidi" ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}