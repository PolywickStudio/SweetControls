# SweetControls

SweetControls is a collection of native Delphi VCL components for Windows applications, including edits, buttons, panels, lists, tree controls, database controls, and design-time editors.

This copy comes from [ocdogan/SweetControls](https://github.com/ocdogan/SweetControls), obtained approximately ten years ago according to the current maintainer. The original library was developed by CodeAccelerate. Its bundled documentation identifies version 4.200, dated February 23, 2007.

This port was done by Polywick Studio.

## Delphi compatibility

The original distribution includes packages for Delphi 4, 5, 6, 7, 2005, and 2006. This copy also contains `SweetControls131.dproj` and `SweetControls131.dpk` for ongoing work with newer Delphi releases.

Recent changes include:

- Compiler version and range defines in `SweetControls.inc` through Delphi 13 Florence, while keeping the existing legacy symbols.
- `OEMConvert` in the custom edit controls is compiled only before Delphi 2009, using `SC_DELPHI2009_EARLY`. Related derived controls use the same condition.
- Tree-list searches and sorting use `SC_DELPHIXE2_UP` to select the newer list representation. XE and earlier retain the original pointer-based implementation.

Version symbols distinguish an exact release from a range:

| Example | Meaning |
| --- | --- |
| `SC_DELPHI13_0` | Delphi 13 Florence |
| `SC_DELPHI13_0_UP` | Delphi 13 Florence or later |
| `SC_DELPHI2009_EARLY` | Earlier than Delphi 2009 |
| `SC_DELPHI2009_AND_EARLY` | Delphi 2009 or earlier |
| `SC_DELPHIXE2_UP` | Delphi XE2 or later |

The legacy `SC_DELPHI10` symbol means Delphi 2006; `SC_DELPHI10_0` means Delphi 10 Seattle. Minor updates within a release share its compiler version symbols.

## Installation

1. Open the package matching your Delphi version. For example, use `SweetControls7.dpk` for Delphi 7 or `SweetControls2006.dpk` for Delphi 2006. The newer project is `SweetControls131.dproj`.
2. Add the source directory and the appropriate compiled-unit output directory to the IDE library path or your application's search path. Keep output directories separate for each compiler and target platform.
3. Build the package from source with your installed compiler. Existing DCU and BPL files may belong to a different compiler version.
4. Install the package in the IDE to register its components and editors. The supplied packages include a dependency on `designide`, so install them as design-time packages.
5. Use the examples in `Demos` to explore the controls. Applications using runtime packages must be able to locate their matching BPL files.

For the newer project, check the internal package name and output settings before installation: `SweetControls131.dpk` currently declares the package as `SweetControls2006`.

## Validation and current limits

- The updated include file compiled with Delphi XE and Delphi 13 Florence, including Florence Win32 and Win64 checks. A simulated compiler-version matrix covered 30 cases.
- `SCEdits.pas` compiled with Florence Win32 after the OEM conversion guards were added.
- `SCTreeList.pas` compiled with both XE and Florence Win32 after the conditional list-access changes.
- Full-package compatibility is still being updated. Broader compilation checks encountered legacy `DateSeparator` and `TimeSeparator` references in `SCMaskEdit.pas`.

These checks cover the listed units and include file; they do not establish that every package, control, or demo builds on every listed Delphi version.

## Project files

- `SweetControls.inc`: shared compiler and compatibility defines.
- `SC*.pas`, `SC*.dfm`, and resource files: controls, editors, and supporting code.
- `SweetControls*.dpk` and `SweetControls131.dproj`: package sources and project settings.
- `Demos`: example applications.
- [README.TXT](README.TXT): original documentation and licensing terms.
- [README WhatsNew.txt](README%20WhatsNew.txt): original release history.

## License and attribution

The [MIT license in LICENSE](LICENSE) applies only to new documentation and original local modifications made for this maintained copy, to the extent their authors hold the relevant rights.

The inherited SweetControls library retains the CodeAccelerate copyright notices and the terms in [README.TXT](README.TXT), also present in the [upstream README](https://github.com/ocdogan/SweetControls/blob/master/README.TXT). Those terms prohibit redistribution of the library's source or compiled form. The MIT license for local contributions does not replace those terms or grant permission to redistribute the inherited library.

Applying MIT to the entire library requires authorization from the original rights holder. Preserve the existing copyright notices when editing the source.
