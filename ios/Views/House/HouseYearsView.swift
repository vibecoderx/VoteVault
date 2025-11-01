//
//  HouseYearsView.swift
//  VoteVault
//

import SwiftUI

struct HouseYearsView: View {
    let state: String
    let electionYears: [Int]

    init(state: String) {
        self.state = state
        
        let currentYear = Calendar.current.component(.year, from: Date())
        var startYear: Int
        
        if currentYear % 2 == 0 { // Even year
            startYear = currentYear + 2
        } else { // Odd year
            startYear = currentYear + 1
        }
        
        var years: [Int] = []
        for year in stride(from: startYear, to: 2015, by: -2) {
            years.append(year)
        }
        self.electionYears = years
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select an Election Cycle")
                .font(.headline)
                .foregroundColor(.secondary)
            
            ForEach(electionYears, id: \.self) { year in
                NavigationLink(destination: HouseDistrictsView(state: state, cycle: year)) {
                    ElectionTypeRow(title: "\(year) Cycle", icon: "calendar")
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(state)
        .navigationBarTitleDisplayMode(.inline)
    }
}
