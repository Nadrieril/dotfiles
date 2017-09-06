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
      owner = "aclements";
      repo = "latexrun";
      rev = "38ff6ec2815654513c91f64bdf2a5760c85da26e";
      sha256 = "0xdl94kn0dbp6r7jk82cwxybglm9wp5qwrjqjxmvadrqix11a48w";
    };

    buildInputs = with pkgs; [
      python3
      (texlive.combine {
        inherit (texlive) scheme-small biblatex logreq xstring bibtex;
      })
      biber
    ];

    dontBuild = true;

    patches = [(pkgs.writeText "latexrun.patch" ''
      diff --git a/test/run b/test/run
      index 4b553d6..6b56bda 100755
      --- a/test/run
      +++ b/test/run
      @@ -72,7 +72,7 @@ def test(latexrun_path, latexrun_args, input_path):
           m = re.search(pre + 'bibtex-cmd: (.*)', input_src, re.I|re.M)
           if m:
               bibtex_cmd = m.group(1)
      -        latexrun_args += ["--bibtex-cmd",  bibtex_cmd]
      +        latexrun_args = latexrun_args + ["--bibtex-cmd",  bibtex_cmd]
       
           m = re.search(pre + 'output:\n((?:' + pre + '.*\n)*)', input_src, re.I|re.M)
           if m:
      '')];

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
}
