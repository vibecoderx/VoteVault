//
//  NJElectionTypesView.swift
//  VoteVault
//

import SwiftUI

struct NJElectionTypesView: View {
    let electionTypes = newJerseyElectionData

    var body: some View {
        VStack(spacing: 20) {
            Text("Select an Election Type")
                .font(.headline)
                .foregroundColor(.secondary)

            ForEach(electionTypes, id: \.name) { office in
                NavigationLink(destination: NJElectionYearsView(office: office)) {
                    ElectionTypeRow(title: office.name, icon: "person.badge.shield.checkmark.fill")
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("New Jersey Elections")
        .navigationBarTitleDisplayMode(.inline)
    }
}
