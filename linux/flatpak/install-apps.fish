#!/usr/bin/env fish

set curr_dir (dirname (status current-filename))
set apps (grep 'id:' "$curr_dir/flatpak.yml" | cut -d':' -f 2 | sed 's/ //g')


echo "==========================="

for app in $apps
  echo "installing: $app"
  flatpak install --app "$app"
  echo "==========================="
end
