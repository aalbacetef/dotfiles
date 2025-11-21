#!/usr/bin/env bash

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/sway/config"

[ ! -f "$CONFIG" ] && {
    notify-send "" "Sway config not found"
    exit 1
}

grep '^\s*bindsym' "$CONFIG" 2>/dev/null |
    sed -E 's/^\s*bindsym\s+//; s/\s+$//; s/--no-startup-id//g; s/\s\s+/ /g; s/\s*#.*/  /' |
    # Replace your mod variable (supports $mod, $mainMod, etc.)
    sed -E 's/^\$mod([+ ])/Super\1/; s/^\$mainMod([+ ])/Super\1/' |
    sed -E 's/^Super\+Shift([+ ])/Super + Shift\1/; 
            s/^Super\+Ctrl([+ ])/Super + Ctrl\1/; 
            s/^Super\+Alt([+ ])/Super + Alt\1/' |
    sed -E 's/\+/ + /g' |
    # ──────────── ONLY ICONS THAT 100% EXIST IN CaskaydiaCove NF ────────────
    sed -E 's/ exec / run  /;           # terminal + arrow
            s/ mode /  󰌌 /;           # keyboard
            s/ workspace( |$)/ workspace 󰭹 /g;   
            s/ move container to workspace / move to workspace 󰉋  /;
            s/ fullscreen( toggle)?\>/ fullscreen 󰊓 /;
            s/ layout /  󰝘 /;
            s/ reload/  󰑓 /;
            s/ kill|close/  󰅖 /;
            s/ exit/  󰗼 /;
            s/ focus /  󰯐 /;
            s/ split /  󰤼 /;
            s/ resize /  󰩨 /;' |
    sort -k2 |
    column -t -s $'\t' |
    awk '{
        if ($0 ~ /Super \+ Shift/) print "<span foreground=\"#ff79c6\" weight=\"bold\">"$0"</span>";
        else if ($0 ~ /Super \+ Ctrl/) print "<span foreground=\"#8be9fd\">"$0"</span>";
        else if ($0 ~ /Super \+ Alt/) print "<span foreground=\"#ffb86c\">"$0"</span>";
        else print "<span foreground=\"#f8f8f2\">"$0"</span>";
    }' |
    wofi --dmenu \
        --width=1150 \
        --lines=26 \
        --prompt="󰌌  Sway Cheatsheet" \
        --allow-markup \
        --insensitive \
        --style=~/.config/waybar/keybinds.css \
        --cache-file=/dev/null
