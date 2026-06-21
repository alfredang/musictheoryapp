import SwiftUI

/// Renders a single `LessonBlock`. Supports lightweight **bold** markup via `attributed`.
struct LessonBlockView: View {
    let block: LessonBlock

    var body: some View {
        switch block {
        case .heading(let text):
            Text(text).font(.title3.bold()).foregroundStyle(Theme.ink)
                .padding(.top, 4)
        case .paragraph(let text):
            Text(attributed(text)).font(.body).foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)
        case .bullets(let items):
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Circle().fill(Theme.primary).frame(width: 6, height: 6).padding(.top, 7)
                        Text(attributed(item)).font(.body).foregroundStyle(Theme.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        case .tip(let text):
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "lightbulb.fill").foregroundStyle(Theme.highlight)
                Text(attributed(text)).font(.callout).foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .background(Theme.highlight.opacity(0.14), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        case .staff(let example):
            StaffView(example: example)
        case .keyboard(let names):
            VStack(alignment: .leading, spacing: 6) {
                PianoKeyboardView(highlighted: pitchClasses(names))
                Text("Tap the keys to hear them.").font(.caption2).foregroundStyle(Theme.mutedInk)
            }
        case .table(let headers, let rows):
            TableBlock(headers: headers, rows: rows)
        }
    }

    private func pitchClasses(_ names: [String]) -> Set<Int> {
        Set(names.compactMap { Pitch($0)?.pitchClass })
    }

    /// Convert a string with **bold** spans into AttributedString.
    private func attributed(_ text: String) -> AttributedString {
        var result = AttributedString()
        var rest = Substring(text)
        while let range = rest.range(of: "**") {
            result.append(AttributedString(String(rest[rest.startIndex..<range.lowerBound])))
            let afterOpen = rest[range.upperBound...]
            if let close = afterOpen.range(of: "**") {
                var bold = AttributedString(String(afterOpen[afterOpen.startIndex..<close.lowerBound]))
                bold.font = .body.bold()
                result.append(bold)
                rest = afterOpen[close.upperBound...]
            } else {
                result.append(AttributedString(String(afterOpen)))
                rest = "".prefix(0)
                break
            }
        }
        result.append(AttributedString(String(rest)))
        return result
    }
}

struct TableBlock: View {
    let headers: [String]
    let rows: [[String]]
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(headers.indices, id: \.self) { i in
                    Text(headers[i]).font(.caption.bold()).foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                }
            }
            .background(Theme.primary)
            ForEach(rows.indices, id: \.self) { r in
                HStack(spacing: 0) {
                    ForEach(rows[r].indices, id: \.self) { c in
                        Text(rows[r][c]).font(.caption).foregroundStyle(Theme.ink)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                    }
                }
                .background(r.isMultiple(of: 2) ? Theme.surface : Theme.chip.opacity(0.5))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Theme.chip, lineWidth: 1))
    }
}
