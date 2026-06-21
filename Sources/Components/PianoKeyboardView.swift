import SwiftUI

/// An interactive piano keyboard. Highlights a set of pitch classes and plays a note on tap.
struct PianoKeyboardView: View {
    /// Pitch classes (0–11) to highlight.
    var highlighted: Set<Int> = []
    /// Lowest octave shown and how many octaves.
    var startOctave: Int = 4
    var octaves: Int = 2
    var height: CGFloat = 150

    private let whiteOffsets = [0, 2, 4, 5, 7, 9, 11]        // C D E F G A B
    private let blackOffsets: [Int?] = [1, 3, nil, 6, 8, 10] // C# D# _ F# G# A#

    var body: some View {
        GeometryReader { geo in
            let whiteCount = whiteOffsets.count * octaves
            let whiteW = geo.size.width / CGFloat(whiteCount)
            ZStack(alignment: .topLeading) {
                // White keys.
                HStack(spacing: 0) {
                    ForEach(0..<whiteCount, id: \.self) { idx in
                        let octave = startOctave + idx / whiteOffsets.count
                        let pc = whiteOffsets[idx % whiteOffsets.count]
                        keyView(isBlack: false, isOn: highlighted.contains(pc))
                            .frame(width: whiteW)
                            .onTapGesture { ToneEngine.shared.play(midi: octave * 12 + 12 + pc) }
                    }
                }
                // Black keys.
                ForEach(0..<whiteCount, id: \.self) { idx in
                    let group = idx % whiteOffsets.count
                    if group < blackOffsets.count, let pc = blackOffsets[group] {
                        let octave = startOctave + idx / whiteOffsets.count
                        keyView(isBlack: true, isOn: highlighted.contains(pc))
                            .frame(width: whiteW * 0.62, height: height * 0.62)
                            .offset(x: whiteW * CGFloat(idx) + whiteW * 0.69, y: 0)
                            .onTapGesture { ToneEngine.shared.play(midi: octave * 12 + 12 + pc) }
                    }
                }
            }
        }
        .frame(height: height)
    }

    private func keyView(isBlack: Bool, isOn: Bool) -> some View {
        let base = isBlack ? Color(white: 0.12) : Color.white
        let onColor = isBlack ? Theme.secondary : Theme.primary.opacity(0.85)
        return RoundedRectangle(cornerRadius: isBlack ? 4 : 6)
            .fill(isOn ? onColor : base)
            .overlay(
                RoundedRectangle(cornerRadius: isBlack ? 4 : 6)
                    .stroke(Color(white: 0.6), lineWidth: 0.5)
            )
    }
}
