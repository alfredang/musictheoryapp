import SwiftUI

struct LearnHomeView: View {
    @EnvironmentObject private var progress: ProgressStore

    private var totalLessons: Int { LessonData.units.flatMap(\.lessons).count }
    private var completed: Int {
        LessonData.units.flatMap(\.lessons).filter { progress.isComplete($0.id) }.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        SectionHeader(title: "Learn Music Theory",
                                      subtitle: "From the basics to advanced harmony",
                                      systemImage: "book.fill", tint: Theme.learn)

                        progressCard

                        Text("LEARNING PATH").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        ForEach(LessonData.units) { unit in
                            NavigationLink(value: Route.unit(unit)) {
                                unitCard(unit)
                            }
                            .buttonStyle(.plain)
                        }

                        Text("EXPLORE").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                            .padding(.top, 4)
                        NavigationLink(value: Route.genres) {
                            exploreCard("Musical Styles", "Jazz, blues, R&B, soul & classical",
                                        "music.mic", Theme.genres)
                        }.buttonStyle(.plain)
                        NavigationLink(value: Route.intervals) {
                            exploreCard("Intervals Reference", "Every interval from unison to octave",
                                        "ruler.fill", Theme.secondary)
                        }.buttonStyle(.plain)
                    }
                    .padding(18)
                }
            }
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .unit(let u): UnitView(unit: u)
                case .lesson(let l): LessonDetailView(lesson: l)
                case .genres: GenresListView()
                case .genre(let g): GenreDetailView(genre: g)
                case .intervals: IntervalsView()
                }
            }
        }
    }

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Your progress").font(.headline).foregroundStyle(Theme.ink)
                Spacer()
                Text("\(completed)/\(totalLessons)").font(.subheadline.bold()).foregroundStyle(Theme.learn)
            }
            ProgressView(value: Double(completed), total: Double(max(totalLessons, 1)))
                .tint(Theme.learn)
            Text(completed == 0 ? "Start with Module 1 below." :
                    "Keep going — tap a module to continue.")
                .font(.caption).foregroundStyle(Theme.mutedInk)
        }
        .appCard()
    }

    private func unitCard(_ unit: LearningUnit) -> some View {
        let done = unit.lessons.filter { progress.isComplete($0.id) }.count
        return HStack(spacing: 14) {
            Image(systemName: unit.systemImage)
                .font(.title2).foregroundStyle(Theme.learn)
                .frame(width: 46, height: 46)
                .background(Theme.learn.opacity(0.14), in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 3) {
                Text(unit.title).font(.headline).foregroundStyle(Theme.ink)
                Text(unit.subtitle).font(.caption).foregroundStyle(Theme.mutedInk)
                Text("\(done)/\(unit.lessons.count) lessons").font(.caption2).foregroundStyle(Theme.learn)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.mutedInk)
        }
        .appCard()
    }

    private func exploreCard(_ title: String, _ subtitle: String, _ image: String, _ tint: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: image).font(.title2).foregroundStyle(.white)
                .frame(width: 46, height: 46)
                .background(tint.gradient, in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.headline).foregroundStyle(Theme.ink)
                Text(subtitle).font(.caption).foregroundStyle(Theme.mutedInk)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.mutedInk)
        }
        .appCard()
    }
}

/// Navigation routes for the Learn tab.
enum Route: Hashable {
    case unit(LearningUnit)
    case lesson(Lesson)
    case genres
    case genre(Genre)
    case intervals
}

struct UnitView: View {
    let unit: LearningUnit
    @EnvironmentObject private var progress: ProgressStore
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text(unit.subtitle).font(.subheadline).foregroundStyle(Theme.mutedInk)
                    ForEach(unit.lessons) { lesson in
                        NavigationLink(value: Route.lesson(lesson)) {
                            HStack(spacing: 14) {
                                Image(systemName: progress.isComplete(lesson.id) ? "checkmark.circle.fill" : lesson.systemImage)
                                    .font(.title3)
                                    .foregroundStyle(progress.isComplete(lesson.id) ? Theme.correct : Theme.learn)
                                    .frame(width: 34)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(lesson.title).font(.headline).foregroundStyle(Theme.ink)
                                    Text(lesson.summary).font(.caption).foregroundStyle(Theme.mutedInk)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer()
                                Chip(text: lesson.level.rawValue, color: Theme.learn)
                            }
                            .appCard()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(18)
            }
        }
        .navigationTitle(unit.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
