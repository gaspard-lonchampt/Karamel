function kbinds --description "Show keybinds in terminal or Walker"
    if test "$argv[1]" = "-w"
        ~/Karamel/scripts/karamel-keybinds.sh walker
    else
        ~/Karamel/scripts/karamel-keybinds.sh show
    end
end
