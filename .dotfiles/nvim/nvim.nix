with import <nixpkgs> {};

neovim.override {
  configure = {
    vam = {
      knownPlugins = 
        let
          makePlugin = name: value: vimUtils.buildVimPluginFrom2Nix { inherit name; src = fetchgit value; };
          pluginSrcs = builtins.fromJSON (builtins.readFile ./nvim-plugins.json);
        in vimPlugins // (lib.mapAttrs makePlugin pluginSrcs);

      # There's a list of available plugins here:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vim-plugins/vim-plugin-names
      pluginDictionaries = [
        { names = [
            ## Git
            "vim-gitgutter"
            "fugitive" # Overpowered git plugin

            ## UI
            "onedark"
            "indentline"
            "vim-airline"
            "vim-airline-themes"

            ## Textobjs
            "vim-textobj-user" # Dependency for the other textobj plugins
            "vim-textobj-parameter" # ',' for parameter textobj ("blah, blih, bluh")
            "vim-textobj-variable-segment" # 'v' for variable segment textobj ("foo_bar_quux")
            "vim-indent-object" # 'i' and 'I' for indented block textobj
            "vim-textobj-lastpat" # '/' and '?' for last area matchedby search

            ## Help edition
            "auto-pairs"
            "commentary"
            "surround"
            "undotree"
            "vim-easymotion"
            "vim-exchange" # Swap text selections
            "vim-multiple-cursors"
            "vim-repeat" # Better '.'
            "vim-rsi" # Readline bindings in insert/command mode
            "vim-swap" # Swap text around given delimiter

            ## Others
            "ctrlp"
            "sleuth" # Infer buffer options
            "vim-eunuch" # Unix helpers; auto-chmod +x scripts
            "vim-obsession" # Ease session saving
            "vim-stay" # Remember cursor position when reopening file
            "vinegar" # Improved file explorer
        ]; }

        { ft_regex = "\.pandoc\$"; name = "vim-pandoc-syntax"; }
        { ft_regex = "^nix\$"; name = "vim-nix"; }
        { ft_regex = "^scala\$"; name = "vim-scala"; }
        { ft_regex = "^ledger\$"; name = "vim-ledger"; }
        { ft_regex = "^rust\$"; name = "vim-rust"; }
        { ft_regex = "^haskell\$";
          names = [
            "vimproc"
            "ghcmod"
            "neco-ghc"
            "haskell-vim"
            "hlint-refactor-vim"
          ];
        }

        ## Lazy loaded
        { tag = "lazy";
          names = [
            "syntastic"
            "supertab"
            "vim-snippets"
            "deoplete-nvim"
            "vimpager" # Turn vim into a pager
            "vim-rhubarb" # Github add-on for fugitive
            # "rainbow_parentheses"
            # "ale" # Asynchronous linter
          ];
        }


      ];
    };

    customRC = ''
      source ~/.config/nvim/init.vim

      au BufRead,BufNewFile *.nix set filetype=nix
      au BufRead,BufNewFile *.j set filetype=ledger

      " Disable haskell-vim omnifunc
      let g:haskellmode_completion_ghc = 0
      autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

      let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`

      " Use deoplete.
      let g:deoplete#enable_at_startup = 1

      map <silent> <leader>ht :GhcModType<CR>
      map <silent> <leader>hT :GhcModTypeInsert<CR>
      map <silent> <leader>hc :GhcModSplitFunCase<CR>
      map <silent> <leader>hl :GhcModTypeClear<CR>
      
      " Disable hlint-refactor-vim's default keybindings
      let g:hlintRefactor#disableDefaultKeybindings = 1

      " hlint-refactor-vim keybindings
      map <silent> <leader>hr :call ApplyOneSuggestion()<CR>
      map <silent> <leader>hR :call ApplyAllSuggestions()<CR>
    '';
  };
}

