{ config, lib, pkgs, ... }: 
let
  R-with-my-packages = pkgs.rWrapper.override{ packages = [ (import ./r-packages.nix pkgs) ]; };
in
{
  environment.systemPackages = [ R-with-my-packages ];
  nixpkgs.overlays = [
    (final: prev: { rPackages = prev.rPackages.override { overrides = {
      #xgboost = prev.xgboost.override{rLibrary = true; cudaSupport = true; doCheck = false; };
      lightgbm = prev.lightgbm.override{rLibrary = true; cudaSupport = true; doCheck = false; };
#      duckdb = prev.rPackages.buildRPackage rec {
#        name = "duckdb";
#        version = "0.10.2 ";
#        src = prev.fetchFromGitHub {
#          owner = "duckdb";
#          repo = "duckdb-r";
#          rev = "3ff2b50cab6420e8346d2e3d247e59eafe3d0c95";
#          sha256 = "sha256-c1ZtUXRQu07uwhFGecx3rfDzZ5PXkJmEBq9TQv7koqw=";};
#        propagatedBuildInputs = with prev.rPackages; [ DBI ] ++ [ prev.R ];
#        nativeBuildInputs = with prev.rPackages; [ DBI ];};
#      config = prev.rPackages.buildRPackage rec {
#        name = "config";
#        version = "0.3.2.9000";
#        src = prev.fetchFromGitHub {
#          owner = "rstudio";
#          repo = "config";
#          rev = "54604e33d38f7ba6b9754ad3ac6ef1bca701a144";
#          sha256 = "sha256-HXQj397lxGffjwOpFPc6wFYejx7Emw7jLUKdqeUI5DM=";};
#        propagatedBuildInputs = with prev.rPackages; [ testthat knitr rmarkdown covr spelling jsonlite withr ] ++ [ prev.R ];
#        nativeBuildInputs = with prev.rPackages; [ testthat knitr rmarkdown covr spelling jsonlite withr ];};
#      chattr = prev.rPackages.buildRPackage rec {
#        name = "chattr";
#        version = "0.0.0.9006";
#        src = prev.fetchFromGitHub {
#          owner = "mlverse";
#          repo = "chattr";
#          rev = "b0dde1bffffb4aa5a5f9185901d543da1147c285";
#          sha256 = "sha256-WPgPIoHj/6Ac2XRzfBs3/7j31vKg7DqOOk2KKVVt7Rc=";};
#        propagatedBuildInputs = with prev.rPackages; [ rstudioapi lifecycle processx jsonlite httr2 purrr rlang bslib shiny clipr callr yaml glue cli fs ] ++ [ prev.R final.rPackages.config ];
#        nativeBuildInputs = with prev.rPackages; [ rstudioapi lifecycle processx jsonlite httr2 purrr rlang bslib shiny clipr callr yaml glue cli fs ];};
    };};})
  ];
}
