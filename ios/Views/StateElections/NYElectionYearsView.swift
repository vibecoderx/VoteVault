//
//  NYElectionYearsView.swift
//  VoteVault
//

import SwiftUI

struct NYElectionYearsView: View {
    let office: String
    
    // Get the years for the selected office and sort them in descending order
    private var electionYears: [Int] {
        if let years = newYorkElectionData[office]?.keys {
            return years.sorted(by: >)
        }
        return []
    }
    
    var body: some View {
        VStack {
            if electionYears.isEmpty {
                Text("No election data found for this office.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                VStack(spacing: 20) {
                    Text("Select an Election Year")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    List(electionYears, id: \.self) { year in
                        NavigationLink(destination: NYCandidateListView(office: office, year: year)) {
                            ElectionTypeRow(title: "\(year) Election", icon: "calendar")
                        }
                    }
                    .listStyle(.plain)
                }
                .padding(.top)
            }
        }
        .navigationTitle(office)
        .navigationBarTitleDisplayMode(.inline)
    }
}
