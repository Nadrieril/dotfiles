pkgs:
with pkgs;

let
  defaultEnvParams = (import <nixpkgs/nixos> { configuration={}; }).config.system.path;

  hostname = builtins.getEnv "HOST";
  is_desktop =
    hostname == "meluin" ||
    hostname == "limaew" ||
    hostname == "nawlenca";

  desktop_packages = [
    rxvt_unicode
    powerline-fonts
    firefox
    j4-dmenu-desktop
    evince
    xclip
    spaceFM
    xcape
    mosh
  ];

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
    beep
    jq
    tmux
  ] ++ lib.optionals is_desktop desktop_packages;
}

