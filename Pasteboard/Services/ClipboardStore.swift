import Foundation
import Combine
#if canImport(AppKit)
import AppKit
#endif

class ClipboardStore: ObservableObject {
    static let shared = ClipboardStore()

    @Published var items: [ClipboardItem] = []
    private let maxItems = 50
    private let saveKey = "clipboard_history"

    private init() {
        load()
    }

    func add(_ text: String) {
        DispatchQueue.main.async {
            // Avoid duplicates at the top
            if self.items.first?.text == text { return }

            // Remove existing duplicate
            self.items.removeAll { $0.text == text }

            let item = ClipboardItem(text: text)
            self.items.insert(item, at: 0)

            // Trim to max
            if self.items.count > self.maxItems {
                self.items = Array(self.items.prefix(self.maxItems))
            }

            self.save()
        }
    }

    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func remove(_ item: ClipboardItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func clear() {
        items.removeAll()
        save()
    }

    func copyToClipboard(_ text: String) {
        #if canImport(AppKit)
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(text, forType: NSPasteboard.PasteboardType.string)
        #endif
    }

    func paste() {
        #if canImport(AppKit)
        // Check for accessibility permissions first
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        let isTrusted = AXIsProcessTrustedWithOptions(options)
        
        if !isTrusted {
            print("Pasteboard: Accessibility permissions not granted. Auto-paste will fail.")
            return
        }

        // Simulate Command + V to paste the content
        let source = CGEventSource(stateID: .hidSystemState)
        
        // V key is 9
        let keyV: UInt16 = 9
        
        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: keyV, keyDown: true)
        keyDown?.flags = .maskCommand
        
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: keyV, keyDown: false)
        keyUp?.flags = .maskCommand
        
        keyDown?.post(tap: .cghidEventTap)
        keyUp?.post(tap: .cghidEventTap)
        #endif
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let saved = try? JSONDecoder().decode([ClipboardItem].self, from: data) {
            items = saved
        }
    }
}

