import SwiftUI

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
