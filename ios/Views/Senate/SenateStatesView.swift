//
//  SenateStatesView.swift
//  VoteVault
//

import SwiftUI

// MARK: - Senate Views
struct SenateStatesView: View {
    let states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]

    var body: some View {
        List(states, id: \.self) { state in
            NavigationLink(destination: SenateYearsView(state: state)) {
                Text(state)
            }
        }
        .navigationTitle("Select a State")
        .navigationBarTitleDisplayMode(.inline)
    }
}
