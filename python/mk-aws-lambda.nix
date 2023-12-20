# Build a Python application as an AWS lambda
pkgs:
{
  python3 ? pkgs.python3,
  stdenv ? pkgs.stdenv,
  zip ? pkgs.zip,
  module ? "index",
  handler ? "handler"
}:
args:
let
  pkg = python3.buildPythonApplication args;
  env = python3.withPackages (p: [ pkg ]);
  deriv = stdenv.mkDerivation {
    inherit (pkg) name;

    unpackPhase = ''
      if ! test -f ${pkg}/${python3.sitePackages}/${pkg.pname}/${module}.py; then
        >&2 echo "error: could not find handler path at ${module}.py; ensure it exists before building."
        exit 1
      fi
    '';

    buildPhase = ''
      zip -r lambda.zip ${env}/${python3.sitePackages}
    '';

    # TODO: Ensure this meets lambda size limit requirements
    checkPhase = "true";

    installPhase = ''
      cp ./lambda.zip $out
    '';

    passthru = {
      inherit pkg;
      inherit env;
      # tf-related metadata
      tf_resource = {
        handler_name = "${pkg.pname}.${module}.${handler}";
        runtime = "python${python3.pythonVersion}";
        filename = "${deriv}";
        source_code_hash = deriv;
      };
    };
  };
  lambdaHash = builtins.hashString "sha256" "${deriv}";
in deriv
