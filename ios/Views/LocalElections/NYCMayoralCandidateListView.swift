import SwiftUI

struct NYCMayoralCandidateListView: View {
    let year: Int
    // Fetch candidates for the selected year from the data store
    var candidates: [NYCMayoralCandidate] {
        getNYCMayoralCandidates(for: year)
    }

    var body: some View {
        VStack {
            if candidates.isEmpty {
                // Specific message for 2025 or general no data
                Text(year == 2025 ? "Candidates for 2025 may not have fully registered yet." : "No candidate data found for this year.")
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
            } else {
                List(candidates) { candidate in
                    NavigationLink(destination: NYCMayoralCandidateDetailView(candidate: candidate, year: year)) {
                        NYCMayoralCandidateTileView(candidate: candidate)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("\(year) Mayoral Race")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Add a preview for testing
struct NYCMayoralCandidateListView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with a sample year that has data
        NYCMayoralCandidateListView(year: 2021)
    }
}
