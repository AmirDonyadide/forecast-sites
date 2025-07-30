REM © 2024 Fraunhofer-Gesellschaft e.V., München
REM
REM SPDX-License-Identifier: AGPL-3.0-or-later

REM This batch file can be used to run some of the pipeline commands locally.
REM Run it, for example, with the command `./pipeline.bat` from within the PyCharm terminal.
REM Also see GitHub workflows for CI automation of the same steps.

REM -----------------------------
REM STEP 1: Install Python dependencies
REM Uses pip to install all required packages defined in pyproject.toml under [dev]
REM Filters out lines with "Requirement already satisfied" for cleaner output
echo "Installing python requirements..."
pip install .[dev] | findstr /V /C:"Requirement already satisfied"

REM -----------------------------
REM STEP 2: Format code
REM Use isort to sort imports and black to auto-format code with line length = 120
REM -S means don't normalize string quotes
echo "Formatting code..."
isort .                      REM Sort imports across all project files
black src -S -l 120          REM Format code in the src directory
black test -S -l 120         REM Format code in the test directory

REM -----------------------------
REM STEP 3: Code quality checks (not yet implemented)
REM This is a placeholder for future tools (e.g., ruff, pylint)
echo "Checking code quality with... TODO..."

REM -----------------------------
REM STEP 4: Run tests and measure test coverage
REM Uses pytest with coverage plugin to report how much of the code is tested
echo "Running unit tests and determining test coverage..."
pytest --cov

REM -----------------------------
REM STEP 5: Add REUSE SPDX license annotations
REM Ensures all files have proper licensing information according to REUSE specification
REM --recursive applies to all files under src, test, and THIRDPARTY.md
echo "Creating reuse annotations"
python -m reuse annotate --copyright="Fraunhofer-Gesellschaft e.V., München" ^
    --copyright-style=symbol ^
    --merge-copyrights ^
    --license=AGPL-3.0-or-later ^
    --skip-unrecognised ^
    --recursive src test THIRDPARTY.md

REM -----------------------------
REM STEP 6: Check REUSE license compliance
REM Verifies that all files conform to the REUSE license format and headers
echo "Checking REUSE Compliance"
python -m reuse lint

REM -----------------------------
REM STEP 7: Final message and optional pause
REM If the argument is `skip_pause`, skip waiting; otherwise pause to keep window open
if (%1==skip_pause) (
 echo "Finished commands."
) else (
 echo "Finished commands."
 pause
)