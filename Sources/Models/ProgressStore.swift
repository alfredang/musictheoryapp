import Foundation
import Combine

/// Lightweight progress persistence (UserDefaults). Tracks completed lessons and best exam scores.
final class ProgressStore: ObservableObject {
    @Published private(set) var completedLessons: Set<String>
    @Published private(set) var bestExamScore: [Int: Double]   // grade -> best fraction 0...1

    private let lessonsKey = "completedLessons.v1"
    private let scoresKey = "bestExamScore.v1"

    init() {
        let defaults = UserDefaults.standard
        completedLessons = Set(defaults.stringArray(forKey: lessonsKey) ?? [])
        if let raw = defaults.dictionary(forKey: scoresKey) as? [String: Double] {
            bestExamScore = Dictionary(uniqueKeysWithValues: raw.compactMap { key, value in
                Int(key).map { ($0, value) }
            })
        } else {
            bestExamScore = [:]
        }
    }

    func isComplete(_ lessonID: String) -> Bool { completedLessons.contains(lessonID) }

    func toggleComplete(_ lessonID: String) {
        if completedLessons.contains(lessonID) {
            completedLessons.remove(lessonID)
        } else {
            completedLessons.insert(lessonID)
        }
        UserDefaults.standard.set(Array(completedLessons), forKey: lessonsKey)
    }

    func recordExam(grade: Int, fraction: Double) {
        if fraction > (bestExamScore[grade] ?? 0) {
            bestExamScore[grade] = fraction
            persistScores()
        }
    }

    private func persistScores() {
        let raw = Dictionary(uniqueKeysWithValues: bestExamScore.map { (String($0.key), $0.value) })
        UserDefaults.standard.set(raw, forKey: scoresKey)
    }
}
