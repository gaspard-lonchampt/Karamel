#!/bin/bash
# WhisperNow Toggle - Dictée vocale avec CUDA
# Premier appel : démarre l'enregistrement
# Second appel : arrête, transcrit, copie dans le clipboard

cd ~/.local/share/whispernow

# Configurer LD_LIBRARY_PATH pour CUDA
VENV_PATH=$(pipenv --venv 2>/dev/null)
export LD_LIBRARY_PATH="$VENV_PATH/lib/python3.12/site-packages/nvidia/cublas/lib:$VENV_PATH/lib/python3.12/site-packages/nvidia/cudnn/lib:$LD_LIBRARY_PATH"

pipenv run python whispernow-toggle.py
