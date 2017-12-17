pkgs: super: {
  tt-rss-android = pkgs.stdenv.mkDerivation rec {
    name = "tt-rss-android.apk";
    rev = "5bf0da447e001f68fdaa91f27eb967838f88a6e6";
    src = pkgs.fetchurl {
      url = "https://git.tt-rss.org/git/tt-rss-android/archive/${rev}.tar.gz";
      sha256 = "1065p3nnyz4hafz4q20zicaw6xqzmzzbk77fa3dmp37xxbg2nzwl";
    };

    patches = [ ./ttrss-trial-version.patch ];
    postPatch = ''
      version=$(echo ${pkgs.androidsdk}/libexec/platforms/* | sed 's/^.*android-//')
      find . -name "build.gradle" \
        -execdir sed -i \
          -e 's/buildToolsVersion .*/buildToolsVersion '\'${pkgs.androidenv.buildTools.version}\'/ \
          -e 's/compileSdkVersion .*/compileSdkVersion '$version/ \
          '{}' \;
      '';
    nativeBuildInputs = [ pkgs.gradle pkgs.unzip ];
    buildPhase = ''
      export ANDROID_HOME=${pkgs.androidsdk}/libexec
      export ANDROID_NDK_HOME=${pkgs.androidndk}/libexec/${pkgs.androidndk.name}
      mkdir tmp
      mkdir home
      export ANDROID_SDK_HOME=$(readlink -f home)
      gradle build -g tmp -Pandroid.builder.sdkDownload=false
    '';
    installPhase = ''
      cp ./org.fox.ttrss/build/outputs/apk/org.fox.ttrss-release-unsigned.apk $out
    '';

    #sadly, the build is not deterministic but needs internet access
    # use nix-build -K :/
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "0vbvzqys7gh1kj1wdibd3jy6jq92zshcpw8rhsy793v5998ywkdw";
  };
}
