//
//  ILElectionTypesView.swift
//  VoteVault
//

import SwiftUI

struct ILElectionTypesView: View {
    let electionTypes = illinoisElectionOffices

    var body: some View {
        VStack(spacing: 20) {
            Text("Select an Election Type")
                .font(.headline)
                .foregroundColor(.secondary)

            ForEach(electionTypes, id: \.name) { office in
                NavigationLink(destination: ILElectionYearsView(office: office)) {
                    ElectionTypeRow(title: office.name, icon: "person.badge.shield.checkmark.fill")
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Illinois Elections")
        .navigationBarTitleDisplayMode(.inline)
    }
}
