let
  pkgs = import <nixpkgs> {};

in

pkgs.stdenv.mkDerivation {
  name = "tmux-sensible";
  src = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tmux-sensible";
    rev = "e91b178ff832b7bcbbf4d99d9f467f63fd1b76b5";
    sha256 = "1z8dfbwblrbmb8sgb0k8h1q0dvfdz7gw57las8nwd5gj6ss1jyvx";
  };

  installPhase = ''
    mkdir -p $out/share
    cp $src/sensible.tmux $out/share/sensible.tmux
  '';
}
