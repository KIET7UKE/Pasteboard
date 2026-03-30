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

struct ClipboardRowView: View {
    let item: ClipboardItem
    let isHovered: Bool
    let isCopied: Bool
    let onCopy: () -> Void
    let onDelete: () -> Void

    var body: some View {
        Button(action: onCopy) {
            HStack(alignment: .top, spacing: 10) {
                // Type icon
                VStack {
                    Image(systemName: item.isMultiline ? "text.alignleft" : "doc.text")
                        .font(.system(size: 11))
                        .foregroundColor(isCopied ? Color(hex: "7C6EFA") : Color.white.opacity(0.3))
                        .frame(width: 24, height: 24)
                        .background(
                            isCopied
                            ? Color(hex: "7C6EFA").opacity(0.15)
                            : Color.white.opacity(0.05)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(item.preview)
                        .font(.system(size: 12.5, weight: .regular))
                        .foregroundColor(isHovered || isCopied ? .white : Color.white.opacity(0.8))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    HStack(spacing: 6) {
                        Text(item.relativeDate)
                            .font(.system(size: 10))
                            .foregroundColor(Color.white.opacity(0.25))

                        if item.wordCount > 1 {
                            Text("·")
                                .foregroundColor(Color.white.opacity(0.2))
                                .font(.system(size: 10))
                            Text("\(item.wordCount) words")
                                .font(.system(size: 10))
                                .foregroundColor(Color.white.opacity(0.25))
                        }
                    }
                }

                Spacer()

                // Action area
                if isCopied {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color(hex: "7C6EFA"))
                        .transition(.scale.combined(with: .opacity))
                } else if isHovered {
                    HStack(spacing: 4) {
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                                .font(.system(size: 10))
                                .foregroundColor(Color.white.opacity(0.35))
                                .padding(5)
                                .background(Color.white.opacity(0.07))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        .buttonStyle(.plain)
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 9)
            .background(
                RoundedRectangle(cornerRadius: 9)
                    .fill(
                        isCopied
                        ? Color(hex: "7C6EFA").opacity(0.08)
                        : isHovered
                        ? Color.white.opacity(0.06)
                        : Color.clear
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 9)
                    .strokeBorder(
                        isCopied ? Color(hex: "7C6EFA").opacity(0.3) : Color.clear,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.2), value: isHovered)
        .animation(.spring(response: 0.3), value: isCopied)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

import AppKit
extension NSPasteboard {
    // Already imported above via AppKit
}
