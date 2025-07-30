#!/bin/bash

# © 2024 Fraunhofer-Gesellschaft e.V., München
#
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# This script automates common pipeline tasks for the forecast-sites project.
# Usage:
#   chmod +x pipeline.sh       # Make executable (once)
#   ./pipeline.sh              # Run it from the project root
#   ./pipeline.sh skip_pause   # Run without pause at end

echo "🔧 Installing Python requirements..."
# Installs all dependencies from pyproject.toml under [dev]
pip install '.[dev]' | grep -v "Requirement already satisfied"

echo "🎨 Formatting code with isort and black..."
# Sort imports
isort .
# Format source code (line length 120, don't normalize string quotes)
black src -S -l 120
black test -S -l 120

echo "🔍 Checking code quality... TODO"
# Placeholder for future linter like `ruff check .`

echo "🧪 Running unit tests and checking coverage..."
# Run tests and collect coverage
pytest --cov

echo "🆔 Creating REUSE license annotations..."
# Annotate all files recursively to comply with REUSE license spec
python -m reuse annotate \
  --copyright="Fraunhofer-Gesellschaft e.V., München" \
  --copyright-style=symbol \
  --merge-copyrights \
  --license=AGPL-3.0-or-later \
  --skip-unrecognised \
  --recursive src test THIRDPARTY.md

echo "📋 Checking REUSE compliance..."
# Check if all files comply with REUSE guidelines
python -m reuse lint

# Optional pause if no argument is passed
if [ "$1" == "skip_pause" ]; then
  echo "✅ Finished commands."
else
  echo "✅ Finished commands. Press any key to exit..."
  read -n 1 -s
fi