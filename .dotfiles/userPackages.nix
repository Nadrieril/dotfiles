pkgs:
with pkgs;

let
  defaultEnvParams = (import <nixpkgs/nixos> { configuration={}; }).config.system.path;

  hostname = builtins.getEnv "HOST";
  is_desktop =
    hostname == "meluin" ||
    hostname == "limaew" ||
    hostname == "wilwarin" ||
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
    vlc
    pass
    beep
    pythonPackages.py3status
    cmatrix
    cabal2nix
    filezilla
    thunderbird
    # hledger
    # hledger-web
    ledger
    libreoffice-fresh
    pandoc
    pavucontrol
    biber
    file
    deluge
    latexrun
    pythonPackages.weboob
    python3
    panflute
    smartmontools
    speedtest-cli
    stack
    nix-repl
    nix-prefetch-git
    gitAndTools.git-annex
    git-annex-utils
    graphviz
    imagemagick
    jhead
    jmtpfs
    keepass
    haskellPackages.lhs2tex
    xorg.xev
    xarchiver
    yubioath-desktop
    gnome3.nautilus
  ];

in
buildEnv {
  inherit (defaultEnvParams) ignoreCollisions postBuild;
  pathsToLink = defaultEnvParams.pathsToLink ++ [ "/share" ];
  extraOutputsToInstall = [ "man" ];
  name = "user-packages";

  paths = [
    (import ./zshrc.nix)
    (import ./tmux-sensible.nix)
    neovim_configured
    ag
    fzf.bin
    fasd
    git
    gitAndTools.diff-so-fancy
    gitAndTools.git-extras
    tig
    colordiff
    gnupg
    jq
    tmux
    dos2unix
    gnumake
    ncdu
    tree
    nmap
    traceroute
    telnet
    ctags
    arp-scan
    iotop
    unzip
    usbutils
  ] ++ lib.optionals is_desktop desktop_packages;
}

