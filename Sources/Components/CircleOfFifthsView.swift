import SwiftUI

/// One position on the circle of fifths (the "wheel of scales").
struct KeyWheelEntry: Identifiable, Hashable {
    var id: Int { index }
    let index: Int            // 0 = C, clockwise by fifths
    let major: String
    let minor: String
    let sharps: Int           // +n sharps, -n flats
    let rootPitch: String     // for audio (major root)

    var accidentalText: String {
        if sharps == 0 { return "no ♯/♭" }
        if sharps > 0 { return "\(sharps)♯" }
        return "\(-sharps)♭"
    }

    static let all: [KeyWheelEntry] = [
        KeyWheelEntry(index: 0,  major: "C",  minor: "Am",  sharps: 0,  rootPitch: "C"),
        KeyWheelEntry(index: 1,  major: "G",  minor: "Em",  sharps: 1,  rootPitch: "G"),
        KeyWheelEntry(index: 2,  major: "D",  minor: "Bm",  sharps: 2,  rootPitch: "D"),
        KeyWheelEntry(index: 3,  major: "A",  minor: "F♯m", sharps: 3,  rootPitch: "A"),
        KeyWheelEntry(index: 4,  major: "E",  minor: "C♯m", sharps: 4,  rootPitch: "E"),
        KeyWheelEntry(index: 5,  major: "B",  minor: "G♯m", sharps: 5,  rootPitch: "B"),
        KeyWheelEntry(index: 6,  major: "F♯", minor: "D♯m", sharps: 6,  rootPitch: "F#"),
        KeyWheelEntry(index: 7,  major: "D♭", minor: "B♭m", sharps: -5, rootPitch: "Db"),
        KeyWheelEntry(index: 8,  major: "A♭", minor: "Fm",  sharps: -4, rootPitch: "Ab"),
        KeyWheelEntry(index: 9,  major: "E♭", minor: "Cm",  sharps: -3, rootPitch: "Eb"),
        KeyWheelEntry(index: 10, major: "B♭", minor: "Gm",  sharps: -2, rootPitch: "Bb"),
        KeyWheelEntry(index: 11, major: "F",  minor: "Dm",  sharps: -1, rootPitch: "F"),
    ]
}

struct CircleOfFifthsView: View {
    @Binding var selected: Int
    var diameter: CGFloat = 300

    var body: some View {
        ZStack {
            Circle().stroke(Theme.chip, lineWidth: 1)
                .frame(width: diameter, height: diameter)
            Circle().stroke(Theme.chip, lineWidth: 1)
                .frame(width: diameter * 0.62, height: diameter * 0.62)

            ForEach(KeyWheelEntry.all) { entry in
                let angle = Angle.degrees(Double(entry.index) / 12.0 * 360.0 - 90)
                let isSel = entry.index == selected
                // Major (outer ring).
                segmentLabel(entry.major, isSelected: isSel, color: Theme.primary)
                    .position(point(angle: angle, radius: diameter * 0.40, center: diameter/2))
                    .onTapGesture { select(entry) }
                // Minor (inner ring).
                segmentLabel(entry.minor, isSelected: isSel, color: Theme.secondary, small: true)
                    .position(point(angle: angle, radius: diameter * 0.22, center: diameter/2))
                    .onTapGesture { select(entry) }
            }

            // Center accidental readout.
            VStack(spacing: 2) {
                Text(KeyWheelEntry.all[selected].major).font(.title3.bold()).foregroundStyle(Theme.ink)
                Text(KeyWheelEntry.all[selected].accidentalText).font(.caption).foregroundStyle(Theme.mutedInk)
            }
        }
        .frame(width: diameter, height: diameter)
    }

    private func select(_ entry: KeyWheelEntry) {
        selected = entry.index
        if let p = Pitch(entry.rootPitch) {
            ToneEngine.shared.play(midi: p.midi(octave: 4), duration: 0.5)
        }
    }

    private func segmentLabel(_ text: String, isSelected: Bool, color: Color, small: Bool = false) -> some View {
        Text(text)
            .font(small ? .subheadline.weight(.semibold) : .headline)
            .foregroundStyle(isSelected ? .white : Theme.ink)
            .frame(width: small ? 42 : 48, height: small ? 42 : 48)
            .background(isSelected ? color : Theme.surface, in: Circle())
            .overlay(Circle().stroke(color.opacity(0.4), lineWidth: isSelected ? 0 : 1))
    }

    private func point(angle: Angle, radius: CGFloat, center: CGFloat) -> CGPoint {
        CGPoint(x: center + radius * cos(angle.radians), y: center + radius * sin(angle.radians))
    }
}
