{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, ... }@inputs: {};
    # flake-parts.lib.mkFlake { inherit inputs; } {
    #   systems = import systems;
    #   # perSystem = { pkgs, ... }: {
    #   #   lib = {
    #   #     buildPythonAwsLambda = import ./python/mk-aws-lambda.nix pkgs;
    #   #   };
    #   #   apps = { };
    #   #   packages = { };
    #   # };
    # };
}
