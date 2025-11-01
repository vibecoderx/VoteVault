//
//  SenateYearsView.swift
//  VoteVault
//

import SwiftUI


struct SenateYearsView: View {
    let state: String
    let electionYears: [Int]

    init(state: String) {
        self.state = state
        
        let currentYear = Calendar.current.component(.year, from: Date())
        var startYear: Int
        
        if currentYear % 2 == 0 {
            startYear = currentYear + 6
        } else {
            startYear = currentYear + 5
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
                NavigationLink(destination: SenateYearDetailView(state: state, cycle: year)) {
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
