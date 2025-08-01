{ lib, fetchurl, appimageTools, pkgs }:

let
  pname = "polypane";
  version = "25.1.1";

  src = fetchurl {
    url =
      "https://github.com/firstversionist/${pname}/releases/download/v${version}/${pname}-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    sha256 = "03350fpwfq47yv835szqfkhp75nlygm3gipji0slnxdgl7z0g515";
  };

  appimageContents = appimageTools.extractType2 { inherit pname src version; };
in appimageTools.wrapType2 {
  inherit pname src version;

  extraPkgs = pkgs: [ pkgs.bash ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png

    # Fix the desktop file to point to the correct executable
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' "Exec=$out/bin/${pname} --no-sandbox %U" \
      --replace-fail 'Icon=polypane' "Icon=$out/share/icons/hicolor/512x512/apps/${pname}.png"
  '';

  meta = with lib; {
    description = "The browser for devs who care about their craft and users";
    longDescription = ''
      A desktop browser for web devs. Preview viewports side-by-side, audit accessibility, SEO and performance. Built to boost productivity and streamline building and testing.
    '';
    homepage = "https://polypane.app/";
    maintainers = with lib.maintainers; [ mrtrimble ];
    platforms = [ "x86_64-linux" ];
    changelog = "https://polypane.app/docs/changelog/";
    license = licenses.unfree;
    mainProgram = "polypane";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
