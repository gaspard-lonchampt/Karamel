#!/bin/bash
# Walker keybindings menu - Simple version
# Uses pre-generated keybindings file for speed

KEYBINDS_FILE="$HOME/.config/karamel/keybinds.txt"

# Generate keybinds file if missing
generate_keybinds() {
    cat > "$KEYBINDS_FILE" << 'EOF'
──────────── APPLICATIONS ────────────
  Super + T → Terminal (kitty)
  Super + Return → Terminal (kitty)
  Super + Ctrl + Return → Terminal flottant
  Super + F → Gestionnaire de fichiers (Nemo)
  Super + Alt + F → Explorateur terminal (Yazi)
  Super + B → Navigateur (Zen Browser)
  Super + Shift + Z → Éditeur de code (Zed)
  Super + Ctrl + C → OpenCode (IA dans terminal)
  Super + D → Discord (Vesktop)
  Super + G → Telegram
  Super + S → Steam
  Super + Shift + O → OBS Studio
  Super + Ctrl + M → Moonlight (streaming)
──────────── AUDIO & MEDIA ────────────
  Fn+F1 → Mute/Unmute
  Fn+F2 → Volume -
  Fn+F3 → Volume +
  Fn+F4 → Piste précédente
  Fn+F5 → Lecture/Pause
  Fn+F6 → Piste suivante
──────────── LUMINOSITE ────────────
  Fn+F7 → Luminosité -
  Fn+F8 → Luminosité +
  Fn+F9 → Vue d'ensemble workspaces
──────────── CAPTURES D'ECRAN ────────────
  Print → Capture zone (avec annotation)
  Ctrl + Print → Capture écran complet
  Super + Shift + S → Capture vers presse-papier
──────────── GESTION FENETRES ────────────
  Super + Q → Fermer la fenêtre
  Super + Shift + F → Plein écran
  Super + W → Basculer flottant
  Super + Shift + W → Grouper fenêtres
──────────── NAVIGATION FENETRES ────────────
  Super + ← → Focus gauche
  Super + ↓ → Focus bas
  Super + ↑ → Focus haut
  Super + → → Focus droite
  Super + H/J/K/L → Navigation vim
──────────── DEPLACEMENT FENETRES ────────────
  Super + Shift + ← → Déplacer gauche
  Super + Shift + ↓ → Déplacer bas
  Super + Shift + ↑ → Déplacer haut
  Super + Shift + → → Déplacer droite
──────────── WORKSPACES ────────────
  Super + 1-9 → Aller au workspace 1-9
  Super + Shift + 1-9 → Envoyer vers workspace 1-9
  Super + U/I → Workspace suivant/précédent
  Super + Ctrl + U/I → Déplacer vers workspace suivant/précédent
──────────── REDIMENSIONNEMENT ────────────
  Super + ( → Absorber/expulser fenêtre gauche
  Super + ) → Absorber/expulser fenêtre droite
  Super + - → Réduire largeur 10%
  Super + = → Agrandir largeur 10%
  Super + R → Cycle taille colonnes
──────────── POWER MODES ────────────
  Super + Ctrl + B → Cycle: chill (60%) → notso (80%) → furious (100%)
──────────── SYSTEME ────────────
  Ctrl + Alt + L → Verrouiller l'écran
  Super + Shift + E → Quitter compositeur
  Super + Shift + P → Éteindre les écrans
  Super + : → Menu des raccourcis (Walker)
──────────── DMS SHELL ────────────
  Super + Space → Lanceur DMS (Spotlight)
  Super + V → Presse-papier DMS
  Super + M → Gestionnaire de processus
  Super + , → Paramètres DMS
  Super + N → Centre de notifications
  Super + Shift + N → Bloc-notes DMS
  Super + Y → Sélecteur de fond d'écran
  Super + Tab → Vue d'ensemble DMS
  Super + L → Verrouiller (DMS lock)
  Super + Shift + / → Aide-mémoire DMS
EOF
}

# Generate if file doesn't exist
[[ ! -f "$KEYBINDS_FILE" ]] && generate_keybinds

# Display in Walker
cat "$KEYBINDS_FILE" | walker --dmenu --placeholder "Search keybindings..."
