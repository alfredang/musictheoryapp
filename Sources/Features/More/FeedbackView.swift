import SwiftUI

struct FeedbackView: View {
    private let whatsAppNumber = "6588666375"   // +65 8866 6375, no "+"/spaces
    @State private var title = ""
    @State private var message = ""

    private var canSend: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("We'd love your feedback")
                        .font(.title3.weight(.semibold)).foregroundStyle(Theme.ink)
                    Text("Found a mistake, or have an idea to make Music Theory Maestro better? Send us a note.")
                        .font(.subheadline).foregroundStyle(Theme.mutedInk)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("TITLE").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        TextField("e.g. Suggestion for Grade 5", text: $title)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("MESSAGE").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        ZStack(alignment: .topLeading) {
                            if message.isEmpty {
                                Text("Your message…").foregroundStyle(Theme.mutedInk)
                                    .padding(16)
                            }
                            TextEditor(text: $message)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 160)
                                .padding(8)
                        }
                        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12))
                    }

                    Button(action: send) {
                        Label("Send via WhatsApp", systemImage: "paperplane.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent).tint(Theme.primary)
                    .disabled(!canSend)
                }
                .padding(20)
            }
        }
        .navigationTitle("Feedback")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func send() {
        var text = ""
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let m = message.trimmingCharacters(in: .whitespacesAndNewlines)
        if !t.isEmpty { text += "*\(t)*\n" }
        text += m
        var comps = URLComponents()
        comps.scheme = "https"; comps.host = "wa.me"; comps.path = "/\(whatsAppNumber)"
        comps.queryItems = [URLQueryItem(name: "text", value: text)]
        if let url = comps.url { UIApplication.shared.open(url) }
    }
}
