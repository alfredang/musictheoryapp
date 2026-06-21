import SwiftUI

struct QuizView: View {
    @ObservedObject var session: QuizSession
    @EnvironmentObject private var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                if session.finished {
                    ResultView(session: session) { dismiss() }
                } else {
                    quiz
                }
            }
            .navigationTitle(session.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .onChange(of: session.finished) { _, done in
            if done, let grade = session.grade {
                progress.recordExam(grade: grade, fraction: session.fraction)
            }
        }
    }

    private var quiz: some View {
        let q = session.question
        let chosen = session.selected[session.current]
        return ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ProgressView(value: Double(session.current + 1), total: Double(session.questions.count))
                    .tint(Theme.exams)
                HStack {
                    Chip(text: "Question \(session.current + 1) of \(session.questions.count)", color: Theme.exams)
                    Spacer()
                    Chip(text: q.topic, color: Theme.secondary)
                }

                if let staff = q.staff {
                    StaffView(example: staff, showPlayButton: true)
                }
                if let keys = q.keyboard {
                    PianoKeyboardView(highlighted: Set(keys.compactMap { Pitch($0)?.pitchClass }))
                        .appCard()
                }

                Text(q.prompt).font(.title3.weight(.semibold)).foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(spacing: 12) {
                    ForEach(q.options.indices, id: \.self) { i in
                        optionButton(index: i, chosen: chosen, correct: q.correctIndex)
                    }
                }

                if let chosen {
                    VStack(alignment: .leading, spacing: 8) {
                        Label(chosen == q.correctIndex ? "Correct!" : "Not quite",
                              systemImage: chosen == q.correctIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.headline)
                            .foregroundStyle(chosen == q.correctIndex ? Theme.correct : Theme.wrong)
                        Text(q.explanation).font(.subheadline).foregroundStyle(Theme.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background((chosen == q.correctIndex ? Theme.correct : Theme.wrong).opacity(0.12),
                                in: RoundedRectangle(cornerRadius: 14, style: .continuous))

                    Button {
                        withAnimation { session.next() }
                    } label: {
                        Label(session.isLast ? "See results" : "Next question",
                              systemImage: session.isLast ? "flag.checkered" : "arrow.right")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent).tint(Theme.exams)
                }
            }
            .padding(18)
        }
    }

    private func optionButton(index: Int, chosen: Int?, correct: Int) -> some View {
        let isChosen = chosen == index
        let isCorrect = index == correct
        let revealed = chosen != nil
        let bg: Color = {
            guard revealed else { return Theme.surface }
            if isCorrect { return Theme.correct.opacity(0.18) }
            if isChosen { return Theme.wrong.opacity(0.18) }
            return Theme.surface
        }()
        let border: Color = {
            guard revealed else { return Theme.chip }
            if isCorrect { return Theme.correct }
            if isChosen { return Theme.wrong }
            return Theme.chip
        }()
        return Button {
            withAnimation { session.choose(index) }
        } label: {
            HStack(spacing: 12) {
                Text(String(UnicodeScalar(65 + index)!))
                    .font(.subheadline.bold()).foregroundStyle(Theme.ink)
                    .frame(width: 28, height: 28)
                    .background(Theme.chip, in: Circle())
                Text(q(option: index)).font(.body).foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                if revealed && isCorrect {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.correct)
                } else if revealed && isChosen {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.wrong)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(bg, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(border, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
        .disabled(revealed)
    }

    private func q(option i: Int) -> String { session.question.options[i] }
}
