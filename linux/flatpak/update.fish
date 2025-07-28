#!/usr/bin/env fish

set script_path (status current-filename)
set script_dir (dirname $script_path)

function now
  date +"%Y-%m-%d--%T"
end

set generated_at (now)
set flatpak_file $script_dir/flatpak.yml
set backup_file $script_dir/flatpak.$generated_at.backup.yml

function list_apps
  flatpak list -u \
    --columns=application,name,version,branch | grep -v '\.Platform' | sort
end 

function backup_file 
  if test -f $flatpak_file
    echo "backing up file: "
    echo "  mv $flatpak_file $backup_file"
    mv $flatpak_file $backup_file
  end 
end 

function write_metadata 
  echo -n "writing metadata..."

  echo "metadata:" > $flatpak_file
  echo "  date-generated: '$generated_at'" >> $flatpak_file
  echo "  app-count: "(list_apps | wc -l) >> $flatpak_file
  echo "" >> $flatpak_file

  echo "done"
end 

function save_apps
  set -f tab (echo -e "\t")
  set -f id_index 1
  set -f name_index 2
  set -f version_index 3
  set -f branch_index 4

  echo "saving apps: "

  echo "apps:" >> $flatpak_file
  for line in (list_apps)
    set -l name (echo $line | cut -d $tab -f $name_index)
    set -l id (echo $line | cut -d $tab -f $id_index)
    set -l app_version (echo $line | cut -d $tab -f $version_index)

    echo "  - name: '$name'" >> $flatpak_file
    echo "    id: $id" >> $flatpak_file 
    echo "    version: $app_version" >> $flatpak_file

    echo "" >> $flatpak_file 

    echo "  wrote app: $name"
  end
  
  echo "done"
end 

backup_file 
write_metadata
save_apps
