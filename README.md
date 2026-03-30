<div align="center">

# 📋 Pasteboard for macOS

**A native, privacy-first clipboard manager for macOS power users.**

Built with SwiftUI and AppKit — lives in your menubar, stays out of your way.

[![macOS](https://img.shields.io/badge/macOS-13%2B-blue?logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift&logoColor=white)](https://swift.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-v1.0.0-purple)](https://github.com/yourusername/Pasteboard/releases/tag/v1.0.0)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

</div>

---

## 📸 Screenshots

> - <img width="546" height="577" alt="Screenshot 2026-03-30 at 9 00 57 PM" src="https://github.com/user-attachments/assets/bf10e0c1-7082-48e4-bf22-e67c7fc6b421" />

---

## ✨ Features

| Feature | Description |
|---|---|
| 🚀 **Auto-Paste** | Select any history item and it instantly pastes into your active app |
| 🔄 **Automatic Capture** | Every piece of copied text is silently saved to your local history |
| ⌨️ **Global Hotkey** | Press `⌘ Shift V` from any application to summon the history panel |
| 🔍 **Quick Search** | Real-time, case-insensitive search across your entire history |
| 🧩 **Native Experience** | Lives in the menubar — no Dock clutter, no distractions |
| 🛡️ **Privacy Focused** | Zero analytics, zero cloud sync. Your clipboard never leaves your Mac |

---

## 🚀 Installation

### Option 1: Install Script _(recommended)_

```bash
git clone https://github.com/yourusername/Pasteboard.git
cd Pasteboard
chmod +x *.sh
./install.sh
```

This builds a release binary and installs **Pasteboard.app** to `/Applications`.

### Option 2: Build via Xcode CLI

```bash
git clone https://github.com/yourusername/Pasteboard.git
cd Pasteboard
xcodebuild -project Pasteboard.xcodeproj \
           -scheme Pasteboard \
           -configuration Release build
```

### Option 3: Open in Xcode

1. Clone the repo
2. Open `Pasteboard.xcodeproj`
3. Press `⌘R` to build and run

---

## 🗑 Uninstall

```bash
cd Pasteboard
./uninstall.sh
```

Or simply drag `/Applications/Pasteboard.app` to the Trash.

---

## 🛠 Requirements

- **macOS 13 (Ventura)** or later
- **Xcode Command Line Tools** — install via `xcode-select --install`
- **Accessibility Permissions** — required for the global hotkey and auto-paste features

---

## ⚠️ Troubleshooting Permissions

If the hotkey or auto-paste features are not working after launch:

1. Open **System Settings** → **Privacy & Security** → **Accessibility**
2. **Important:** Select `Pasteboard` and click the **minus (−)** button to remove it
3. Relaunch the app and grant permission again when prompted

> This is a known macOS behavior — re-granting permission forces the system to re-register the accessibility entitlement correctly.

---

## 📁 Architecture

```
Pasteboard/
├── App/
│   ├── PasteboardApp.swift          # App entry point
│   └── AppDelegate.swift            # Menubar & hotkey management
├── Models/
│   └── ClipboardItem.swift          # Data model for history entries
├── Services/
│   └── ClipboardStore.swift         # Clipboard observer & persistence
├── Views/
│   ├── ClipboardHistoryView.swift   # Main history panel UI
│   └── ClipboardRowView.swift       # Individual history item UI
├── Utilities/
│   └── Color+Hex.swift              # SwiftUI styling extensions
└── Resources/
    ├── Info.plist                   # App metadata
    └── Pasteboard.entitlements      # App capabilities
```

### Key Design Decisions

- **Hybrid Architecture** — SwiftUI handles the UI layer; AppKit manages native menubar integration for a truly Mac-first feel.
- **Accessibility Integration** — Uses `CGEvent` simulation to deliver auto-paste without the user needing to switch focus.
- **Global Hotkeys** — Leverages the Carbon framework for low-latency global event monitoring (`⌘ Shift V`).
- **Persistence** — Clipboard history is stored locally using `UserDefaults` with `JSON` encoding — fast, simple, and private.

---

## 🗺 Roadmap

These are features planned or being considered for future releases. Community contributions are very welcome!

- [ ] **Pinned items** — Pin frequently used snippets to the top of your history
- [ ] **Rich content support** — Capture and preview images from the clipboard
- [ ] **Configurable history limit** — Let users set how many items to retain
- [ ] **Custom hotkey** — Allow users to rebind the global shortcut in Settings
- [ ] **iCloud Sync** _(opt-in)_ — Optionally sync clipboard history across devices
- [ ] **Exclusion list** — Ignore clipboard content from specified apps (e.g. password managers)
- [ ] **Multiple themes** — Light, dark, and system-matched appearance options
- [ ] **Export history** — Dump clipboard history to a plain text or JSON file

Have an idea? [Open a feature request →](https://github.com/yourusername/Pasteboard/issues/new?template=feature_request.md)

---

## 🤝 Contributing

Contributions are what make open source great. All kinds of contributions are welcome — bug fixes, new features, documentation improvements, and more.

### Getting Started

1. **Fork** the repository
2. **Clone** your fork: `git clone https://github.com/YOUR_USERNAME/Pasteboard.git`
3. **Create a branch** for your change: `git checkout -b feature/your-feature-name`
4. **Make your changes** and test thoroughly on macOS 13+
5. **Commit** using a clear message: `git commit -m "feat: add pinned items support"`
6. **Push** to your fork: `git push origin feature/your-feature-name`
7. **Open a Pull Request** against the `main` branch

### Guidelines

- Follow existing Swift style conventions in the codebase
- Keep pull requests focused — one feature or fix per PR
- Add inline comments for non-obvious logic, especially around AppKit/Carbon APIs
- Test on macOS 13 (Ventura) and macOS 14 (Sonoma) if possible
- For large changes, please [open an issue](https://github.com/yourusername/Pasteboard/issues/new) first to discuss the approach

### Reporting Bugs

Please use the [GitHub Issues](https://github.com/yourusername/Pasteboard/issues) tracker. Include:
- macOS version
- Steps to reproduce
- Expected vs actual behaviour
- Any relevant console logs from **Console.app** filtered by `Pasteboard`

### Code of Conduct

This project follows the [Contributor Covenant](https://www.contributor-covenant.org/) Code of Conduct. By participating, you are expected to uphold a respectful and inclusive environment.

---

## 📜 Changelog

### v1.0.0 — Initial Release _(2026-03-30)_

This is the first public release of Pasteboard for macOS. 🎉

**Added**
- Automatic clipboard capture for all copied text
- Global hotkey (`⌘ Shift V`) to open the history panel from any app
- Real-time, case-insensitive search across clipboard history
- One-click auto-paste into the active application
- Native menubar integration — no Dock icon
- Local persistence via `UserDefaults` + JSON encoding
- MIT License

---

## 📜 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Made with ❤️ for the macOS community · [Report a Bug](https://github.com/yourusername/Pasteboard/issues) · [Request a Feature](https://github.com/yourusername/Pasteboard/issues)

</div>
