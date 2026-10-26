# Scripts

Windows gaming and desktop automation: hotkeys that move, resize, and launch windows, plus game macros.

## Window placement

**Window placement**:
Putting a window at a chosen position and size on its own monitor, and later returning it to where it was.
_Avoid_: window management, window manager

**Fake fullscreen**:
A window stripped of its title bar and borders and stretched over the whole of its monitor, taskbar included.
_Avoid_: borderless, maximize, true fullscreen

**Snap**:
Placing a window over the left or right part of its monitor's work area, leaving the taskbar visible.
_Avoid_: tile, dock, move left/right

**Remembered geometry**:
A window's style, position, and size from before its first placement, kept so the window can be restored to it.
_Avoid_: saved position, previous size

**Restore**:
Returning a placed window to its remembered geometry and forgetting that geometry.
_Avoid_: unsnap, exit fullscreen, reset
