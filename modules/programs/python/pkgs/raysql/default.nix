{
  lib,
  buildPythonPackage,
  pythonOlder,
  #fetchPypi,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  protobuf,
  pyarrow,
  numpy,
  ray
}:

buildPythonPackage rec {
  pname = "raysql";
  version = "0.6.0";

  #format = "wheel";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "datafusion-contrib";
    repo = "ray-sql";
    rev = "39a1fef446ecc6c27c1a0ee6039453522d365114";
    hash = "sha256-iWL08breAC7GpJCDa3tjaGuASFCna8Xjr3NGxJr4AJw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "ray-sql-cargo-deps";
    inherit src;
    hash = "sha256-OSD1CHuhnjxFmBJb9R/gB7UAQnTRdnOgaDoWmmV5F9w=";
  };

#  src = fetchPypi {
#    inherit pname version;
#    hash = "sha256-467jHCuzJAdm11l7SzohHHvxzgM2yYCNw+qGX61ob/I=";
#  };

  #PROTOC = "${protobuf}/bin/protoc";
  #PROTOC_INCLUDE = "${protobuf}/include";

  buildInputs = [ pkg-config protobuf ];

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  propagatedBuildInputs = [
    pyarrow numpy ray
  ];

  pythonImportsCheck = [ "raysql" ];

  meta = with lib; {
    description = "Distributed SQL Query Engine in Python using Ray ";
    homepage = "https://github.com/datafusion-contrib/ray-sql";
    license = licenses.asl20;
    maintainers = [ nviets ];
  };
}

