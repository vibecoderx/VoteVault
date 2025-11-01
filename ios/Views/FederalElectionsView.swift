//
// File: FederalElectionsView.swift
// Folder: Views
//

import SwiftUI

struct FederalElectionsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Select a Federal Election Type")
                .font(.headline)
                .foregroundColor(.secondary)
            
            NavigationLink(destination: PresidentialElectionsView()) {
                ElectionTypeRow(title: "Presidential Elections", icon: "person.fill")
            }
            
            NavigationLink(destination: HouseStatesView()) {
                ElectionTypeRow(title: "House Elections", icon: "house.fill")
            }
            
            NavigationLink(destination: SenateStatesView()) {
                ElectionTypeRow(title: "Senate Elections", icon: "building.fill")
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Federal Elections")
        .navigationBarTitleDisplayMode(.inline)
    }
}
