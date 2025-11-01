//
//  NYCMayoralElectionYearsView.swift
//  VoteVault

import SwiftUI

struct NYCMayoralElectionYearsView: View {
    // Fetch years from the data store
    let electionYears = getNYCMayoralElectionYears()

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Select an Election Year")
                    .font(.headline)
                    .foregroundColor(.secondary)

                List(electionYears, id: \.self) { year in
                    NavigationLink(destination: NYCMayoralCandidateListView(year: year)) {
                        ElectionTypeRow(title: "\(year) Election", icon: "calendar")
                    }
                }
                .listStyle(.plain)
            }
            .padding(.top)
        }
        .navigationTitle("NYC Mayoral Elections")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NYCMayoralElectionYearsView_Previews: PreviewProvider {
    static var previews: some View {
        NYCMayoralElectionYearsView()
    }
}
