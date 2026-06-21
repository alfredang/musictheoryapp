import Foundation

/// A single learning block within a lesson — keeps the body composable/renderable.
enum LessonBlock: Hashable {
    case paragraph(String)
    case heading(String)
    case bullets([String])
    case tip(String)                       // highlighted "key idea" callout
    case staff(StaffExample)               // an inline music-notation figure
    case keyboard([String])                // highlight these note names on a piano
    case table(headers: [String], rows: [[String]])
}

/// A lesson, grouped into a learning unit and tagged with a difficulty level.
struct Lesson: Identifiable, Hashable {
    enum Level: String, CaseIterable { case basic = "Basic", intermediate = "Intermediate", advanced = "Advanced" }
    let id: String
    let title: String
    let summary: String
    let level: Level
    let systemImage: String
    let blocks: [LessonBlock]
}

/// A learning unit groups related lessons (Module 1, 2, …).
struct LearningUnit: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let systemImage: String
    let lessons: [Lesson]
}
