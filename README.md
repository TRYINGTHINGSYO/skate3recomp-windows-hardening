# Skate 3 Recomp: Windows hardening and keyboard fallback

Reviewable source patches for Skate 3 Recomp v2.0.2. This package removes
executable icon self-modification and the hidden PowerShell cleanup process.
It also records the dependency workaround used to build this revision and an
opt-in workaround for an invisible system keyboard dialog during first-run setup.

**This is not a confirmed fix for Trojan:Win32/Suschil!rfn.** The cause of the
original Defender detection was not established. The independently built files
were scanned without a reported detection, and a user confirmed gameplay on
Windows after the keyboard workaround. Neither result guarantees absence of malware.

## What is included

- `patches/01-icon-hardening.patch`: game source; removes on-disk executable
  rewriting and hidden cleanup while retaining the normal window/taskbar icon.
- `patches/02-imgui-font-compat.patch`: runtime source; removes two references
  to the unavailable custom ImGui `RasterizerGamma` field.
- `patches/03-headless-keyboard-text.patch`: runtime source; adds an optional,
  bounded ASCII alphanumeric response for headless keyboard prompts. Default
  empty value preserves existing behavior. This does not repair popup rendering.
- `docs/BUILD.md`: pinned revisions, Windows build procedure, and TU3 hashes.
- `docs/TESTING.md`: observed results, binary hashes, and limitations.
- `docs/UPSTREAM-SUBMISSION.md`: separate proposed game and runtime submissions.
- `scripts/Launch-Skate3.cmd`: standalone launch settings used for the working
  fallback configuration; no Hyper-V, remoting, elevation, or VM dependency.

No retail game assets, title-update payloads, generated game code, executables,
DLLs, saves, credentials, or raw user logs are included. These patches are
intended for source review and upstream submission, not a ready-to-play release.

## Independent Windows use

The compiled application is a Windows executable with a companion runtime DLL.
A VM was used as a build/test environment; it is not needed to run the game or
to build the patched source on a Windows machine with the documented toolchain.
Keep the executable and matching runtime DLL together. Supply your own legally
obtained game files and the verified TU3 patches. See `docs/BUILD.md`.

The launcher accepts a profile directory as its first argument. It uses a
`profile` directory beside the executable by default. To keep an existing save,
pass its current directory instead of starting a new profile.

## Attribution

Original game project: https://github.com/mchughalex/skate3recomp

Runtime: https://github.com/mchughalex/rexglue-skate3

ImGui workaround discussion: https://github.com/mchughalex/skate3recomp/issues/189

Related first-run reports: https://github.com/mchughalex/skate3recomp/issues/184

Upstream copyrights and license terms remain applicable. This package does not
relicense upstream source. The runtime's BSD license is retained in
`docs/REXGLUE-LICENSE.txt`. No affiliation or upstream endorsement is claimed.
