# Windows source build, without Hyper-V

This procedure does not use a VM, PowerShell Direct, host drive mounts, or the
private build scripts. It is a reconstruction of the tested toolchain, not a
second clean-machine build validation. Preserve Defender and normal security settings.

## Pinned inputs

| Component | Revision |
| --- | --- |
| Game v2.0.2 | f6e0ae87fdfecbadb5c1e36c55d66a744187a3cd |
| ReXGlue runtime | 7eb0faf7787f5e01333c228b8e3f03c32f7295ea |
| Original unavailable ImGui pin | cdda62349d6068e906c2e0ee340d6ec31eedbb9c |
| Experimental public ImGui replacement | d94d0f3649c99d9a026518214f796aaacde707fe |
| FreeType VER-2-13-3 | 42608f77f20749dd6ddc9e0536788eaad70ea4b5 |

The experimental local commits recorded in dependency-revisions.json document
the test build. They are not published upstream revisions to fetch. Start with
the public base revisions above and apply the supplied patches instead.

Tested tools: Git 2.56.1, LLVM/Clang 21.1.8, CMake 3.31.8, Ninja 1.13.2,
Python 3.13.9, VS 2022 MSVC headers/libraries 14.44.35207, Windows SDK 10.0.26100.0.
Use official Git, LLVM, Kitware, Ninja, Python and Microsoft distributions.
CMake minimum is 3.25; the commands below use clang/clang++, not cl.exe or clang-cl.
Open a VS 2022 x64 Developer PowerShell so Windows SDK and linker paths are set.
Ensure the listed tools are on PATH. Do not disable antivirus to install or build.

## Clone and resolve the single unavailable dependency

Use a new working directory. Clone without recursive submodules initially:

```powershell
git clone https://github.com/mchughalex/skate3recomp.git skate3recomp
Set-Location skate3recomp
git checkout --detach f6e0ae87fdfecbadb5c1e36c55d66a744187a3cd
git switch -c local/windows-hardening
git submodule update --init third_party/rexglue-sdk
git -C third_party/rexglue-sdk checkout --detach 7eb0faf7787f5e01333c228b8e3f03c32f7295ea
git -C third_party/rexglue-sdk switch -c local/windows-compatibility
git -C third_party/rexglue-sdk submodule init
git -C third_party/rexglue-sdk config submodule.thirdparty/imgui.update none
git -C third_party/rexglue-sdk submodule update --init --recursive
git clone https://github.com/ocornut/imgui.git third_party/rexglue-sdk/thirdparty/imgui
git -C third_party/rexglue-sdk/thirdparty/imgui checkout --detach d94d0f3649c99d9a026518214f796aaacde707fe
git -C third_party/rexglue-sdk config --unset submodule.thirdparty/imgui.update
git submodule status --recursive
```

The temporary local skip setting avoids fetching the unavailable ImGui pin.
Only its gitlink should now have a `+` in recursive submodule status; other
submodules should match their pinned commits. If another dependency cannot be
retrieved, stop and document it rather than updating it silently. Do not run
another unqualified recursive update that resets ImGui to its unavailable pin.
For a real runtime PR, commit the replacement ImGui gitlink explicitly.

## Apply patches

Set `$kit` to the absolute directory of this patch package. From the game root:

```powershell
$kit = 'C:\path\to\skate3-github-ready'
git apply --check "$kit\patches\01-icon-hardening.patch"
git apply "$kit\patches\01-icon-hardening.patch"
git -C third_party/rexglue-sdk apply --check "$kit\patches\02-imgui-font-compat.patch"
git -C third_party/rexglue-sdk apply "$kit\patches\02-imgui-font-compat.patch"
git -C third_party/rexglue-sdk apply --check "$kit\patches\03-headless-keyboard-text.patch"
git -C third_party/rexglue-sdk apply "$kit\patches\03-headless-keyboard-text.patch"
git diff --check
git -C third_party/rexglue-sdk diff --check
```

## Supply game/update inputs and FreeType

Provide an extracted legally obtained game under `game`, including default.xex
and data/webkit/EAWebkit.xex. Work from a copy; do not alter original game files.
Supply the TU3 package via the project's documented legitimate acquisition
procedure (upstream README and cmake title-update extraction code). No game or
update payload is included here. Expected SHA-256 values from the test:

| File | SHA-256 |
| --- | --- |
| TU_12K2276_000000C000000.00000000000O3 | a3fcff1e0b6059d307e9877063e50a99aca8ac41c93ca054de653f7bf16bca0e |
| default.xexp | eb9ef9109dfa6d940df2e156e7eaeda4603d2b2319ca6451f324b1c27f2b1f4c |
| data/webkit/EAWebkit.xexp | 5d4a308d2a6c768fc27c8b62ccb6661171dc504f8c0011a3e116cf0074e09438 |

Verify with `Get-FileHash -LiteralPath <file> -Algorithm SHA256`. Stage the two
verified patch files at the matching paths beside the game files for runtime use.

```powershell
git clone https://github.com/freetype/freetype.git external/freetype
git -C external/freetype checkout --detach 42608f77f20749dd6ddc9e0536788eaad70ea4b5
```

## Build

Use the upstream CMake preset and a local FreeType source override. The package
path below must point to your verified TU3 container. All dependencies must have
been retrieved before disconnected configuration.

```powershell
$configure = @('--preset','relwithdebinfo',
  '-DCMAKE_C_COMPILER=clang','-DCMAKE_CXX_COMPILER=clang++',
  "-DSKATE3_GAME_DATA_ROOT=$PWD/game",
  "-DSKATE3_TITLE_UPDATE_PACKAGE=$PWD/TU_12K2276_000000C000000.00000000000O3",
  "-DFETCHCONTENT_SOURCE_DIR_FREETYPE=$PWD/external/freetype",
  '-DFETCHCONTENT_FULLY_DISCONNECTED=ON')
cmake @configure
cmake --build --preset relwithdebinfo --target rexglue --parallel 2
```

Check each command's exit code. Scan the newly built code-generation tool with
Defender before invoking it through generate-all. Then:

```powershell
cmake --build --preset relwithdebinfo --target generate-all --parallel 2
cmake @configure
cmake --build --preset relwithdebinfo --target skate3 --parallel 2
```

Record warnings and command exit codes. The tested build reported unresolved
code-generation branch warnings and a linker XInput imported-DllMain warning;
full-game correctness is not established. Output is under out/build/relwithdebinfo.
Keep skate3.exe and the matching rexruntimerd.dll together. Hash and scan both
before runtime testing. Investigate detections; do not add exclusions or restore
quarantined files to force execution.

For the tested fallback configuration, place Launch-Skate3.cmd beside the
binaries and the game folder. Pass an existing profile path as its first argument
to retain that save. The launcher does not connect to or require a VM.
