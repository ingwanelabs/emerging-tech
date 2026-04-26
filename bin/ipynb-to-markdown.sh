#!/bin/bash

# Venv must exist
if [[ ! -d venv ]]; then
  echo "$0 ERROR: Directory not found - venv"
  exit 1
fi


# Convert the notebooks
for nb in *.ipynb; do
  echo $nb
  ./venv/bin/jupyter nbconvert --to markdown "$nb"
done

# Copy the markdown to notebooks directory
mv 0*.md markdown

#EOF
