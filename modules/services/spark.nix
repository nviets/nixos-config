{ config, lib, pkgs, ... }: {
  imports = [ ./myspark.nix  ];
  disabledModules = [ "services/cluster/spark/default.nix" ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      4040 # APP UI
      7077 # SPARK_MASTER
      8081 # worker ui
      8181 # SPARK_MASTER_WEBUI_PORT
    ];
  };
  services = with pkgs; {
    spark = {
      master.enable = true;
      master.extraEnvironment = {
        SPARK_MASTER_OPTS = "-Dspark.deploy.defaultCores=5";
        SPARK_MASTER_WEBUI_PORT = "8181";
      };
      worker.enable = true;
      worker.extraEnvironment = {
        SPARK_WORKER_CORES = "10";
        SPARK_WORKER_MEMORY = "20g";
      };
    };
  };
}
