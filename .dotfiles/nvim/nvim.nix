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
            "auto-pairs"
            # "committia.vim"
            # "ctrlp.vim"
            # "indentline"
            "onedark"
            # "ShowMarks"
            "syntastic"
            # "undotree"
            "vim-airline"
            "vim-airline-themes"
            "commentary"
            # "vim-easymotion"
            # "vim-eunuch"
            # "vim-exchange"
            # "vim-fugitive"
            "vim-gitgutter"
            # "vim-indent-object"
            # "vim-ledger"
            "vim-multiple-cursors"
            "vim-nix"
            # "vim-obsession"
            # "vimpager"
            # "github:vim-pandoc/vim-pandoc-syntax"
            # "github:tpope/vim-repeat"
            # "vim-rsi"
            # "github:derekwyatt/vim-scala"
            # "vim-sleuth"
            # "vim-stay"
            "surround"
            # "vim-swap"
            # "vim-textobj-parameter"
            # "vim-textobj-user"
            # "vim-textobj-variable-segment"
            # "vim-vinegar"
        ]; }

        # { name = "neomake"; }
        # { name = "supertab"; }
        # { name = "Tabular"; }
        # { name = "ghcmod"; ft_regex = "^haskell\$"; }
        # { name = "vimproc"; }
        # { name = "neco-ghc"; ft_regex = "^haskell\$"; }


      ];
    };

    customRC = ''
      source /home/nadrieril/.config/nvim/init.vim
    '';
  };
}

