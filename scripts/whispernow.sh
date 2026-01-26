#!/bin/bash
# WhisperNow - Dictée vocale locale avec CUDA
# Usage: appuyer sur Entrée pour arrêter l'enregistrement, le texte est copié dans le presse-papiers

# Configurer le LD_LIBRARY_PATH pour CUDA (cuBLAS et cuDNN)
export LD_LIBRARY_PATH=$(python3 -c 'import os; import nvidia.cublas.lib; import nvidia.cudnn.lib; print(os.path.dirname(nvidia.cublas.lib.__file__) + ":" + os.path.dirname(nvidia.cudnn.lib.__file__))' 2>/dev/null):$LD_LIBRARY_PATH

cd ~/Apps/WhisperNow
OMP_NUM_THREADS=2 ~/.local/bin/uv run transcribe.py
