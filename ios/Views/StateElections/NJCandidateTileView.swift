//
//  NJCandidateTileView.swift
//  VoteVault
//

import SwiftUI

struct NJCandidateTileView: View {
    let candidate: NJCandidate

    private var backgroundColor: Color {
        switch candidate.PARTY.uppercased() {
        case "DEMOCRAT":
            return Color.blue
        case "REPUBLICAN":
            return Color.red
        default:
            return Color(UIColor.lightGray)
        }
    }
    
    private var textColor: Color {
        return .white
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(candidate.ENTITYNAME)
                    .font(.title2).bold()
                Text(candidate.ENTITY_S)
                    .font(.subheadline)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(8)
            .padding(.top, -8)
            .padding(.horizontal, -12)
        }
        .padding(.vertical)
    }
}

