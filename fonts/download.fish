#!/usr/bin/env fish 


set download_url 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/{{NAME}}.zip'

set downloadList '3270'
set -a downloadList 'Agave'
set -a downloadList 'AnonymousPro'
set -a downloadList 'Arimo'
set -a downloadList 'AurulentSansMono'
set -a downloadList 'BigBlueTerminal'
set -a downloadList 'BitstreamVeraSansMono'
set -a downloadList 'CascadiaCode'
set -a downloadList 'IBMPlexMono'
set -a downloadList 'CodeNewRoman'
set -a downloadList 'ComicShannsMono'
set -a downloadList 'Cousine'
set -a downloadList 'DaddyTimeMono'
set -a downloadList 'DejaVuSansMono'
set -a downloadList 'DroidSansMono'
set -a downloadList 'EnvyCodeR'
set -a downloadList 'FantasqueSansMono'
set -a downloadList 'FiraCode'
set -a downloadList 'FiraMono'
set -a downloadList 'Gohu'
set -a downloadList 'Go-Mono'
set -a downloadList 'Hack'
set -a downloadList 'Hasklig'
set -a downloadList 'HeavyData'
set -a downloadList 'Hermit'
set -a downloadList 'iA-Writer'
set -a downloadList 'Inconsolata'
set -a downloadList 'InconsolataGo'
set -a downloadList 'InconsolataLGC'
set -a downloadList 'IntelOneMono'
set -a downloadList 'Iosevka'
set -a downloadList 'IosevkaTerm'
set -a downloadList 'JetBrainsMono'
set -a downloadList 'Lekton'
set -a downloadList 'LiberationMono'
set -a downloadList 'Lilex'
set -a downloadList 'Meslo'
set -a downloadList 'Monofur'
set -a downloadList 'Monoid'
set -a downloadList 'Mononoki'
set -a downloadList 'MPlus'
set -a downloadList 'Noto'
set -a downloadList 'OpenDyslexic'
set -a downloadList 'Overpass'
set -a downloadList 'ProFont'
set -a downloadList 'ProggyClean'
set -a downloadList 'RobotoMono'
set -a downloadList 'ShareTechMono'
set -a downloadList 'SourceCodePro'
set -a downloadList 'SpaceMono'
set -a downloadList 'NerdFontsSymbolsOnly'
set -a downloadList 'Terminus'
set -a downloadList 'Tinos'
set -a downloadList 'Ubuntu'
set -a downloadList 'UbuntuMono'
set -a downloadList 'VictorMono'



function show_required
  for name in $downloadList 
    if not test -d $name
      echo "$name will be downloaded"
    end
  end 
end 

function show_existing
  for name in $downloadList 
    if test -d $name 
      echo "$name exists"
    end 
  end 
end 


function download_fonts 
  for name in $downloadList
    set font_url (echo $download_url|sed s/{{NAME}}/$name/gi)
    
    if not test -d $name 
      echo "downloading font: "$name
      wget --quiet $font_url 
      mkdir $name 
      mv "$name".zip $name/ 
      cd $name 
      unzip $name.zip
      rm $name.zip 
      cd ..
    end 
  end 
end 

for a in $argv 
  echo "arg: $a"
end


if test "$argv[1]" = "download"
  echo "downloading"
  download_fonts
end
