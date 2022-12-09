#!/usr/bin/env bash

function kitty-parse-args() {
  if [[ "$1" == ""  ]]; then 
    echo ""
    echo ""
    echo " Available themes: "
    echo " ------------------"
    echo ""
    kitty-ls-themes
    echo ""
    echo "Note: there is no need to add the .conf"
  fi
}

## For now this function will just call ls and replace with sed, but ideally
## some cleverer placing of files into columns would be great.
# 
#  NEEDS:  $DOTFILES (variable)
function kitty-ls-themes() {
  cols=$(tput cols)
  ls -C -w $cols $DOTFILES/kitty/themes/themes | sed 's/\.conf/     /gm'
}


function kitty-set-theme() {
  if [[ "$1" == ""  ]]; then 
    echo ""
    echo ""
    echo " Available themes: "
    echo " ------------------"
    echo ""
    kitty-ls-themes
    echo ""
    echo "Note: use kitty-set-theme NAME to set the theme"
    return
  fi

  name=$(echo "$1" | sed 's/\.conf//')
  fpath=$DOTFILES/kitty/themes/themes/$name.conf
  target="$(realpath ~/.config/kitty)/theme.conf"

  if [ ! -f "$fpath" ]; then 
    echo "theme $name doesn't exist!"
    return
  fi

  # delete original link just in case
  rm -f $target

  # make link
  echo "linking '$fpath' to => $target"
  ln -s "$fpath" "$target"
}

function kitty-help() {
  echo ""
  echo "available kitty commands: "
  echo ""
  echo "  * kitty-ls-themes       (display available themes)"
  echo "  * kitty-set-theme NAME  (set a given theme)"
  echo "  * kitty-help            (show this help)"
  echo ""
}
