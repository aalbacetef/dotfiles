#!/usr/bin/env bash

if [[ "$1" == ""  ]]; then 
  echo "" 
  echo ""
  echo " Available themes: "
  echo " ------------------"
  echo ""
  ls $DOTFILES/kitty/themes/themes
  echo ""
  echo "Note: there is no need to add the .conf"
  exit
fi



name=$(echo "$1" | sed 's/\.conf//')
name=$(echo "$name" | sed 's/.*/\u&/')
fpath=$DOTFILES/kitty/themes/themes/$name.conf
target="$(realpath ~/.config/kitty)/theme.conf"

if [ ! -f "$fpath" ]; then 
  echo "them $name doesn't exist!"
  exit
fi

# delete original link just in case
rm -f $target

# make link
echo "linking '$fpath' to => $target"

ln -s "$fpath" "$target"

