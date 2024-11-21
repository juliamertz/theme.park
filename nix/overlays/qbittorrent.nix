{
  prev,
  themeType,
  themeName,

  gnused,
  perl,
  runCommand,
  ...
}:
prev.overrideAttrs (_: {
  src =
    runCommand "patch-theme"
      {
        nativeBuildInputs = [
          gnused
          perl
        ];
      }
      ''
        cp --no-preserve=mode -r ${prev.src} $out
        www=$out/src/webui/www
        css=${../../css}
        theme_out=$www/public/css/theme-park.css

        clean_file() {
            perl -i -pe 's/QBT_TR?\(//g' "$1"
            perl -i -pe 's/\)QBT_TR\[CONTEXT=.*?\]//g' "$1"
        }

        sed_file() {
            sed -i "s/<\/body>/<link rel='stylesheet' href='css\/theme-park.css?v=\''${CACHEID}'><\/body> /g" $1
        }

        # copy theme and add as public resource
        cat $css/base/qbittorrent/qbittorrent-base.css > $theme_out
        echo -e '\n\n/* ${themeName}.css */\n' >> $theme_out
        cat $css/${themeType}/${themeName}.css >> $theme_out
        sed -i "s/<\/qresource>/<file>public\/css\/theme-park.css<\/file><\/qresource> /g" $www/webui.qrc

        # add stylesheet imports to html files
        sed_file $www/public/index.html
        clean_file $www/public/index.html
        find $www/private -type f -iname "*.html" | while read fname
        do
            sed_file $fname
        done
      '';
})
