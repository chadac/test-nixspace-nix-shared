{ pkgs }:
let
  inherit (pkgs) lib;
  callPackage = lib.callPackageWith (pkgs // { inherit shared; });
  shared = {
    deterministic-zip = callPackage ./deterministic-zip { };
    python = {
      buildAWSLambda = callPackage ./python/mk-aws-lambda.nix;
    };
  };
in shared
