pkgs:
with pkgs;

buildEnv {
  inherit ((import <nixpkgs/nixos> { configuration={}; }).config.system.path)
  pathsToLink ignoreCollisions postBuild;
  extraOutputsToInstall = [ "man" ];
  name = "user-packages";

  paths = [
    neovim_configured
    ag
    fzf.bin
    fasd
    gitAndTools.diff-so-fancy
    # rxvt_unicode
  ];
}

