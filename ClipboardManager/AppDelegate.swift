import AppKit
import SwiftUI
import Carbon

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var clipboardTimer: Timer?
    var lastChangeCount: Int = 0
    var eventMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        // Setup menubar icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "Pasteboard")
            button.action = #selector(togglePopover)
            button.target = self
        }

        // Setup popover
        let popover = NSPopover()
        popover.behavior = .transient
        let hostingController = NSHostingController(rootView: ClipboardHistoryView())
        popover.contentViewController = hostingController
        // Ensure content size is set. Using fittingSize here might be too early, 
        // so we use the explicit size intended for the UI.
        popover.contentSize = NSSize(width: 380, height: 520)
        self.popover = popover

        // Start monitoring clipboard
        lastChangeCount = NSPasteboard.general.changeCount
        clipboardTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }

        // Global hotkey: Cmd+Shift+V
        registerGlobalHotkey()
    }

    func checkClipboard() {
        let pb = NSPasteboard.general
        if pb.changeCount != lastChangeCount {
            lastChangeCount = pb.changeCount
            if let text = pb.string(forType: .string), !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ClipboardStore.shared.add(text)
            }
        }
    }

    @objc func togglePopover() {
        guard let button = statusItem?.button else { return }
        if let popover = popover {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                // Activate the app to handle focus properly
                NSApp.activate(ignoringOtherApps: true)
                // Use async to show the popover to ensure we are not in a layout pass
                DispatchQueue.main.async {
                    popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                }
            }
        }
    }

    func hideAndPaste() {
        if let popover = popover, popover.isShown {
            popover.performClose(nil)
            // Tiny delay to let focus return to the previous application
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                ClipboardStore.shared.paste()
            }
        }
    }

    func registerGlobalHotkey() {
        // Register Cmd+Shift+V as global hotkey
        let handler: EventHandlerUPP = { _, event, userData -> OSStatus in
            guard let userData = userData else { return noErr }
            let delegate = Unmanaged<AppDelegate>.fromOpaque(userData).takeUnretainedValue()
            DispatchQueue.main.async {
                delegate.togglePopover()
            }
            return noErr
        }

        var hotKeyRef: EventHotKeyRef?
        var gMyHotKeyID = EventHotKeyID()
        gMyHotKeyID.signature = OSType(0x4350_4D47) // "CPMG"
        gMyHotKeyID.id = 1

        // Cmd+Shift+V = keyCode 9, modifiers: cmdKey + shiftKey
        let status = RegisterEventHotKey(
            UInt32(kVK_ANSI_V),
            UInt32(cmdKey | shiftKey),
            gMyHotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )

        if status == noErr {
            var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
            InstallEventHandler(
                GetApplicationEventTarget(),
                handler,
                1,
                &eventType,
                Unmanaged.passUnretained(self).toOpaque(),
                nil
            )
        }
    }
}
