# Repository Agent Rules

- Completely ignore the `.v1/` folder in any standard task.
- Do not read, search, index, analyze, format, lint, repair, or edit files inside `.v1/`.
- Do not use `.v1/` content as a source for answers, refactors, or documentation.
- Access `.v1/` only when the user explicitly and directly requests it.
- When running automations, limit scope to paths outside `.v1/`.
- For new automations and scripts: use Python by default.
- Use shell scripts only when the task cannot be handled adequately in Python.
- For `bin/vscode_profile.py`: do not add CLI arguments. Execution must be `./bin/vscode_profile.py`, and output must contain only the active VS Code profile name.
- All documentation, code, commit messages, and stdout/stderr output must be in American English (en-US).

## Rules for Git Commit Requests

When the user asks only to "do git commit", always follow these rules:

- Commit only what is already staged, without adding or removing anything from the stage.
- Never alter the contents of files already in the stage and re-add them.
- Never touch changes outside the stage (working tree/HEAD outside the stage).
- Always write a commit message describing only the changes currently in the stage.
- Always write commit messages in American English (en-US).
