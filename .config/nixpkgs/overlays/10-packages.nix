pkgs: super: rec {
#   python27 = super.python27.override { packageOverrides = self: super: {
#     taskcoach = super.taskcoach.override rec {
#       name = "TaskCoach-1.4.3";
#
#       src = pkgs.fetchurl {
#         url = "mirror://sourceforge/taskcoach/${name}.tar.gz";
#         sha256 = "0aqs0wsj9gb1yvmqd9xvbicm5pkwsnid2yp4rfh5anqdzkz5z252";
#       };
#
#       propagatedBuildInputs = with self; [ wxPython twisted ];
#     };
#   };};

  beep = pkgs.writeScriptBin "beep" ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.pulseaudioLight}/bin/paplay ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/dialog-warning.oga
  '';

  rxvt_unicode = super.rxvt_unicode.overrideAttrs (_: {
    patches = [ (pkgs.writeText "urxvt.patch" ''
      diff --git a/src/command.C b/src/command.C
      index 7b79f51..8aa28c9 100644
      --- a/src/command.C
      +++ b/src/command.C
      @@ -788,7 +788,7 @@ rxvt_term::key_press (XKeyEvent &ev)
                   }
               }
       
      -      if (ctrl && meta && (keysym == XK_c || keysym == XK_v))
      +      if ((ev.state & Mod4Mask) && (keysym == XK_c || keysym == XK_v))
               {
                 if (keysym == XK_v)
                   selection_request (ev.time, Sel_Clipboard);
    '') ];
  });

  neovim = super.neovim.overrideAttrs (_: {
    patches = [ (pkgs.writeText "neovim.patch" ''
      diff --git a/src/nvim/normal.c b/src/nvim/normal.c
      index 050020d7..ef2c9113 100644
      --- a/src/nvim/normal.c
      +++ b/src/nvim/normal.c
      @@ -2477,7 +2477,7 @@ do_mouse (
             }
           }
           return true;
      -  } else if (is_drag && in_tab_line) {
      +  } else if (mouse_row == 0 && is_drag && in_tab_line) {
           move_tab_to_mouse();
           return false;
         }
    '') ];
  });

  shutilwhich = pkgs.python3Packages.buildPythonPackage {
    name = "shutilwhich-1.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "mbr";
      repo = "shutilwhich";
      rev = "1.1.0";
      sha256 = "05fwcjn86w8wprck04iv1zccfi39skdf0lhwpb4b9gpvklyc9mj0";
    };
  };

  panflute = pkgs.python3Packages.buildPythonPackage {
    name = "panflute-9dd160a";

    src = pkgs.fetchFromGitHub {
      owner = "sergiocorreia";
      repo = "panflute";
      rev = "9dd160ac27e0124ffa4c110aaec3035803dbcc84";
      sha256 = "16vry11x5ckc3i56jn16j4na4mm14a2p6s3ab1j41rbssi6y2dxj";
    };

    buildInputs = [ pkgs.pandoc pkgs.python3Packages.pandocfilters ];

    propagatedBuildInputs = with pkgs.python3Packages; [ pyyaml future shutilwhich ];

    meta = {
      homepage = http://scorreia.com/software/panflute;
      description = "An Pythonic alternative to John MacFarlane's pandocfilters, with extra helper functions";
    };
  };

  nheqminer_cpu = pkgs.stdenv.mkDerivation {
    name = "nheqminer_cpu";

    src = pkgs.fetchFromGitHub {
      owner = "nicehash";
      repo = "nheqminer";
      rev = "eb37570583ec639b4270e08b429ceb9bc6fe3077";
      sha256 = "0825kspi1fjr5w4rpp7ay8fcsi7idl8abrgf2l51q6jwxippw49y";
    };

    buildInputs = with pkgs; [
      boost
      cmake
    ];

    dontUseCmakeConfigure = true;

    buildPhase = ''
      cd cpu_xenoncat/Linux/asm/
      sh assemble.sh

      cd ../../../Linux_cmake/nheqminer_cpu
      cmake .
      make -j 8
    '';

    installPhase = ''
      mkdir -p $out/bin
      mv nheqminer_cpu $out/bin/
    '';
  };

  latexrun = pkgs.pythonPackages.buildPythonPackage {
    name = "latexrun";

    src = pkgs.fetchFromGitHub {
      owner = "Nadrieril";
      repo = "latexrun";
      rev = "02305f9f2168846afc1408c621d2c7ac00fd785c";
      sha256 = "0mgpbq02mna2m15mwci9sw45mj9x446nkzl9wg58jizxrddk16bb";
    };

    buildInputs = with pkgs; [
      python3
      (texlive.combine {
        inherit (texlive) scheme-small biblatex logreq xstring bibtex;
      })
      biber
    ];

    dontBuild = true;

    checkPhase = ''
      cd test
      rm -r T-biblatex-bibtex  # fails because of a biblatex warning
      ./runall
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp latexrun $out/bin/
    '';
  };

  tor-browser-bundle-bin = super.tor-browser-bundle-bin.override {
    extraPrefs = ''
      lockPref("browser.tabs.remote.autostart", false);
      lockPref("browser.tabs.remote.autostart.2", false);
    '';
  };

  git-annex-utils = pkgs.stdenv.mkDerivation {
    name = "git-annex-utils";

    src = pkgs.fetchurl {
      url = "http://git-annex.mysteryvortex.com/files/releases/git-annex-utils-latest.tar.bz2";
      sha256 = "6d01a133b0bc9fef79009977aa5142ad85cacf7b57cdd8503c63cde21c1ed0e2";
    };

    buildInputs = with pkgs; [
      gmp
    ];
  };

  chromium = super.chromium.override { enablePepperFlash = true; };

  haskellPackages = super.haskellPackages.extend (hself: hsuper: {
    hledger-lib = with pkgs; with hself; mkDerivation {
      pname = "hledger-lib";
      version = "1.4";
      src = (fetchFromGitHub {
        owner = "nadrieril";
        repo = "hledger";
        rev = "ad4cd4fb87c9e82d8832279547165263e59fa9c9";
        sha256 = "117d1jq94ns606rgyzfzzfdvjqmwk0c9awzhn0gacy7nbjv6absl";
      }) + "/hledger-lib";
      enableSeparateDataOutput = true;
      libraryHaskellDepends = [
        ansi-terminal array base base-compat blaze-markup bytestring
        cmdargs containers csv data-default Decimal deepseq directory extra
        filepath hashtables HUnit megaparsec mtl mtl-compat old-time parsec
        pretty-show regex-tdfa safe semigroups split text time transformers
        uglymemo utf8-string
      ];
      testHaskellDepends = [
        ansi-terminal array base base-compat blaze-markup bytestring
        cmdargs containers csv data-default Decimal deepseq directory
        doctest extra filepath Glob hashtables HUnit megaparsec mtl
        mtl-compat old-time parsec pretty-show regex-tdfa safe semigroups
        split test-framework test-framework-hunit text time transformers
        uglymemo utf8-string
      ];
      homepage = "http://hledger.org";
      description = "Core data types, parsers and functionality for the hledger accounting tools";
      license = stdenv.lib.licenses.gpl3;
    };
  });
}
