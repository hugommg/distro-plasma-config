#!/bin/sh

#
# Factorize for 2015.0
#

KRCFG="$(which kreadconfig5)"

if [ ! -z "$KRCFG" ]; then # Check if Plasma is installed, otherwise do nothing

FIRSTRUN=$(kreadconfig5 --group "OpenMandriva" --key "FirstRun" --default "true")

if [ "$FIRSTRUN" = 'true' ]; then

# (tpg) enable xscreensaver
if [ ! -f "$HOME"/.config/autostart/xscreensaver.desktop -a -x "$(which xscreensaver)" ]; then
mkdir -p "$HOME"/.config/autostart
cat > "$HOME"/.config/autostart/xscreensaver.desktop << "EOF"
[Desktop Entry]
Name=XScreenSaver
Exec=xscreensaver -nosplash
Icon=xscreensaver
Terminal=False
Type=Application
X-KDE-StartupNotify=False
OnlyShowIn=KDE;
EOF
fi

#(tpg) add special icons on DESKTOP
USER_DESKTOP="$(xdg-user-dir DESKTOP)"
if [ ! -e "$USER_DESKTOP"/om-welcome.desktop ] && [ -e /usr/share/applications/om-welcome.desktop ]; then
    cp -f /usr/share/applications/om-welcome.desktop "$USER_DESKTOP" 2> /dev/null
    chmod +x "$USER_DESKTOP"/om-welcome.desktop ||:
fi

if [ ! -e "$USER_DESKTOP"/join.desktop ] && [ -e /usr/share/applications/join.desktop ]; then
    cp -f /usr/share/applications/join.desktop "$USER_DESKTOP" 2> /dev/null
    chmod +x "$USER_DESKTOP"/join.desktop ||:
fi

if [ ! -e "$USER_DESKTOP"/donate.desktop ] && [ -e /usr/share/applications/donate.desktop ]; then
    cp -f /usr/share/applications/donate.desktop "$USER_DESKTOP" 2> /dev/null
    chmod +x "$USER_DESKTOP"/donate.desktop ||:
fi

if [ ! -e "$USER_DESKTOP"/calamares.desktop ] && [ -e /usr/share/applications/calamares.desktop ]; then
    cp -f /usr/share/applications/calamares.desktop "$USER_DESKTOP" 2> /dev/null
    chmod +x "$USER_DESKTOP"/calamares.desktop ||:
fi

fi

# GTK settings
FONTS=$(kreadconfig5 --group "OpenMandriva" --key "fontsConfig" --default "false")

if [ ! "$FONTS" = 'true' ]; then
    if [ ! -f "$HOME/.gtkrc-2.0-kde4" ]; then
	### GTK theme apply #####
cat > $HOME/.gtkrc-2.0-kde4 << EOF
include "/usr/share/themes/Breeze/gtk-2.0/gtkrc"
style "user-font"
{
    font_name="Noto Sans Regular"
}
widget_class "*" style "user-font"
gtk-font-name="Noto Sans Regular 10"
gtk-theme-name="Breeze"
gtk-icon-theme-name="breeze"
gtk-fallback-icon-theme="hicolor"
gtk-toolbar-style=GTK_TOOLBAR_ICONS
gtk-menu-images=1
gtk-button-images=1
EOF

fi #FIRSTRUN

if [ ! -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
    mkdir -p $HOME/.config/gtk-3.0
cat > $HOME/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-font-name=Noto Sans Regular 10
gtk-theme-name=Breeze
gtk-icon-theme-name=breeze
gtk-fallback-icon-theme=hicolor
gtk-cursor-theme-name=breeze_cursors
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-menu-images=1
gtk-button-images=1
EOF
fi

if [ ! "$OLDICON" = 'true' ]; then
    # We need to remove the old mdv icons ( music, video, download ) and use KDE ones instead
    MUSICDIR="$(eval "echo $(kreadconfig5 --file $HOME/.config/user-dirs.dirs --key XDG_MUSIC_DIR)" )"
    if [ -z "$MUSICDIR" ]; then
        MUSICDIR="$HOME/Music"
    fi

    if [ -f "$MUSICDIR/.directory" ]; then
	  ICON=$(kreadconfig5 --file $MUSICDIR/.directory --key Icon)

	  if [ "$ICON" == "mdk-music.png" ]; then
	    kwriteconfig5 --file "$MUSICDIR/.directory" --key Icon folder-sound
	  fi
    fi

    if [ ! -e "$MUSICDIR/.directory" ]; then
	    cat >> "$MUSICDIR/.directory" << EOF
[Desktop Entry]
Hidden=true
Icon=folder-sound
EOF
    fi


    DLDIR=$(eval "echo $(kreadconfig5 --file $HOME/.config/user-dirs.dirs --key XDG_DOWNLOAD_DIR)" )

    if [ -z "$DLDIR" ]; then
      DLDIR="$HOME/Download"
    fi

    if [ -f "$DLDIR/.directory" ]; then
      ICON=$(kreadconfig5 --file $DLDIR/.directory --key Icon)

      if [ "$ICON" == "download-mdk.png" ]; then
        kwriteconfig5 --file "$DLDIR/.directory" --key Icon folder-downloads
      fi
    fi

    if [ ! -e "$DLDIR/.directory" ]; then
              cat >> "$DLDIR/.directory" << EOF
[Desktop Entry]
Hidden=true
Icon=folder-downloads
EOF
    fi

    DOCDIR=$(eval "echo $(kreadconfig5 --file $HOME/.config/user-dirs.dirs --key XDG_DOCUMENTS_DIR)" )

    if [ -z "$DOCDIR" ]; then
      DOCDIR="$HOME/Download"
    fi

    if [ -f "$DOCDIR/.directory" ]; then
      ICON=$(kreadconfig5 --file $DOCDIR/.directory --key Icon)

      if [ "$ICON" == "document-mdk.png" ]; then
        kwriteconfig5 --file "$DOCDIR/.directory" --key Icon folder-documents
      fi
    fi

    if [ ! -e "$DOCDIR/.directory" ]; then
      cat >> "$DOCDIR/.directory" << EOF
[Desktop Entry]
Hidden=true
Icon=folder-documents
EOF
    fi


    PICTUREDIR=$(eval "echo $(kreadconfig5 --file $HOME/.config/user-dirs.dirs --key XDG_PICTURES_DIR)" )

    if [ -z "$PICTUREDIR" ]; then
      PICTUREDIR="$HOME/Picture"
    fi

    if [ -f "$PICTUREDIR/.directory" ]; then
      ICON=$(kreadconfig5 --file $PICTUREDIR/.directory --key Icon)

      if [ "$ICON" == "picture-mdk.png" ]; then
        kwriteconfig5 --file "$PICTUREDIR/.directory" --key Icon folder-image
      fi
    fi

    if [ ! -e "$PICTUREDIR/.directory" ]; then
      cat >> "$PICTUREDIR/.directory" << EOF
[Desktop Entry]
Hidden=true
Icon=folder-image
EOF
    fi

    VIDEOSDIR=$(eval "echo $(kreadconfig5 --file $HOME/.config/user-dirs.dirs --key XDG_VIDEOS_DIR)" )

    if [ -z "$VIDEOSDIR" ]; then
        VIDEOSDIR="$HOME/Video"
    fi

    if [ -f "$VIDEOSDIR/.directory" ]; then
      ICON=$(kreadconfig5 --file $VIDEOSDIR/.directory --key Icon)

      if [ "$ICON" == "video-mdk.png" ]; then
        kwriteconfig5 --file "$VIDEOSDIR/.directory" --key Icon folder-video
      fi
    fi

    if [ ! -e "$VIDEOSDIR/.directory" ]; then
      cat >> "$VIDEOSDIR/.directory" << EOF
[Desktop Entry]
Hidden=true
Icon=folder-video
EOF
   fi
   kwriteconfig5 --group "OpenMandriva" --key "IconMigration" --type "bool" 1
 fi

 fi

# firsrun end
if [ "$FIRSTRUN" = 'true' ]; then
    kwriteconfig5 --group "OpenMandriva" --key "FirstRun" --type "bool" "false"
fi

fi

chmod 0666 "$HOME"/.face.icon
#end of kde check
