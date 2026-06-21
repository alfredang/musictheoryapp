import SwiftUI

struct ExamsHomeView: View {
    @EnvironmentObject private var progress: ProgressStore
    @State private var session: QuizSession?

    private var topics: [String] {
        var seen: [String] = []
        for q in ExamData.allQuestions where !seen.contains(q.topic) { seen.append(q.topic) }
        return seen.sorted()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        SectionHeader(title: "Exams & Practice",
                                      subtitle: "Grade 1–8 mock tests and topic drills",
                                      systemImage: "checkmark.seal.fill", tint: Theme.exams)

                        Button {
                            startMixedPractice()
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: "bolt.fill").font(.title2).foregroundStyle(.white)
                                    .frame(width: 46, height: 46)
                                    .background(Theme.highlight.gradient, in: RoundedRectangle(cornerRadius: 12))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Quick Practice").font(.headline).foregroundStyle(Theme.ink)
                                    Text("10 random questions across all grades").font(.caption).foregroundStyle(Theme.mutedInk)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(Theme.mutedInk)
                            }
                            .appCard()
                        }
                        .buttonStyle(.plain)

                        Text("MOCK EXAMS").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        ForEach(ExamData.exams) { exam in
                            Button { startExam(exam) } label: { examCard(exam) }
                                .buttonStyle(.plain)
                        }

                        Text("PRACTICE BY TOPIC").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                            .padding(.top, 4)
                        FlexibleView(data: topics, spacing: 8, lineSpacing: 8) { topic in
                            Button { startTopic(topic) } label: {
                                Text(topic).font(.caption.weight(.semibold)).foregroundStyle(Theme.exams)
                                    .padding(.horizontal, 12).padding(.vertical, 8)
                                    .background(Theme.exams.opacity(0.14), in: Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle("Exams")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(item: $session) { session in
                QuizView(session: session)
            }
            .onAppear {
                // Screenshot-automation hook: `-autoExam <grade>` opens that mock exam on launch.
                let args = ProcessInfo.processInfo.arguments
                if let i = args.firstIndex(of: "-autoExam"), i + 1 < args.count,
                   let g = Int(args[i + 1]), let exam = ExamData.exam(grade: g), session == nil {
                    session = QuizSession(questions: exam.questions, title: exam.title, grade: exam.grade)
                }
            }
        }
    }

    private func examCard(_ exam: GradeExam) -> some View {
        let best = progress.bestExamScore[exam.grade]
        return HStack(spacing: 14) {
            Text("\(exam.grade)").font(.title.bold()).foregroundStyle(.white)
                .frame(width: 50, height: 50)
                .background(Theme.exams.gradient, in: RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 3) {
                Text(exam.title).font(.headline).foregroundStyle(Theme.ink)
                Text(exam.focus).font(.caption).foregroundStyle(Theme.mutedInk)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 2) {
                if let best {
                    Text("\(Int(best * 100))%").font(.subheadline.bold())
                        .foregroundStyle(best >= 0.66 ? Theme.correct : Theme.exams)
                    Text("best").font(.caption2).foregroundStyle(Theme.mutedInk)
                } else {
                    Image(systemName: "chevron.right").foregroundStyle(Theme.mutedInk)
                }
            }
        }
        .appCard()
    }

    private func startExam(_ exam: GradeExam) {
        session = QuizSession(questions: exam.questions, title: exam.title, grade: exam.grade)
    }
    private func startMixedPractice() {
        let q = Array(ExamData.allQuestions.shuffled().prefix(10))
        session = QuizSession(questions: q, title: "Quick Practice")
    }
    private func startTopic(_ topic: String) {
        let q = ExamData.allQuestions.filter { $0.topic == topic }
        session = QuizSession(questions: q, title: topic)
    }
}

extension QuizSession: Identifiable {
    var id: ObjectIdentifier { ObjectIdentifier(self) }
}
