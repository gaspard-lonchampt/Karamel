function workspace --description "Lance un environnement de travail par projet"
    # Parser les arguments
    argparse 'm/mobilic' 'l/list' 'h/help' -- $argv
    or return 1

    # Aide
    if set -q _flag_help
        echo "Usage: workspace [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  -m, --mobilic    Lance l'environnement Mobilic"
        echo "  -l, --list       Liste les workspaces disponibles"
        echo "  -h, --help       Affiche cette aide"
        return 0
    end

    # Liste des workspaces
    if set -q _flag_list
        echo "Workspaces disponibles:"
        for f in ~/.config/workspace/*.fish
            set -l name (basename $f .fish)
            echo "  --$name"
        end
        return 0
    end

    # Mobilic
    if set -q _flag_mobilic
        source ~/.config/workspace/mobilic.fish
        _workspace_mobilic
        return $status
    end

    # Aucun argument
    echo "Erreur: Spécifie un workspace (ex: workspace --mobilic)"
    echo "Utilise 'workspace --list' pour voir les options"
    return 1
end
