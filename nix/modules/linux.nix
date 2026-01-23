
  { sysPkgs, dms, quickshell }:

  let 
    linuxPkgs = with sysPkgs; [
        aardvark-dns
        apostrophe
        autotools-language-server
        checksec
        chromium
        gdb
        ghdl
        ngspice
        octaveFull
        qucs-s
        remmina
        shfmt
        signal-desktop
        slirp4netns
        sysstat

        popcorntime
        transmission_4-gtk
        vagrant

        virter
        virt-manager

        ## gnome extensions 
        gnomeExtensions.caffeine
        gnomeExtensions.extension-list
        gnomeExtensions.just-perfection
        gnomeExtensions.sound-output-device-chooser
        gnomeExtensions.todotxt
        gnomeExtensions.user-themes
        gnomeExtensions.vitals

        ## gaming 
        lutris
        pcsx2
        wine

        ## wm  
        # NOTE: requires the following installed via apt: sway, swaybg
        # swayidle
        # swayimg
        # swaylock
        # waybar
        # wofi
        # mako 
        # nwg-launchers
        # nwg-look
        # blueman
        dracula-icon-theme
        # ags.packages.${system}.agsFull

        ## trying out hyprland
        # hyprland
        # hyprlauncher
        # hyprpaper
        # hypridle
        # hyprpanel
        # flameshot
        # grim
        # hyprshot 
        # hyprpicker
        # xdg-desktop-portal
        # xdg-desktop-portal-hyprland

        ## niri wm 
        niri
        xwayland
        xwayland-run
        xwayland-satellite

        ## anime 
        seanime 
    ];

  
  otherPkgs  = [
    dms.packages.x86_64-linux.dms-shell
    quickshell.packages.x86_64-linux.quickshell
  ];

  in
    linuxPkgs ++ otherPkgs;
