import SwiftUI

struct ResultView: View {
    @ObservedObject var session: QuizSession
    var onDone: () -> Void

    private var pct: Int { Int((session.fraction * 100).rounded()) }
    private var passed: Bool { session.fraction >= 0.66 }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                ZStack {
                    Circle().stroke(Theme.chip, lineWidth: 14).frame(width: 170, height: 170)
                    Circle().trim(from: 0, to: session.fraction)
                        .stroke((passed ? Theme.correct : Theme.exams).gradient,
                                style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 170, height: 170)
                    VStack(spacing: 2) {
                        Text("\(pct)%").font(.system(size: 44, weight: .bold)).foregroundStyle(Theme.ink)
                        Text("\(session.correctCount)/\(session.questions.count)")
                            .font(.subheadline).foregroundStyle(Theme.mutedInk)
                    }
                }
                .padding(.top, 16)

                Text(passed ? "Well done! 🎉" : "Keep practising")
                    .font(.title2.bold()).foregroundStyle(Theme.ink)
                Text(message).font(.subheadline).foregroundStyle(Theme.mutedInk)
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 12) {
                    Text("REVIEW").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                    ForEach(session.questions.indices, id: \.self) { i in
                        let correct = session.selected[i] == session.questions[i].correctIndex
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundStyle(correct ? Theme.correct : Theme.wrong)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(session.questions[i].prompt).font(.subheadline).foregroundStyle(Theme.ink)
                                    .fixedSize(horizontal: false, vertical: true)
                                if !correct {
                                    Text("Answer: \(session.questions[i].options[session.questions[i].correctIndex])")
                                        .font(.caption).foregroundStyle(Theme.correct)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .appCard()

                Button { onDone() } label: {
                    Label("Done", systemImage: "checkmark").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent).tint(Theme.exams)
            }
            .padding(18)
        }
    }

    private var message: String {
        switch session.fraction {
        case 0.9...: return "Outstanding — you've mastered this material."
        case 0.66..<0.9: return "A solid pass. Review the missed questions to sharpen up."
        case 0.4..<0.66: return "You're getting there. Revisit the lessons and try again."
        default: return "Work through the related lessons, then retake the test."
        }
    }
}
