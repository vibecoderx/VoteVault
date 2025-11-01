//
//  SFCandidateListView.swift
//  VoteVault
//


import SwiftUI

struct SFCandidateListView: View {
    let year: String
    // Fetch candidates for the selected year from the data store
    let candidates: [SFMayoralCandidate]

    init(year: String) {
        self.year = year
        self.candidates = getSFMayoralCandidates(for: year)
    }

    var body: some View {
        VStack {
            if candidates.isEmpty {
                Text("No mayoral candidates found for \(year).")
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
            } else {
                List(candidates) { candidate in
                    NavigationLink(destination: SFCandidateDetailView(candidate: candidate, year: year)) {
                        SFCandidateTileView(candidate: candidate)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("\(year) Mayoral Race")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SFCandidateListView_Previews: PreviewProvider {
    static var previews: some View {
        SFCandidateListView(year: "2024")
    }
}
