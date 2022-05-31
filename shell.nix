{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  name = "terraform";
  buildInputs = [
    awscli
    jq
    terraform_0_12
  ];
}
