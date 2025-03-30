{ config, lib, pkgs, ... }: let
in {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8787 ];
  };
  services.rstudio-server = {
    enable = true;
    listenAddr = "100.123.17.107";
    package = pkgs.rstudioServerWrapper.override {
      packages = [ (import ../programs/rEnv/r-packages.nix pkgs) ];
    };
  };
}
