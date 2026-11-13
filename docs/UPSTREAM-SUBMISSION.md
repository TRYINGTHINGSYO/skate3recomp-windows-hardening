# Proposed submissions

Submit the game hardening separately from build compatibility and keyboard behavior
so reviewers can accept the narrow security change without accepting unrelated work.

## Game repository PR

Title: Windows: remove icon self-rewriting and hidden cleanup process

The Windows icon setup rewrites executable resources and launches a hidden
PowerShell cleanup process. This patch removes those paths while retaining the
normal in-process window/taskbar icon. The executable is no longer rewritten
by this icon code.

Validation: independently compiled on Windows using Clang 21.1.8. The final
local build with separately documented runtime changes passed Defender scans,
and the user confirmed gameplay using the fallback configuration. The original
Trojan:Win32/Suschil!rfn detection has not been attributed to a specific behavior;
this PR does not claim to resolve that detection or certify the binary.

Apply only `patches/01-icon-hardening.patch` for this submission. No replacement
runtime submodule hash is part of the game hardening patch.

## Runtime repository changes

1. Public ImGui compatibility: pin workaround plus removal of the custom
   RasterizerGamma assignments. The missing pinned commit is documented in
   game issue #189. Plain upstream font coverage may change text appearance.
2. Optional headless keyboard response: allow an explicit bounded alphanumeric
   response while keeping the existing behavior by default. This gets a tested
   user past an invisible company-name keyboard prompt; it does not fix ImGui.

Submit these independently in the runtime repository if desired. Include the
exact source patches, BUILD.md and TESTING.md, rather than the private logs or
game files. Do not describe this as an upstream-approved or guaranteed Trojan fix.

## Upload layout

This folder can be uploaded as a small patch repository as-is. For a direct PR,
apply the relevant patches to forks of the repositories above on new branches,
commit the actual source changes, and use the corresponding proposed description.
The two repositories require separate PRs; a patch-kit repository alone is not
a PR against the game's source. Publishing this patch-kit repository does not create upstream PRs.
