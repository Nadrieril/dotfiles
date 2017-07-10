pkgs: super: {
  nix = pkgs.stdenv.mkDerivation {
    name = "nix-wrapped";
    inherit (super.nix) version meta;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    buildCommand = ''
      mkdir -p $out/bin
      for item in ${super.nix}/bin/*; do
        ln -s $item $out/bin/
      done
      wrapProgram $out/bin/nix-copy-closure --prefix PATH : ${pkgs.openssh}/bin
    '';

    passthru = super.nix;
  };
}
