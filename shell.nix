{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;
  elixir = beam.packages.erlangR22.elixir_1_9;
  nodejs = nodejs-10_x;
  locales = glibcLocales;
in

mkShell {
  buildInputs = [ nodejs elixir git postgresql locales ]
    ++ optional stdenv.isLinux inotify-tools # For file_system on Linux.
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      # For file_system on macOS.
      CoreFoundation
      CoreServices
    ]);

      PGDATA="$PWD/db";
      LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive";
      LC_ALL="en_US.UTF-8";
      LANG="en_US.UTF-8";
      LANGUAGE="en_US.UTF-8";
      ERL_AFLAGS="-kernel shell_history enabled";
  }
