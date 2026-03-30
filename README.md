# 📋 Pasteboard

A native macOS app to manage and search your clipboard history. Built with SwiftUI and AppKit. This tool provides a seamless, "Mac-first" experience for power users.

**macOS 13+** · **Swift 5.9** · **License MIT**

---

## ✨ Features

- **🚀 Auto-Paste** — Select any item and it automatically pastes into your active application. No extra typing required.
- **🔄 Automatic Capture** — Every piece of text you copy is instantly saved to your local history.
- **⌨️ Global Hotkey** — Press `⌘ Shift V` from any app to bring up the history instantly.
- **🔍 Quick Search** — Real-time, case-insensitive search to find exactly what you need.
- **🧩 Native Experience** — Designed to live in the menubar, keeping your Dock clean.
- **🛡️ Privacy Focused** — No analytics, no cloud syncing. Your data stays on your Mac.

---

## 🚀 Install

### Option 1: Install Script (recommended)

```bash
git clone https://github.com/yourusername/Pasteboard.git
cd Pasteboard
chmod +x *.sh
./install.sh
```
This builds a release binary and installs **Pasteboard.app** to `/Applications`.

### Option 2: Build & Run
```bash
git clone https://github.com/yourusername/Pasteboard.git
cd Pasteboard
xcodebuild -project Pasteboard.xcodeproj -scheme Pasteboard -configuration Release build
```

### Option 3: Open in Xcode
Open `Pasteboard.xcodeproj` and press `⌘R` to build and run.

---

## 🗑 Uninstall

```bash
cd Pasteboard
./uninstall.sh
```
Or just delete `/Applications/Pasteboard.app`.

---

## 🛠 Requirements

- **macOS 13 (Ventura)** or later
- **Xcode Command Line Tools** (`xcode-select --install`)
- **Accessibility Permissions** (Required for hotkey and auto-paste)

---

## 📁 Architecture

```text
Pasteboard/
├── App/
│   ├── PasteboardApp.swift    # App entry point
│   └── AppDelegate.swift      # Menubar & Hotkey management
├── Models/
│   └── ClipboardItem.swift    # Data model for history entries
├── Services/
│   └── ClipboardStore.swift   # Clipboard observer & persistence
├── Views/
│   ├── ClipboardHistoryView.swift # Main history panel UI
│   └── ClipboardRowView.swift     # Individual history item UI
├── Utilities/
│   └── Color+Hex.swift        # SwiftUI styling extensions
└── Resources/
    ├── Info.plist             # App metadata
    └── Pasteboard.entitlements # App capabilities
```

### Key Design Decisions:
- **Hybrid Architecture**: SwiftUI for the UI layer and AppKit for native menubar integration.
- **Accessibility Integration**: Uses `CGEvent` simulation for auto-paste functionality.
- **Global Hotkeys**: Leverages Carbon framework for low-latency global event monitoring.
- **Persistence**: Efficient data handling using `UserDefaults` and `JSON` encoding.

---

## ⚠️ Troubleshooting Permissions

If the hotkey or auto-paste features are not working:
1. Go to **System Settings** > **Privacy & Security** > **Accessibility**.
2. **Crucial**: Select `Pasteboard` and click the **minus (-)** button to remove it entirely.
3. Relaunch the app and grant permission when prompted.

---

## 📜 License

This project is licensed under the **MIT License**.

---

*Made with ❤️ for the macOS community.*
