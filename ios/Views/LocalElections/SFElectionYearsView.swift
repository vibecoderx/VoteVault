//
//  SFElectionYearsView.swift
//  VoteVault
//

import SwiftUI

struct SFElectionYearsView: View {
    // Fetch years from the SF data store
    let electionYears = getSFMayoralElectionYears() // Returns [String]

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Select an Election Year")
                    .font(.headline)
                    .foregroundColor(.secondary)

                if electionYears.isEmpty {
                    Text("No election data found.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List(electionYears, id: \.self) { year in
                        NavigationLink(destination: SFCandidateListView(year: year)) {
                            ElectionTypeRow(title: "\(year) Election", icon: "calendar")
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding(.top)
        }
        .navigationTitle("SF Mayoral Elections")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SFElectionYearsView_Previews: PreviewProvider {
    static var previews: some View {
        SFElectionYearsView()
    }
}
