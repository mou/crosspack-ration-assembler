{
  description = "Exyaru (Atushka) project";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      rec {
        devShell = pkgs.mkShell {
          buildInputs = (with pkgs.elmPackages; [
            elm
            elm-format
            elm-live
            elm-test
          ]) ++ (with pkgs; [
            nodejs
          ]);
        };
      }); 
}
 
