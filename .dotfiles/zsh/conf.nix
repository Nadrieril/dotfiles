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

  DISABLE_AUTO_UPDATE="true"
  export ZSH=${oh-my-zsh}/share/oh-my-zsh
  source $ZSH/oh-my-zsh.sh

  source ${fzf.bin}/share/shell/completion.zsh
  source ${fzf.bin}/share/shell/key-bindings.zsh

  fpath+="${zsh-completions}/share/zsh/site-functions"
  source ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
''

