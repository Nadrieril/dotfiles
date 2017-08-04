with import <nixpkgs> {};

let
  prompt = let
    intercalate = f: l:
      lib.concatLists (
        lib.zipListsWith (x: next_x:
          [ x (f x next_x) ]
        ) l (lib.tail l)
      ) ++ lib.singleton (lib.last l);

    separator = "";
    default_fg = 15;
    default_bg = 16;

    write_color = c: "%{${c}%}";
    write_segment = { text ? "", fg ? default_fg, bg ? default_bg, bold ? false }:
      (if bold then write_color "[1m" else "") +
      write_color "[38;5;${toString fg}m" +
      write_color "[48;5;${toString bg}m" +
      text +
      write_color "[0m";

    pwrl = segments:
      let get_bg = s: if s?bg then s.bg else default_bg; in
      lib.concatMapStrings write_segment (
        intercalate (prev_s: next_s:
          { fg=get_bg prev_s; bg=get_bg next_s; text=separator; }
        ) segments
      );

    in ''
      function git_prompt_info() {
        ref=$(git symbolic-ref HEAD 2> /dev/null)
        if [ $? -eq 0 ]; then
          echo "${pwrl [ { bg=240; } { fg=250; bg=238; text=" ${"$"}{ref#refs/heads/} "; } {} ]}"
        else
          echo '${pwrl [ { bg=240; } {} ]}'
        fi
      }

      PROMPT=$'\n'
      PROMPT=$PROMPT'${pwrl [
        {fg=250;bg=240;text=" %M ";}
        {fg=250;bg=238;text=" %(!.%{'$fg[red]'%}.)%n ";}
        {fg=15;bg=31;bold=true;text=" %~ ";}
        {fg=250;bg=240;text=" %* ";}
      ]}$(git_prompt_info)'$'\n'
      PROMPT=$PROMPT'${pwrl [ { bg=236; text="%{%(?:'$fg_bold[green]':'$fg_bold[red]')%} $ ";} {} ]} '
  '';

  text =  ''
    DISABLE_AUTO_UPDATE="true"
    export ZSH=${oh-my-zsh}/share/oh-my-zsh
    source $ZSH/oh-my-zsh.sh

    source ${fzf.out}/share/shell/completion.zsh
    source ${fzf.out}/share/shell/key-bindings.zsh

    fpath+="${zsh-completions}/share/zsh/site-functions"
    fpath+="${nix-zsh-completions}/share/zsh/site-functions"
    source ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    ${prompt}
  '';
in

writeTextFile { name="zshrc"; destination="/share/zshrc"; text=text; }

