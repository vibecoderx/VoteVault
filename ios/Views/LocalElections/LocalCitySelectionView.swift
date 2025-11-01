//
//  LocalCitySelectionView.swift
//  VoteVault
//

import SwiftUI

struct LocalCitySelectionView: View {
    let cities: [(name: String, destination: AnyView)] = [
        ("New York City, NY", AnyView(NYCMayoralElectionYearsView())),
        ("San Francisco, CA", AnyView(SFElectionYearsView()))
        // Add more cities here as they are implemented
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Select a City")
                .font(.headline)
                .foregroundColor(.secondary)

            // Use ForEach to create the list of cities
            ForEach(cities, id: \.name) { city in
                NavigationLink(destination: city.destination) {
                    ElectionTypeRow(title: city.name, icon: "building.2.fill")
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Local Elections")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LocalCitySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LocalCitySelectionView()
    }
}

