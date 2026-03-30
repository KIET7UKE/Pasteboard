# 📋 Pasteboard for macOS

A native, high-performance macOS menubar clipboard history manager — built with SwiftUI and AppKit. This tool is designed to mimic the utility of Windows PowerToys Clipboard History but with a native "Mac-first" experience.

---

## ✨ Features

- **🚀 Auto-Paste** — Select any item and it automatically pastes into your active application. No extra typing required.
- **🔄 Automatic Capture** — Every piece of text you copy is silently and instantly saved to your local history.
- **⌨️ Global Hotkey** — Press `⌘ Shift V` from any application to bring up the clipboard history instantly.
- **🔍 Quick Search** — Effortlessly filter through your history with real-time, case-insensitive search.
- **🧩 Native Experience** — Designed to live in the menubar, keeping your Dock clean and your tools close.
- **💾 Local Storage** — Your history is stored securely on your machine using `UserDefaults`, surviving app restarts.
- **📏 50-Item Limit** — Keeps the last 50 entries, automatically deduplicating items to keep your workflow clean.
- **🛡️ Privacy Focused** — No analytics, no cloud syncing, and no external requests. Your data stays on your Mac.

---

## 🛠 Requirements

- **macOS 13 (Ventura)** or later
- **Xcode 15** or later (for building from source)

---

## 🚀 Installation & Build

### Building from Source

1. Clone the repository: `git clone https://github.com/yourusername/Pasteboard.git`
2. Open `ClipboardManager.xcodeproj` in Xcode.
3. Select your Mac as the run target.
4. Press `⌘R` to build and run.
5. The application will appear in your **menubar** (look for the clipboard icon in the top-right).

### CLI Build

```bash
xcodebuild -project ClipboardManager.xcodeproj \
           -scheme ClipboardManager \
           -configuration Release \
           -derivedDataPath ./build
```

---

## ⚠️ Important: Permissions

Because this app simulates keystrokes for the **Auto-Paste** feature and registers a **Global Hotkey**, it requires **Accessibility Permissions**.

### Troubleshooting Permissions:
If the hotkey or auto-paste features are not working:
1. Go to **System Settings** > **Privacy & Security** > **Accessibility**.
2. **Crucial**: Select `Pasteboard` and click the **minus (-)** button to remove it entirely.
3. Relaunch the app.
4. When prompted, grant the app permission again. Simply toggling the switch is often insufficient for macOS to refresh its security token.

---

## 📁 Architecture & Tech Stack

This project is a hybrid of **SwiftUI** and **AppKit**, leveraging the best of both worlds:

- **SwiftUI**: Used for the layout and theming of the `ClipboardHistoryView` and `ClipboardRowView`. Uses a `LazyVStack` within a `ScrollView` for efficient list rendering.
- **AppKit (`NSHostingController`)**: Hosts the SwiftUI view within an `NSPopover` for the native menubar behavior.
- **Carbon Framework**: Used to register global hotkeys (`RegisterEventHotKey`).
- **CGEvent Simulation**: Uses Core Graphics events to simulate `Command + V` for the auto-paste functionality.
- **Combine**: Used for reactive state management via the `ClipboardStore` observable object.

---

## ⌨️ Global Shortcuts

| Action | How |
|---|---|
| **Toggle History** | `⌘ Shift V` (cmd+shift+v) |
| **Close Panel** | Click anywhere else (transient behavior) |
| **Search** | Just start typing in the search bar |
| **Delete Item** | Hover over item > click 🗑 icon |

---

## 🔧 Developer Customization

### Change the Max Items Limit
Edit `ClipboardManager/ClipboardStore.swift`:
```swift
private let maxItems = 100 // Set your preferred history length
```

### Change the Global Hotkey
Edit `ClipboardManager/AppDelegate.swift`:
```swift
// Virtual key code for 'V' is 9. Adjust modifiers as needed.
let status = RegisterEventHotKey(
    UInt32(kVK_ANSI_V),     // Key
    UInt32(cmdKey | shiftKey), // Modifiers
    ...
)
```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request or open an Issue for:
- 🖼️ Image/File clipboard support
- ☁️ iCloud Syncing
- 🎨 Theme customization
- 🌍 Localization

---

## 📜 License

This project is licensed under the **MIT License**. See the `LICENSE` file for details (or just use it however you want!).

---

*Made with ❤️ for the macOS community.*
