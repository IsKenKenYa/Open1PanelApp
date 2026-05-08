# Windows Native UI — Interaction Capabilities

> Last updated: Day 16 milestone

## Overview

This document catalogs all user interaction capabilities implemented in the Windows native (WinUI 3) track of the 1Panel client application.

---

## Shared Components

| Component | File | Description |
|-----------|------|-------------|
| ConfirmDialog | `ConfirmDialog.cs` | Reusable `ContentDialog` with customizable title, message, primary/secondary buttons, and `IsDestructive` flag. Returns `true` on confirm, `false` on cancel. |
| ErrorToast | `ErrorToast.cs` | Auto-dismissing `InfoBar`-based toast for error feedback. Shows for 5 seconds with close button. |
| ModulePageBase | `ModulePageBase.cs` | Base page providing Loading / Content / Empty / Error states with refresh/retry support. |

---

## Servers Module

| Interaction | Type | Description |
|-------------|------|-------------|
| Server list display | View | ListView showing server name, URL, status indicator (green/gray), CPU/Memory metrics, and "Current" badge |
| Server selection | Action | Single-click on a server item triggers the switch flow |
| Switch server confirmation | Dialog | `ConfirmDialog` with "Switch Server" title, showing server name and URL. Primary: "Switch", Secondary: "Cancel" |
| Switch server execution | Action | Calls `WindowsBridge.SwitchServerAsync(id)` on confirm |
| Switch failure feedback | Toast | `ErrorToast` displayed when `SwitchServerAsync` returns `false` |
| Refresh server list | Action | Refresh button reloads server data via `WindowsBridge.GetServersAsync()` |

---

## Files Module

| Interaction | Type | Description |
|-------------|------|-------------|
| File/directory listing | View | ListView with icon (folder/file), name, size, and modification date columns |
| Directory navigation (double-click) | Action | Double-click on a directory item navigates into it |
| Breadcrumb bar | Navigation | Horizontal bar showing current path as clickable segments (`/ > seg1 > seg2 > current`) |
| Breadcrumb segment click | Navigation | Click any ancestor segment to navigate directly to that path |
| Back button | Navigation | Up-arrow button to navigate to the parent directory; disabled at root (`/`) |
| Root segment click | Navigation | Click `/` in breadcrumb to return to root directory |
| Refresh file list | Action | Refresh button reloads current directory via `WindowsBridge.GetFilesAsync(path)` |

---

## Settings Module

| Interaction | Type | Description |
|-------------|------|-------------|
| Settings display | View | Categorized settings list (Appearance, About, General) with labels and values |
| Boolean setting toggle | Action | `ToggleSwitch` for boolean settings; toggling calls `WindowsBridge.UpdateSettingAsync(key, value)` |
| Toggle failure feedback | Toast | `ErrorToast` displayed when `UpdateSettingAsync` returns `false`; toggle reverts to previous state |
| Non-boolean setting display | View | Text display for string/number/object/array settings |
| Refresh settings | Action | Refresh button reloads settings via `WindowsBridge.GetSettingsSummaryAsync()` |

---

## Bridge Methods (WindowsBridge)

| Method | Direction | Description |
|--------|-----------|-------------|
| `GetServersAsync()` | Dart → Native | Retrieves server list with retry support |
| `GetCurrentServerAsync()` | Dart → Native | Retrieves current server info with retry support |
| `SwitchServerAsync(id)` | Native → Dart | Requests server switch; returns success/failure |
| `GetFilesAsync(path)` | Dart → Native | Retrieves file listing for given path with retry support |
| `GetSettingsSummaryAsync()` | Dart → Native | Retrieves settings key-value map with retry support |
| `UpdateSettingAsync(key, value)` | Native → Dart | Updates a single setting; returns success/failure |

---

## Page State Management

All module pages inherit from `ModulePageBase` and support four states:

| State | Visual | User Action |
|-------|--------|-------------|
| Loading | ProgressRing (centered, spinning) | None — wait for data |
| Content | Module-specific content | Module-specific interactions |
| Empty | Icon + "No data available" + Refresh button | Click Refresh |
| Error | Icon + "Failed to load data" + Retry button | Click Retry |
