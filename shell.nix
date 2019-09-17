with import <nixpkgs> {};
let ghc = haskell.compiler.ghc864;
in haskell.lib.buildStackProject {
  inherit ghc;
  name = "myEnv";
  buildInputs = [ zlib.dev zlib.out ];
}