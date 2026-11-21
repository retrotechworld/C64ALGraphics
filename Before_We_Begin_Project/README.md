# C64 ACME project template

1. Install VS Code, ACME and VICE using the accompanying guide.
2. Extract this folder to a writable location. Open this folder itself in VS Code.
3. Keep the build directory: ACME does not create missing parent directories.
4. Edit .vscode/settings.json: set c64.acmePath and c64.vicePath to your executable paths, or use names if they are on PATH.
5. Save all changes. Use Terminal > Run Build Task (Ctrl+Shift+B or Cmd+Shift+B).
6. Expect HELLO FROM ACME! in white, on blue, with a black border.
7. Close VICE before running the task again.

C64: Build assembles only. C64: Build and Run assembles and then starts VICE only after success. This is a visual smoke test, not an automated assertion suite. No extensions or Python installation are required. F5 debugging is not configured.

Source includes are relative to the project root. Generated PRG, report and VICE label files go to build/. The source is intentionally small; assets/ is reserved for later lessons. Custom c64 settings may appear as unknown settings without an extension; they are variables consumed by the tasks.
