//
//  NYElectionTypesView.swift
//  VoteVault
//

import SwiftUI

struct NYElectionTypesView: View {
    // Read the office names (keys) from the hardcoded data store
    let electionTypes = newYorkElectionData.keys.sorted()

    var body: some View {
        VStack(spacing: 20) {
            Text("Select an Election Type")
                .font(.headline)
                .foregroundColor(.secondary)

            ForEach(electionTypes, id: \.self) { office in
                NavigationLink(destination: NYElectionYearsView(office: office)) {
                    ElectionTypeRow(title: office, icon: "person.badge.shield.checkmark.fill")
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("New York Elections")
        .navigationBarTitleDisplayMode(.inline)
    }
}
