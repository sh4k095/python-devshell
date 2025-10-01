
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
    VASPio = pkgs.python312Packages.buildPythonPackage rec {
      pname = "vaspio";
      version = "0.1.0";
      format = "setuptools";
      src = pkgs.fetchFromGitHub {
        owner = "sh4k095";
        repo = "VASPio";
        rev = "df0a5432ecc62de15ae8410c14f8b2e96951f3f7";
        hash = "sha256-Y9WCExaAbm/FWf0IZld9X3cc2fu4cOewKzlhVKlcrbE=";
      };
      dependencies = with pkgs.python312Packages; [
        ase
        pymatgen
      ];
    };
    ovito = pkgs.python312Packages.buildPythonPackage rec {
      pname = "ovito";
      version = "3.14.0";
      format = "wheel";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/b0/73/87b8f942f02a72d5f39ce1eb842c4290a7ef3e841f48a835f29dbc48b670/ovito-3.14.0-cp312-cp312-manylinux_2_28_x86_64.whl";
        sha256 = "01cp9j09kangg0v7i5vb9ymfyl62a99yzr2x5rxnbk42070gjjkc";
      };
      nativeBuildInputs = [pkgs.autoPatchelfHook];
      autoPatchelfIgnoreMissingDeps = ["libcuda.so.1" "libnvidia-ml.so.1"];
      propagatedBuildInputs = with pkgs.python312Packages; [numpy traits pyside6];
    };
    asap3 = pkgs.python312Packages.buildPythonPackage rec {
      pname = "asap3";
      version = "3.13.9";
      build-system = [pkgs.python312Packages.setuptools];
      pyproject = true;
      src = pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-oi5rr5k1YhtmpHm0sbIlkycqslI/yT99qmQysUfqmmQ=";
      };
      nativeBuildInputs = [pkgs.which];
      dependencies = with pkgs.python312Packages; [
        numpy
        ase
      ];
    };
    #matscipy = pkgs.python312Packages.buildPythonPackage rec {
    #  pname = "matscipy";
    #  version = "1.1.1";
    #  pyproject = true;
    #
    #  build-system = with pkgs.python312Packages; [
    #    meson
    #    meson-python
    #    ninja
    #    cython
    #    numpy
    #  ];
    #
    #  src = pkgs.fetchFromGitHub {
    #    owner = "libAtoms";
    #    repo = "matscipy";
    #    tag = "v${version}";
    #    hash = "sha256-mVN+9PTwEMD24KV3Eyp0Jq4vgA1Zs+jThdEbVcfs6pw=";
    #  };
    #
    #  dependencies = with pkgs.python312Packages; [
    #    numpy #>=1.16.0, <2.0.0
    #    scipy #>+1.2.3
    #    ase #>=3.23.0
    #    packaging
    #  ];
    #};
    #tensorpotential = pkgs.python312Packages.buildPythonPackage rec {
    #  pname = "tensorpotential";
    #  version = "0.5.1";
    #  format = "setuptools";
    #  src = pkgs.fetchFromGitHub {
    #    owner = "ICAMS";
    #    repo = "grace-tensorpotential";
    #    rev = version;
    #    hash = "sha256-nVIHW2aiV79Ul07lqt/juGc8oPYJUeb7TLtqMyOQjGs";
    #  };
    #  dependencies = let
    #    matscipy = pkgs.python312Packages.buildPythonPackage rec {
    #      pname = "matscipy";
    #      version = "1.1.1";
    #      pyproject = true;
    #      src = pkgs.fetchFromGitHub {
    #        owner = "libAtoms";
    #        repo = "matscipy";
    #        rev = version;
    #        hash = "sha256-mVN+9PTwEMD24KV3Eyp0Jq4vgA1Zs+jThdEbVcfs6pw=";
    #      };
    #    };
    #    in with pkgs.python312Packages; [
    #      tensorflow
    #      keras
    #      scipy
    #      matscipy
    #      numpy
    #      sympy
    #      pandas
    #      ase
    #      pyyaml
    #      tqdm
    #    ];
    #  };
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        (python312.withPackages (python-pkgs:
          with python-pkgs; [
            numpy
            scipy
            matplotlib
            jupyterlab
            VASPio
            ovito
            asap3
          ]
        ))
      ];
      env = {
        PSEUDOPATH = "/home/sh4k0/Dropbox/POSTDOC/RESEARCH/POTPAW";
      };
    };
  };
}
