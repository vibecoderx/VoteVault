//
//  NJElectionYearsView.swift
//  VoteVault
//

import SwiftUI

struct NJElectionYearsView: View {
    let office: NJOfficeInfo
    let electionYears = newJerseyElectionYears
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Select an Election Year")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                List(electionYears, id: \.self) { year in
                    NavigationLink(destination: NJCandidateListView(office: office, year: year)) {
                        ElectionTypeRow(title: "\(year) Election", icon: "calendar")
                    }
                }
                .listStyle(.plain)
            }
            .padding(.top)
        }
        .navigationTitle(office.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

