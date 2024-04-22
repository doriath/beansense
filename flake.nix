{
  description = "Development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rust = pkgs.rust-bin.nightly.latest.default.override {
          targets = ["wasm32-wasi" "wasm32-unknown-unknown"];
        };
        rustPlatform = pkgs.recurseIntoAttrs (pkgs.makeRustPlatform {
          rustc = rust;
          cargo = rust;
        });
        trunk = rustPlatform.buildRustPackage {
          name = "trunk";
          version = "0.18.8";
          src = pkgs.fetchFromGitHub {
            owner = "trunk-rs";
            repo = "trunk";
            rev = "a7d187e5fb97bbbd9a7112fb0b910468ab682eac";
            hash = "sha256-cx14IVqsu1SQezs8T1HFZ75+MPWkvf5RcvGCodW5G4A=";
          };
          cargoSha256 = "sha256-Japj3k5BXoYbKDIpnhCgCyT24HRuinEhROHzB7FyE7o=";
          buildInputs = [
            pkgs.openssl.dev
          ];
          nativeBuildInputs = [
            pkgs.pkg-config
          ];
          # tests are not hermetic
          doCheck = false;
        };
        leptosfmt = rustPlatform.buildRustPackage {
          name = "leptosfmt";
          version = "0.18.8";
          src = pkgs.fetchFromGitHub {
            owner = "bram209";
            repo = "leptosfmt";
            rev = "0.1.18";
            hash = "sha256-bNfTZgcru7PJR/9AcaOmW0E8QwdiXcuP7MWXcDPXGso=";
          };
          cargoSha256 = "sha256-EsOfMA56l1SvAvyGJ3l7XgAg/gyqSllx8onsj0HbbSQ=";
          buildInputs = [
          ];
          nativeBuildInputs = [
            pkgs.pkg-config
          ];
          # tests are not hermetic
          # doCheck = false;
        };

      in
      rec
      {
        formatter = pkgs.nixpkgs-fmt;

        packages = flake-utils.lib.flattenTree {
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.pkg-config
          ];
          buildInputs = [
            pkgs.autoconf
            pkgs.automake
            pkgs.bashInteractive
            pkgs.cmake
            pkgs.nodejs-18_x
            pkgs.tailwindcss
            rust
            pkgs.rust-analyzer
            trunk
            leptosfmt
          ];
          shellHook = ''
          '';
        };
      }
    );
}
