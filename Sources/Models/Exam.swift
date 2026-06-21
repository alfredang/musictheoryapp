import Foundation

/// One multiple-choice question. May carry a notation figure to read.
struct Question: Identifiable, Hashable {
    let id: String
    let topic: String
    let prompt: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
    var staff: StaffExample? = nil      // optional figure shown above the question
    var keyboard: [String]? = nil       // optional highlighted keys
}

/// A graded set of questions (Grade 1–8).
struct GradeExam: Identifiable, Hashable {
    var id: Int { grade }
    let grade: Int
    let title: String
    let focus: String                   // what this grade covers
    let questions: [Question]
}

/// Live state of a quiz attempt (exam or practice).
final class QuizSession: ObservableObject {
    let questions: [Question]
    let title: String
    let grade: Int?                      // nil for mixed practice
    @Published var current: Int = 0
    @Published var selected: [Int: Int] = [:]   // questionIndex -> chosen option
    @Published var finished = false

    init(questions: [Question], title: String, grade: Int? = nil) {
        self.questions = questions
        self.title = title
        self.grade = grade
    }

    var question: Question { questions[current] }
    var isLast: Bool { current == questions.count - 1 }
    var answeredCurrent: Bool { selected[current] != nil }

    func choose(_ index: Int) {
        guard selected[current] == nil else { return }   // lock once answered
        selected[current] = index
    }

    func next() {
        if isLast { finished = true } else { current += 1 }
    }

    var correctCount: Int {
        questions.indices.filter { selected[$0] == questions[$0].correctIndex }.count
    }
    var fraction: Double {
        questions.isEmpty ? 0 : Double(correctCount) / Double(questions.count)
    }
}
