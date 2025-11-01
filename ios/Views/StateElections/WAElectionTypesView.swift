//
//  WAElectionTypesView.swift
//  VoteVault

import SwiftUI

struct WAElectionTypesView: View {
    // MODIFIED: Use a tuple to pair the user-friendly display name
    // with the exact, all-caps name required by the API.
    let electionTypes: [(displayName: String, apiName: String)] = [
        ("Attorney General", "ATTORNEY GENERAL"),
        ("Governor", "GOVERNOR"),
        ("Lieutenant Governor", "LIEUTENANT GOVERNOR"),
        ("State Representative", "STATE REPRESENTATIVE"),
        ("State Senator", "STATE SENATOR"),
        ("Secretary of State", "SECRETARY OF STATE")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select an Election Type")
                .font(.headline)
                .foregroundColor(.secondary)
            
            ForEach(electionTypes, id: \.displayName) { electionType in
                // Pass the correct apiName to the next view
                NavigationLink(destination: WAElectionYearsView(office: electionType.apiName)) {
                    // Display the user-friendly displayName
                    ElectionTypeRow(title: electionType.displayName, icon: "person.badge.shield.checkmark.fill")
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Washington Elections")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WAElectionTypesView_Previews: PreviewProvider {
    static var previews: some View {
        WAElectionTypesView()
    }
}

