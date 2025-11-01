//
//  StateSelectionView.swift
//  VoteVault
//

import SwiftUI

struct StateSelectionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Select a State")
                .font(.headline)
                .foregroundColor(.secondary)
           
            /* Illinois state view is being disabled for now until
             a clear approach is figured out.
             
            NavigationLink(destination: ILElectionTypesView()) {
                ElectionTypeRow(title: "Illinois", icon: "map.fill")
            }
             */
            
            NavigationLink(destination: NJElectionTypesView()) {
                ElectionTypeRow(title: "New Jersey", icon: "map.fill")
            }
            
            NavigationLink(destination: NYElectionTypesView()) {
                ElectionTypeRow(title: "New York", icon: "map.fill")
            }

            NavigationLink(destination: WAElectionTypesView()) {
                ElectionTypeRow(title: "Washington", icon: "map.fill")
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("State Elections")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StateSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        StateSelectionView()
    }
}

