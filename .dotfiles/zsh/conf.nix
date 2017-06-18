with import <nixpkgs> {};

let userPackages = [
  ag
  fzf.bin
  gitAndTools.diff-so-fancy
  (import ../nvim/nvim.nix)
];
in

writeText "zshrc" ''
  export PATH="${pkgs.lib.concatMapStrings (pkg: "${pkg}/bin:") userPackages}$PATH"
  source ${fzf.bin}/share/shell/completion.zsh
  source ${fzf.bin}/share/shell/key-bindings.zsh
''
