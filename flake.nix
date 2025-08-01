{
  description = "Python development shell for work- and research-related stuff.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    VASPio = pkgs.python3Packages.buildPythonPackage rec {
      pname = "vaspio";
      version = "0.1.0";
      format = "setuptools";
      src = pkgs.fetchFromGitHub {
        owner = "sh4k095";
        repo = "VASPio";
        rev = "df0a5432ecc62de15ae8410c14f8b2e96951f3f7";
        hash = "sha256-Y9WCExaAbm/FWf0IZld9X3cc2fu4cOewKzlhVKlcrbE=";
      };
      build-system = with pkgs.python3Packages; [
        setuptools
        wheel
      ];
    };
    in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        (python312.withPackages (python-pkgs:
          with python-pkgs; [
            ase
            numpy
            scipy
            pymatgen
            matplotlib
            ovito
          ]))
      ] ++ [ VASPio ];
      env = {
        PSEUDOPATH = "/home/sh4k0/Dropbox/POSTDOC/RESEARCH/POTPAW";
      };
    };
  };
}
