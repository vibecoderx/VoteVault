//
//  NYCandidateListView.swift
//  VoteVault
//

import SwiftUI

struct NYCandidateListView: View {
    let office: String
    let year: Int

    private var candidates: [NYCandidateInfo] {
        return newYorkElectionData[office]?[year] ?? []
    }

    var body: some View {
        VStack {
            if candidates.isEmpty {
                Text("No candidates found for this selection.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List(candidates, id: \.name) { candidate in
                    NavigationLink(destination: NYCandidateDetailView(candidate: candidate, year: year)) {
                        NYCandidateTileView(candidate: candidate)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("\(year) \(office) Race")
        .navigationBarTitleDisplayMode(.inline)
    }
}
