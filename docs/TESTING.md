# Verification record

Test date: November 13, 2026. Single user/machine report, not a broad compatibility test.

## Security observations

The original downloaded release triggered `Trojan:Win32/Suschil!rfn`. Its root
cause remains unknown; the original quarantined file was not restored.
The source hardening removes two identifiable behaviors: self-rewriting of
the executable's icon resources, and a hidden PowerShell cleanup process.
No causal relationship between these behaviors and the detection was proven.

The final keyboard-patched incremental build completed with compiler warnings
and no build error. Guest Defender scan completed with signature version
1.463.274.0; the host export scan also completed without a reported detection.
Before installation, host Defender version 1.463.277.0 had real-time protection
enabled and no recent detections were returned. No exclusions or protection
disabling were used. These versions are historical, not a claim of current coverage.

Exported binary hashes were checked against the build manifest, and installed
copies matched. Static PE section inspection found no sections marked both
executable and writable. PE import reports were generated. The binaries are
unsigned; imports or a clean scan do not constitute a complete security audit.

Earlier bounded runtime monitoring covered the previous build's startup only:
no observed child processes, sampled game-owned TCP connections, or changes to
selected persistence locations. That monitoring was not repeated as a complete
audit of the final keyboard-patched gameplay session.

## Final tested binary SHA-256

| File | SHA-256 |
| --- | --- |
| skate3.exe | e8c45cda92dd2b51c8ea4b5fce2ce55ce6e14a7c8569209669af6b9293786bb5 |
| rexruntimerd.dll | 37b097e949bef910e345edcc2bd2f28bbad373f706285732298ad65dd7afff3e |

These hashes identify the locally tested RelWithDebInfo artifacts. A fresh build
may differ due to build metadata and paths. No binary artifacts are in this package.

## Functional results

The user reported black screens after first-run settings and then specifically
after the company-name introduction. Renderer changes, a fresh local profile,
and disabling movie skipping did not independently solve it. Enabling built-in
headless prompts advanced to an invalid-character error, implicating keyboard
input as the immediate blocker. The optional explicit text `SkateTeam` then
allowed the user to report: "it finally plays".

Logs also reached gameplay presence context 0x8001 = 1. This supports progression
beyond startup, but does not establish full-game correctness or stability.

The working configuration uses Direct3D 12, disables the native rendering hook
layer and scene, disables emulated draw suppression, enables full resolve and
memory-export readback, caps at 60 FPS, and uses the headless keyboard override.
It can be slower than native rendering. The contribution remains a native
Windows program, while this configuration uses its emulated GPU fallback.

Headless mode affects all runtime system prompts, not only company naming.
The explicit text applies to each headless keyboard request during that session.
Custom name entry, native-renderer compatibility, and the underlying invisible
ImGui popup remain unresolved. No claim is made that every setting is necessary.
