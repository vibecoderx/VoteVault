//
//  NYCMayoralCandidateTileView.swift
//  VoteVault

import SwiftUI

struct NYCMayoralCandidateTileView: View {
    let candidate: NYCMayoralCandidate

    // Determine color based on party string
    private var backgroundColor: Color {
        let partyLower = candidate.party.lowercased()
        if partyLower.contains("democrat") {
            return Color.blue
        } else if partyLower.contains("republican") {
            return Color.red
        } else if partyLower.contains("independent") || partyLower.contains("reform") {
            return Color.gray
        } else {
            return Color(UIColor.lightGray) // Default
        }
    }

    private var textColor: Color {
        return .white // White text generally works well on colored backgrounds
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(candidate.name)
                    .font(.title2).bold()
                Text(candidate.party)
                    .font(.subheadline)
                 Text("CFB ID: \(candidate.id)") // Display Candidate ID
                     .font(.caption)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(8)
            .padding(.top, -8)       // Adjust padding to make background fill nicely
            .padding(.horizontal, -12) // Adjust padding
        }
        .padding(.vertical) // Add vertical padding to the outer VStack
    }
}

// Add a preview for testing
struct NYCMayoralCandidateTileView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample candidate for preview
        let sampleCandidate = NYCMayoralCandidate(id: "1437", name: "Eric L. Adams", party: "Democrat")
        NYCMayoralCandidateTileView(candidate: sampleCandidate)
            .padding() // Add padding to the preview itself for better visibility
    }
}
