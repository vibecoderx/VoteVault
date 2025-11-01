//
//  ILElectionYearsView.swift
//  VoteVault
//

import SwiftUI

struct ILElectionYearsView: View {
    let office: ILElectionOffice
    
    // Generate a list of recent election years
    private var electionYears: [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array(stride(from: currentYear, to: 2000, by: -1))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select an Election Year")
                .font(.headline)
                .foregroundColor(.secondary)
            
            List(electionYears, id: \.self) { year in
                NavigationLink(destination: ILCandidateListView(office: office, year: year)) {
                    ElectionTypeRow(title: "\(year) Election", icon: "calendar")
                }
            }
            .listStyle(.plain)
        }
        .padding(.top)
        .navigationTitle(office.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
