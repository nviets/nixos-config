{ config, lib, pkgs, ... }: 
let
  #R-with-my-packages = pkgs.rWrapper.override{ packages = [ (import ./r-packages.nix pkgs) ]; };
  myPython = let
    packageOverrides = self: super: {
      cfn-lint = super.cfn-lint.overridePythonAttrs (old: { doInstallCheck = false; doCheck = false; checkPhase = ""; installCheckPhase = ""; });
      numpy = super.numpy.overridePythonAttrs (old: { doInstallCheck = false; doCheck = false; checkPhase = ""; installCheckPhase = ""; });
      raysql = self.callPackage ./pkgs/raysql/default.nix { };
    };
  in pkgs.python3.override {
    inherit packageOverrides;
  };

  python-with-my-packages = myPython.withPackages (ps: with ps; [ numpy ray ]);
in
{
  environment.systemPackages = [ python-with-my-packages ];
  nixpkgs.overlays = [
    (final: prev: { 
    })
  ];
}
