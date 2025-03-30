{ config, lib, pkgs, stable, ... }:
let
in {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3000 5300 9090 11434 ];
  };
  services = {
    ollama = {
      enable = true;
      openFirewall = true;
      acceleration = "cuda";
      host = "0.0.0.0";
    };
    nextjs-ollama-llm-ui = {
      enable = true;
      hostname = "0.0.0.0";
    };
    open-webui = {
      enable = true;
      host = "0.0.0.0";
      port = 9090;
      environment.OLLAMA_API_BASE_URL = "http://localhost:11434";
      package = stable.open-webui;
    };
#    tts = {
#      servers = {
#        english = {
#          port = 5300;
#          model = "tts_models/en/ljspeech/tacotron2-DDC";
#          useCuda = true;
#        };
#      };
#    };
  };
    #listenAddr = "100.123.17.107";
}
