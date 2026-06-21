import SwiftUI

struct LessonDetailView: View {
    let lesson: Lesson
    @EnvironmentObject private var progress: ProgressStore

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Chip(text: lesson.level.rawValue, color: Theme.learn)
                        Spacer()
                    }
                    Text(lesson.summary).font(.headline).foregroundStyle(Theme.mutedInk)
                        .fixedSize(horizontal: false, vertical: true)

                    ForEach(Array(lesson.blocks.enumerated()), id: \.offset) { _, block in
                        LessonBlockView(block: block)
                    }

                    Button {
                        progress.toggleComplete(lesson.id)
                    } label: {
                        Label(progress.isComplete(lesson.id) ? "Completed" : "Mark as complete",
                              systemImage: progress.isComplete(lesson.id) ? "checkmark.circle.fill" : "circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(progress.isComplete(lesson.id) ? Theme.correct : Theme.learn)
                    .padding(.top, 6)
                }
                .padding(18)
            }
        }
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IntervalsView: View {
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("An interval is the distance between two pitches, measured in semitones. Tap to hear each one from C.")
                        .font(.subheadline).foregroundStyle(Theme.mutedInk)
                    ForEach(Interval.all) { interval in
                        Button {
                            ToneEngine.shared.playSequence([60, 60 + interval.semitones], noteDuration: 0.5)
                        } label: {
                            HStack(spacing: 14) {
                                Text(interval.shortName)
                                    .font(.headline.monospaced()).foregroundStyle(.white)
                                    .frame(width: 48, height: 40)
                                    .background(Theme.secondary, in: RoundedRectangle(cornerRadius: 10))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(interval.name).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.ink)
                                    Text("\(interval.semitones) semitones · \(interval.example)")
                                        .font(.caption).foregroundStyle(Theme.mutedInk)
                                }
                                Spacer()
                                Image(systemName: "play.circle.fill").foregroundStyle(Theme.secondary)
                            }
                            .appCard()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(18)
            }
        }
        .navigationTitle("Intervals")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GlossaryView: View {
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            List {
                ForEach(GlossaryData.terms) { term in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(term.term).font(.headline).foregroundStyle(Theme.ink)
                        Text(term.definition).font(.subheadline).foregroundStyle(Theme.mutedInk)
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(Theme.surface)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Glossary")
        .navigationBarTitleDisplayMode(.inline)
    }
}
