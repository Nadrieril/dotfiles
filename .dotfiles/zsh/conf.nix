with import <nixpkgs> {};

writeText "zshrc" ''
  export PATH="$PATH:${ag}/bin"
  export PATH="$PATH:${fzf.bin}/bin"
  export PATH="$PATH:${gitAndTools.diff-so-fancy}/bin"
  source ${fzf.bin}/share/shell/completion.zsh
  source ${fzf.bin}/share/shell/key-bindings.zsh
''

