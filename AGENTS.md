# Repository Agent Rules

- For new automations and scripts: use Python by default.
- Use shell scripts only when the task cannot be handled adequately in Python.
- For `bin/vscode_profile.py`: do not add CLI arguments. Execution must be `./bin/vscode_profile.py`, and output must contain only the active VS Code profile name.
