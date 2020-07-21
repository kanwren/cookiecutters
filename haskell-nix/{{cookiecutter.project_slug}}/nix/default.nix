let
  # If using niv
  sources = import ./sources.nix;

  pkgs = import sources.nixpkgs {
    # Use nix-haskell-overlay to write the overlay
    overlays = [ (import ./overlay.nix) ];
  };

  hpkgs = pkgs.haskell.packages.ghc8101;
in

rec {
  inherit (hpkgs) {{cookiecutter.project_name}};

  shell = hpkgs.shellFor {
    packages = ps: with ps; [ {{cookiecutter.project_name}} ];

    buildInputs = (with pkgs; [
      # Needed for niv
      niv nix cacert
    ]) ++ (with hpkgs; [
      ghcid
      cabal-install
      (pkgs.haskell.lib.doJailbreak threadscope)
    ]);

    withHoogle = true;
    exactDeps = true;
  };
}

