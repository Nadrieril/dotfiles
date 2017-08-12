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
    gitAndTools.git-extras
    gnupg
    pass
    xclip
    rxvt_unicode
  ];
}

