# Build a Python application as an AWS lambda
{
  python3,
  stdenv,
  coreutils,
  zip,
  shared,
  module ? "index",
  handler ? "handler"
}:
args:
let
  pkg = python3.pkgs.buildPythonPackage args;
  pyPkgName = builtins.replaceStrings ["-"] ["_"] pkg.pname;
  env = python3.withPackages (p: [ pkg ]);
  pyPkgPath = "${pkg}/${python3.sitePackages}/${pyPkgName}/${module}.py";
  deriv = stdenv.mkDerivation {
    name = "lambda-${pkg.name}";

    unpackPhase = ''
      if ! [ -f "${pyPkgPath}" ]; then
        >&2 echo "error: could not find handler path at '${pyPkgPath}'; ensure it exists before building."
        exit 1
      fi
    '';

    buildPhase = ''
      export LAMBDA_NAME=$(mktemp -d)/lambda.zip
      pushd ${env}/${python3.sitePackages}
      ${shared.deterministic-zip}/bin/deterministic-zip -r $LAMBDA_NAME .
      popd
    '';

    # TODO: Ensure this meets lambda size limit requirements
    checkPhase = ''
    lambdasize=$(${coreutils}/bin/wc -c <"$LAMBDA_NAME")
    if [ $lambdasize -ge 50000000 ]; then
      >&2 echo "warning: lambda is larger than 50MB. https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html"
    fi
    '';

    installPhase = ''
      cp $LAMBDA_NAME $out
    '';

    passthru = {
      inherit pkg;
      inherit env;
      # tf-related metadata
      tf_resource = {
        handler_name = "${pyPkgName}.${module}.${handler}";
        runtime = "python${python3.pythonVersion}";
        filename = "${deriv}";
        source_code_hash = deriv;
      };
    };
  };
  lambdaHash = builtins.hashString "sha256" "${deriv}";
in deriv
