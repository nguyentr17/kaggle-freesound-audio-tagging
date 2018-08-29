#!/bin/bash
#set -e

#PIP=.env/bin/pip
#PYTHON=.env/bin/python

# Create virtual environment
virtualenv .env -p python3

# Install dependencies
pip install -r requirements.txt

# Extract files
# unzip -o -d data/ data/audio_train.zip
# unzip -o -d data/ data/audio_test.zip

# Trim leading and trailing silence
python 01-save-trimmed-wavs.py 12

# Compute Log Mel-Spectrograms
python 02-compute-mel-specs.py 12

# Compute summary metrics of various spectral and time based features
python 03-compute-summary-feats.py

# Compute PCA features over the summary metrics from previous script
python 04-pca.py

# Divide the training data into 10 (stratified by label) folds
python 05-ten-folds.py

# Train only the part of the model, that depends on the Log Mel-Spec features (10 folds)
for (( FOLD=0; FOLD<=9; FOLD+=1 )); do
  python 06-train-model-only-mel.py "$FOLD"
done

# Train the full model, after loading weights from the mel-only model from previous script (10 folds)
for (( FOLD=0; FOLD<=9; FOLD+=1 )); do
  python 07-train-model-mel-and-pca.py "$FOLD"
done

# Generate predictions
python 08-generate-predictions.py
