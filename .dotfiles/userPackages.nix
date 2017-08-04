pkgs:
with pkgs;

let defaultEnvParams = (import <nixpkgs/nixos> { configuration={}; }).config.system.path;

in
buildEnv {
  inherit (defaultEnvParams) ignoreCollisions postBuild;
  pathsToLink = defaultEnvParams.pathsToLink ++ [ "/share" ];
  extraOutputsToInstall = [ "man" ];
  name = "user-packages";

  paths = [
    (import ./zshrc.nix)
    neovim_configured
    ag
    fzf.bin
    fasd
    gitAndTools.diff-so-fancy
    # rxvt_unicode
  ];
}

