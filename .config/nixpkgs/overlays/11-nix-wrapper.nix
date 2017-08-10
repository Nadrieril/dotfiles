pkgs: super: {
  nix = pkgs.stdenv.mkDerivation {
    name = "nix-wrapped";
    inherit (super.nix) version dev;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    buildCommand = ''
      mkdir -p $out
      for item in ${super.nix}/*; do
        ln -s $item $out/
      done
      rm $out/bin
      mkdir -p $out/bin
      for item in ${super.nix}/bin/*; do
        ln -s $item $out/bin/
      done
      wrapProgram $out/bin/nix-copy-closure --prefix PATH : ${pkgs.openssh}/bin
    '';

    # passthru = super.nix;
    meta = {
      inherit (super.nix.meta) platforms;
    };
  };
}
