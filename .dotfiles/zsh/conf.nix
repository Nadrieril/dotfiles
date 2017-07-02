with import <nixpkgs> {};

writeText "zshrc" ''
  DISABLE_AUTO_UPDATE="true"
  export ZSH=${oh-my-zsh}/share/oh-my-zsh
  source $ZSH/oh-my-zsh.sh

  source ${fzf.out}/share/shell/completion.zsh
  source ${fzf.out}/share/shell/key-bindings.zsh

  fpath+="${zsh-completions}/share/zsh/site-functions"
  fpath+="${nix-zsh-completions}/share/zsh/site-functions"
  source ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
''

