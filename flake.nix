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
    pkgs = import nixpkgs {inherit system; config.allowUnfree = true;};
    VASPio = pkgs.python312Packages.buildPythonPackage rec {
      pname = "vaspio";
      version = "0.1.0";
      format = "setuptools";
      src = pkgs.fetchFromGitHub {
        owner = "sh4k095";
        repo = "VASPio";
        rev = version;
        hash = "sha256-Y9WCExaAbm/FWf0IZld9X3cc2fu4cOewKzlhVKlcrbE=";
      };
      dependencies = with pkgs.python312Packages; [
        ase
        pymatgen
      ];
    };
    tensorpotential = pkgs.python312Packages.buildPythonPackage rec {
      pname = "tensorpotential";
      version = "0.5.1";
      format = "setuptools";
      src = pkgs.fetchFromGitHub {
        owner = "ICAMS";
        repo = "grace-tensorpotential";
        rev = version;
        hash = "sha256-nVIHW2aiV79Ul07lqt/juGc8oPYJUeb7TLtqMyOQjGs";
      };
      dependencies = let
        matscipy = pkgs.python312Packages.buildPythonPackage rec {
          pname = "matscipy";
          version = "1.1.1";
          pyproject = true;
          src = pkgs.fetchFromGitHub {
            owner = "libAtoms";
            repo = "matscipy";
            rev = version;
            hash = "sha256-mVN+9PTwEMD24KV3Eyp0Jq4vgA1Zs+jThdEbVcfs6pw=";
          };
        };
        in with pkgs.python312Packages; [
          tensorflow
          keras
          scipy
          matscipy
          numpy
          sympy
          pandas
          ase
          pyyaml
          tqdm
        ];
      };
    in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        (python312.withPackages (python-pkgs:
          with python-pkgs; [
            numpy
            scipy
            matplotlib
            ovito
            jupyterlab
          ]))
      ] ++ [ VASPio ];
      env = {
        PSEUDOPATH = "/home/sh4k0/Dropbox/POSTDOC/RESEARCH/POTPAW";
      };
    };
  };
}
