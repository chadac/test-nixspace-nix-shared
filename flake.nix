{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { flake-parts, nixpkgs, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem = { pkgs, ... }: {
        packages = {
          buildPythonAwsLambda = import ./python/mk-aws-lambda.nix pkgs;
        };
      };
    };
}
