//
//  SuperPACElectionCyclesView.swift
//  VoteVault
//

import SwiftUI

struct SuperPACElectionCyclesView: View {
    let electionYears: [Int]

    init() {
        var years: [Int] = []
        for year in stride(from: 2030, to: 1973, by: -2) {
            years.append(year)
        }
        self.electionYears = years
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select an Election Cycle")
                .font(.headline)
                .foregroundColor(.secondary)
            
            List(electionYears, id: \.self) { year in
                NavigationLink(destination: TopSuperPACExpendituresView(cycle: year)) {
                    ElectionTypeRow(title: "\(year) Cycle", icon: "calendar")
                }
            }
            .listStyle(.plain)
        }
        .padding(.top)
        .navigationTitle("Super PAC Expenditures")
        .navigationBarTitleDisplayMode(.inline)
    }
}

