import SwiftUI
import AppKit

struct ClipboardHistoryView: View {
    @StateObject private var store = ClipboardStore.shared
    @State private var searchText = ""
    @State private var copiedID: UUID? = nil
    @State private var hoveredID: UUID? = nil

    var filtered: [ClipboardItem] {
        if searchText.isEmpty { return store.items }
        return store.items.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        ZStack {
            // Background
            Color(hex: "0D0D0F")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerView

                // Search
                searchBar

                Divider()
                    .background(Color.white.opacity(0.06))

                // List
                if filtered.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 2) {
                            ForEach(filtered) { item in
                                ClipboardRowView(
                                    item: item,
                                    isHovered: hoveredID == item.id,
                                    isCopied: copiedID == item.id,
                                    onCopy: {
                                        copyItem(item)
                                    },
                                    onDelete: {
                                        store.remove(item)
                                    }
                                )
                                .onHover { isHovered in
                                    hoveredID = isHovered ? item.id : nil
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                    }
                }

                // Footer
                footerView
            }
        }
        .frame(minWidth: 380, maxWidth: 380, minHeight: 520, maxHeight: 520)
        .background(Color(hex: "0D0D0F"))
        .preferredColorScheme(.dark)
    }

    var headerView: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "doc.on.clipboard.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "7C6EFA"))

                Text("Clipboard")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)

                Text("\(store.items.count)")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "7C6EFA"))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(hex: "7C6EFA").opacity(0.15))
                    .clipShape(Capsule())
            }

            Spacer()

            Button(action: { store.clear() }) {
                Text("Clear all")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.35))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12))
                .foregroundColor(Color.white.opacity(0.3))

            TextField("Search history...", text: $searchText)
                .textFieldStyle(.plain)
                .font(.system(size: 13))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }

    var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "clipboard")
                .font(.system(size: 36))
                .foregroundColor(Color.white.opacity(0.12))
            Text(searchText.isEmpty ? "Nothing copied yet" : "No results found")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color.white.opacity(0.25))
            Spacer()
        }
    }

    var footerView: some View {
        HStack {
            HStack(spacing: 4) {
                Image(systemName: "keyboard")
                    .font(.system(size: 10))
                Text("⌘⇧V to open")
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundColor(Color.white.opacity(0.2))

            Spacer()

            Button(action: quitApp) {
                Text("Quit")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.2))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.03))
    }

    func copyItem(_ item: ClipboardItem) {
        store.copyToClipboard(item.text)
        withAnimation(.spring(response: 0.3)) {
            copiedID = item.id
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation { copiedID = nil }
        }
        // Auto-paste and close the popover after copy
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            (NSApp.delegate as? AppDelegate)?.hideAndPaste()
        }
    }

    func quitApp() {
        NSApp.terminate(nil)
    }
}

// ClipboardRowView and Color extension have been moved to their own files in Views/ and Utilities/.
