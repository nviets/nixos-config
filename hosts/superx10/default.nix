#
#  Specific system configuration settings for h310m
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./h310m
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktops
#           ├─ hyprland.nix
#           └─ ./virtualisation
#               └─ default.nix
#

{ config, pkgs, vars, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ../../modules/programs/games.nix
    ] ++
    [(import ../../modules/services/tailscale.nix)] ++        # Tailscale
    #[(import ../../modules/services/slurm/slurmMaster.nix)] ++ # Slurm
    [(import ../../modules/services/ollama.nix)] ++           # LLMs
    [(import ../../modules/services/rstudio.nix)] ++          # RStudio IDE matched to rEnv
    [(import ../../modules/programs/rEnv/r.nix)]; #++           # R environment
    #[(import ../../modules/desktops/bspwm.nix)];
    #(import ../../modules/desktops/virtualisation);

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];
    kernelPackages = pkgs.linuxPackages_latest; # Older kernel, or nvidia won't work on Hyprland
    binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" "armv6l-linux" "riscv64-linux" ];
  };

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/nathanviets/.config/sops/age/keys.txt";
  };

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  hardware = {
    graphics = {
      enable = true;
    };
    nvidia = {
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      nvidiaSettings = true;
      modesetting.enable = true;
      forceFullCompositionPipeline = true;
    };

    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  nixpkgs.hostPlatform = {
    gcc.arch = "broadwell";
    gcc.tune = "broadwell";
    system = "x86_64-linux";
  };

  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };
    blueman.enable = true;                      # Bluetooth
    xserver.videoDrivers = [ "nvidia" ];
  };

  #hyprland.enable = true;
  bspwm.enable = true;

  environment = {
    systemPackages = with pkgs; [
      simple-scan # Scanning
      sshpass # Ansible Dependency
      wacomtablet # Tablet
    ];
  };

  flatpak = {
    extraPackages = [
      "com.github.tchx84.Flatseal"
    ];
  };

  nixpkgs.overlays = [
    (self: super: {
      duckdb = super.duckdb.overrideAttrs ( _: { doInstallCheck = false; installCheckPhase = "echo HELLO"; doCheck = false; } );

      python = super.python.override {
        packageOverrides = python-self: python-super: {
          numpy = python-super.numpy.overrideAttrs (oldAttrs: { disabledTests = [ "test_*" ]; doInstallCheck = false; doCheck = false; checkPhase = "echo HELLO"; pytestCheckPhase = "true"; installCheckPhase = "echo HELLO"; });
        };
      };
      pythonPackages = super.pythonPackages.override {
        overrides = self: super: {
          numpy = super.numpy.overridePythonAttrs (oldAttrs: { disabledTests = [ "test_*" ]; doInstallCheck = false; doCheck = false; checkPhase = "echo HELLO"; pytestCheckPhase = "true"; installCheckPhase = "echo HELLO"; });
        };
      };
      pythonPackagesExtensions = super.pythonPackagesExtensions ++ [(
        python-self: python-super: {
          black = python-super.black.overrideAttrs (oldAttrs: { doInstallCheck = false; doCheck = false; checkPhase = "echo HELLO"; installCheckPhase = "echo HELLO"; });
          numpy = python-super.numpy.overrideAttrs (oldAttrs: { disabledTests = [ "test_*" ]; doInstallCheck = false; doCheck = false; checkPhase = "echo HELLO"; pytestCheckPhase = "true"; installCheckPhase = "echo HELLO"; });
          pendulum = python-super.pendulum.overrideAttrs (oldAttrs: { disabledTests = [ "test_*" ]; doInstallCheck = false; doCheck = false; checkPhase = "echo HELLO"; pytestCheckPhase = "true"; installCheckPhase = "echo HELLO"; });
        }
      )];

      python3 = super.python3.override {
        packageOverrides = python-self: python-super: {
          numpy = python-super.numpy.overrideAttrs (oldAttrs: { disabledTests = [ "test_*" ]; doInstallCheck = false; doCheck = false; checkPhase = "echo HELLO"; pytestCheckPhase = "echo HELLO"; installCheckPhase = "echo HELLO"; });
        };
      };
      python3Packages = super.python3Packages.override {
        overrides = self: super: {
          numpy = super.numpy.overridePythonAttrs (oldAttrs: { disabledTests = [ "test_*" ]; doInstallCheck = false; doCheck = false; checkPhase = "echo HELLO"; pytestCheckPhase = "true"; installCheckPhase = "echo HELLO"; });
        };
      };
      python3PackagesExtensions = super.python3PackagesExtensions ++ [(
        python-self: python-super: {
          numpy = python-super.numpy.overrideAttrs (oldAttrs: { disabledTests = [ "test_*" ]; doInstallCheck = false; doCheck = false; checkPhase = "echo HELLO"; pytestCheckPhase = "true"; installCheckPhase = "echo HELLO"; });
        }
      )];

      python312 = super.python312.override {
        packageOverrides = python-self: python-super: {
          numpy = python-super.numpy.overrideAttrs (oldAttrs: { disabledTests = [ "test_*" ]; doInstallCheck = false; doCheck = false; checkPhase = "echo HELLO"; pytestCheckPhase = "true"; installCheckPhase = "echo HELLO"; });
        };
      };
      python312Packages = super.python312Packages.override {
        overrides = self: super: {
          numpy = super.numpy.overridePythonAttrs (oldAttrs: { disabledTests = [ "test_*" ]; doInstallCheck = false; doCheck = false; checkPhase = "echo HELLO"; pytestCheckPhase = "true"; installCheckPhase = "echo HELLO"; });
        };
      };
      python312PackagesExtensions = super.python312PackagesExtensions ++ [(
        python-self: python-super: {
          numpy = python-super.numpy.overrideAttrs (oldAttrs: { disabledTests = [ "test_*" ]; doInstallCheck = false; doCheck = false; checkPhase = "echo HELLO"; pytestCheckPhase = "true"; installCheckPhase = "echo HELLO"; });
        }
      )];
    })
  ];
}
