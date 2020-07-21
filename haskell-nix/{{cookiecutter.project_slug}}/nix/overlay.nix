self: super:

let
  sources = import ./sources.nix;

  inherit (super) lib;
  hlib = super.haskell.lib;
  clean = super.nix-gitignore.gitignoreSource [];

  ghcOverride = input: ovl: input.override (old: {
    overrides = lib.composeExtensions (old.overrides or (_: _: { })) ovl;
  });

  fixGhcWithHoogle = input: ghcOverride input (hself: hsuper: {
    # Compose the selector with a null filter to fix error on null packages
    ghcWithHoogle = selector:
      hsuper.ghcWithHoogle (ps: builtins.filter (x: x != null) (selector ps));
    ghc = hsuper.ghc // { withHoogle = hself.ghcWithHoogle; };
  });

  # Package overrides
  packageOverlay = hself: hsuper: {
    yaml-combinators = hsuper.callCabal2nix "yaml-combinators" (super.fetchFromGitHub {
      owner = "nprindle";
      repo = "yaml-combinators";
      rev = "4bca9747f4e28727d7521d8f75d3342fd6291e77";
      sha256 = "0iw70pbwc1z3jyw2zb8px1q6gdkfcsmpny6h357d3brsx3lnmp65";
    }) {};
  };

  # Result packages
  mainOverlay = hself: hsuper: {
    {{cookiecutter.project_name}} = hsuper.callCabal2nix "{{cookiecutter.project_name}}" (clean ../.) { };
  };

  composeOverlays = lib.foldl' lib.composeExtensions (_: _: { });
  haskellOverlay = composeOverlays [ mainOverlay packageOverlay ];

in {
  niv = (import sources.niv {}).niv;

  haskell = super.haskell // {
    packages = super.haskell.packages // {
      ghc8101 = fixGhcWithHoogle
        (ghcOverride super.haskell.packages.ghc8101 haskellOverlay);
    };
  };
}

