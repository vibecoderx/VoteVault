//
// File: PresidentialElectionsView.swift
// Folder: Views/Presidential
//

import SwiftUI

struct PresidentialElectionsView: View {
    let electionYears = ["2024", "2020", "2016", "2012", "2008"]
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Select an Election Year")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                ForEach(electionYears, id: \.self) { year in
                    NavigationLink(destination: PresidentialYearDetailView(electionYear: year)) {
                        ElectionTypeRow(title: "\(year) Elections", icon: "calendar")
                    }
                }
                
                Spacer()
            }
            .padding()
            
            Text("Presidential elections finance data for years 2004 and prior is not available in this app.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .navigationTitle("Presidential")
        .navigationBarTitleDisplayMode(.inline)
    }
}
