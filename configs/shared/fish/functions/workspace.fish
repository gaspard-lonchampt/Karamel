function workspace --description "Launch a project workspace"
    # Help
    if test "$argv[1]" = "-h" -o "$argv[1]" = "--help"
        echo "Usage: workspace <name> | workspace close"
        echo ""
        echo "Available workspaces:"
        for f in ~/.config/workspace/*.fish
            echo "  "(basename $f .fish)
        end
        return 0
    end

    # Close current workspace
    if test "$argv[1]" = "close"
        if not set -q WORKSPACE_CURRENT
            echo "Error: no active workspace"
            return 1
        end

        set -l config_file ~/.config/workspace/$WORKSPACE_CURRENT.fish
        source $config_file

        if functions -q _workspace_{$WORKSPACE_CURRENT}_close
            _workspace_{$WORKSPACE_CURRENT}_close
            set -e -U WORKSPACE_CURRENT
        else
            echo "Error: no close function for '$WORKSPACE_CURRENT'"
            return 1
        end
        return 0
    end

    # No argument
    if test (count $argv) -eq 0
        echo "Usage: workspace <name> | workspace close"
        echo "Available: "(string join ", " (basename -s .fish ~/.config/workspace/*.fish))
        return 1
    end

    set -l name $argv[1]
    set -l config_file ~/.config/workspace/$name.fish

    # Check if config exists
    if not test -f $config_file
        echo "Error: workspace '$name' not found"
        echo "Available: "(string join ", " (basename -s .fish ~/.config/workspace/*.fish))
        return 1
    end

    # Load and run
    source $config_file
    _workspace_$name

    # Save current workspace (universal variable, shared across all shells)
    set -U WORKSPACE_CURRENT $name
end
