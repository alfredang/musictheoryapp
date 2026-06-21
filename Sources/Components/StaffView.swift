import SwiftUI

/// Renders a `StaffExample` as real music notation on a five-line staff, and plays it back.
struct StaffView: View {
    let example: StaffExample
    var lineSpacing: CGFloat = 14
    var showPlayButton: Bool = true

    @State private var playingIndex: Int? = nil

    private var staffHeight: CGFloat { lineSpacing * 4 }
    private var topPadding: CGFloat { lineSpacing * 4 }     // room for ledger lines / high notes
    private var bottomPadding: CGFloat { lineSpacing * 4 }
    private var totalHeight: CGFloat { staffHeight + topPadding + bottomPadding }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                Canvas { context, size in
                    draw(in: context, size: size)
                }
                .frame(width: canvasWidth, height: totalHeight)
                .padding(.horizontal, 4)
            }
            if let caption = example.caption {
                Text(caption).font(.caption).foregroundStyle(Theme.mutedInk)
            }
            if showPlayButton {
                Button {
                    playAll()
                } label: {
                    Label("Play", systemImage: "play.circle.fill")
                        .font(.subheadline.weight(.semibold))
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.secondary)
            }
        }
        .appCard()
    }

    // MARK: layout maths

    private var noteSpacing: CGFloat { lineSpacing * 3.0 }
    private var leadingGutter: CGFloat { lineSpacing * 6.5 }   // clef + key sig + time sig
    private var canvasWidth: CGFloat {
        leadingGutter + noteSpacing * CGFloat(max(example.notes.count, 1)) + lineSpacing * 2
    }

    /// Diatonic ladder index (each letter step = 1). C4 -> 28.
    private func diatonicIndex(letter: Pitch.Letter, octave: Int) -> Int { octave * 7 + letter.rawValue }

    private var bottomLine: (letter: Pitch.Letter, octave: Int) {
        switch example.clef {
        case .treble: return (.e, 4)
        case .bass:   return (.g, 2)
        case .alto:   return (.c, 4)   // middle line is C4; bottom line is F3
        }
    }

    /// Y position for a note's vertical staff slot (in points from top of canvas).
    private func y(forLetter letter: Pitch.Letter, octave: Int) -> CGFloat {
        let bottomY = topPadding + staffHeight
        let base = example.clef == .alto
            ? diatonicIndex(letter: .f, octave: 3)
            : diatonicIndex(letter: bottomLine.letter, octave: bottomLine.octave)
        let steps = diatonicIndex(letter: letter, octave: octave) - base
        return bottomY - CGFloat(steps) * (lineSpacing / 2)
    }

    private func draw(in context: GraphicsContext, size: CGSize) {
        let staffColor = Color(white: 0.35)
        let topY = topPadding
        // Five staff lines.
        for i in 0..<5 {
            let lineY = topY + CGFloat(i) * lineSpacing
            var path = Path()
            path.move(to: CGPoint(x: 0, y: lineY))
            path.addLine(to: CGPoint(x: size.width, y: lineY))
            context.stroke(path, with: .color(staffColor), lineWidth: 1)
        }

        // Clef glyph.
        let clefText = Text(example.clef.symbol)
            .font(.system(size: lineSpacing * 6.5))
            .foregroundColor(Theme.ink)
        let clefY = example.clef == .bass ? topY + lineSpacing * 1.4 : topY + lineSpacing * 2.2
        context.draw(clefText, at: CGPoint(x: lineSpacing * 1.8, y: clefY))

        var cursorX = lineSpacing * 3.6

        // Key signature.
        cursorX = drawKeySignature(context: context, startX: cursorX)

        // Time signature.
        if let ts = example.timeSignature {
            let parts = ts.split(separator: "/")
            if parts.count == 2 {
                let top = Text(String(parts[0])).font(.system(size: lineSpacing * 2.1, weight: .bold)).foregroundColor(Theme.ink)
                let bot = Text(String(parts[1])).font(.system(size: lineSpacing * 2.1, weight: .bold)).foregroundColor(Theme.ink)
                context.draw(top, at: CGPoint(x: cursorX + lineSpacing * 0.6, y: topY + lineSpacing))
                context.draw(bot, at: CGPoint(x: cursorX + lineSpacing * 0.6, y: topY + lineSpacing * 3))
                cursorX += lineSpacing * 1.8
            }
        }

        // Notes.
        var x = max(cursorX + lineSpacing, leadingGutter)
        for (i, note) in example.notes.enumerated() {
            drawNote(note, at: x, context: context, highlighted: playingIndex == i)
            x += noteSpacing
        }
    }

    private func drawKeySignature(context: GraphicsContext, startX: CGFloat) -> CGFloat {
        let count = example.keySignatureSharps
        guard count != 0 else { return startX }
        // Standard order + their staff slot in treble clef (letter, octave).
        let sharpSlots: [(Pitch.Letter, Int)] = [(.f,5),(.c,5),(.g,5),(.d,5),(.a,4),(.e,5),(.b,4)]
        let flatSlots: [(Pitch.Letter, Int)]  = [(.b,4),(.e,5),(.a,4),(.d,5),(.g,4),(.c,5),(.f,4)]
        // Shift octave for bass clef (down a 6th visually = -2 octaves on the ladder? use -2 letters).
        let octaveShift = example.clef == .bass ? -2 : 0
        var x = startX
        let n = min(abs(count), 7)
        for idx in 0..<n {
            let slot = count > 0 ? sharpSlots[idx] : flatSlots[idx]
            let glyph = count > 0 ? "♯" : "♭"
            let ypos = y(forLetter: slot.0, octave: slot.1 + octaveShift)
            let t = Text(glyph).font(.system(size: lineSpacing * 2.2)).foregroundColor(Theme.ink)
            context.draw(t, at: CGPoint(x: x, y: ypos))
            x += lineSpacing * 0.95
        }
        return x + lineSpacing * 0.4
    }

    private func drawNote(_ note: StaffNote, at x: CGFloat, context: GraphicsContext, highlighted: Bool) {
        let centerY = y(forLetter: note.pitch.letter, octave: note.octave)
        let headW = lineSpacing * 1.25
        let headH = lineSpacing * 0.95
        let color = highlighted ? Theme.secondary : Theme.ink

        // Ledger lines.
        drawLedgerLines(forY: centerY, x: x, context: context)

        // Accidental.
        if !note.pitch.accidentalSymbol.isEmpty {
            let acc = Text(note.pitch.accidentalSymbol)
                .font(.system(size: lineSpacing * 2.0)).foregroundColor(color)
            context.draw(acc, at: CGPoint(x: x - headW * 0.95, y: centerY))
        }

        // Note head (ellipse).
        let headRect = CGRect(x: x - headW/2, y: centerY - headH/2, width: headW, height: headH)
        let headPath = Path(ellipseIn: headRect)
        if note.duration.isFilled {
            context.fill(headPath, with: .color(color))
        } else {
            context.stroke(headPath, with: .color(color), lineWidth: 2)
        }

        // Stem + flags (not for whole notes).
        if note.duration != .whole {
            let stemUp = centerY > (topPadding + staffHeight / 2)
            let stemX = stemUp ? headRect.maxX - 1 : headRect.minX + 1
            let stemLen = lineSpacing * 3.4
            let endY = stemUp ? centerY - stemLen : centerY + stemLen
            var stem = Path()
            stem.move(to: CGPoint(x: stemX, y: centerY))
            stem.addLine(to: CGPoint(x: stemX, y: endY))
            context.stroke(stem, with: .color(color), lineWidth: 2)

            for f in 0..<note.duration.flags {
                let fy = endY + CGFloat(f) * lineSpacing * 0.6 * (stemUp ? 1 : -1)
                var flag = Path()
                flag.move(to: CGPoint(x: stemX, y: fy))
                flag.addQuadCurve(
                    to: CGPoint(x: stemX + lineSpacing * 1.1, y: fy + lineSpacing * (stemUp ? 1.3 : -1.3)),
                    control: CGPoint(x: stemX + lineSpacing * 1.2, y: fy + lineSpacing * (stemUp ? 0.2 : -0.2)))
                context.stroke(flag, with: .color(color), lineWidth: 2)
            }
        }
    }

    private func drawLedgerLines(forY centerY: CGFloat, x: CGFloat, context: GraphicsContext) {
        let topY = topPadding
        let bottomY = topPadding + staffHeight
        let w = lineSpacing * 1.9
        let color = Color(white: 0.35)
        // Above the staff.
        var ly = topY - lineSpacing
        while centerY <= ly + 0.5 {
            var p = Path(); p.move(to: CGPoint(x: x - w/2, y: ly)); p.addLine(to: CGPoint(x: x + w/2, y: ly))
            context.stroke(p, with: .color(color), lineWidth: 1)
            ly -= lineSpacing
        }
        // Below the staff.
        ly = bottomY + lineSpacing
        while centerY >= ly - 0.5 {
            var p = Path(); p.move(to: CGPoint(x: x - w/2, y: ly)); p.addLine(to: CGPoint(x: x + w/2, y: ly))
            context.stroke(p, with: .color(color), lineWidth: 1)
            ly += lineSpacing
        }
    }

    private func playAll() {
        let notes = example.notes
        guard !notes.isEmpty else { return }
        let dur = 0.5
        for (i, n) in notes.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * dur) {
                playingIndex = i
                ToneEngine.shared.play(midi: n.midi, duration: dur * 0.95)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(notes.count) * dur) {
            playingIndex = nil
        }
    }
}
