ADVANCED TILE MAPS AND SCROLLING WORLDS

The Word file is the editable chapter for insertion into a larger tutorial.
It has no cover, contents, chapter number, dated header or page-number footer.
The matching PDF is a reading copy. Code panels are editable white text in
rounded black shapes, with a Notes margin. The three .asm files are the
complete standalone examples; the chapter includes the wide-world listing.

Builds require ACME alone. Graphics, attributes and maps are inside each .asm.
Open C64_Tile_Maps.code-workspace in VS Code, open an .asm and press
Ctrl+Shift+B (Cmd+Shift+B on macOS) to assemble and launch x64sc.
If executables are not on PATH, edit command paths in .vscode/tasks.json;
Windows uses windows.command overrides. No scripting or extensions required.
Keep the included build folder. Close VICE before starting another task.

For integration, use the renderer contract in the chapter and relocate code,
assets and zero page to your host memory plan. The examples take over the
machine; they are reference programs, not directly callable whole-game modules.

All three examples compiled successfully with ACME 0.96.4. The PRGs match the
previous reference programs byte for byte. VICE execution, VS Code UI launch,
PAL VICE display checks passed. NTSC timing and physical C64 checks require separate validation. See the root VICE_VALIDATION_SUMMARY.txt.
