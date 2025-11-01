//
//  ILCandidateTileView.swift
//  VoteVault
//

import SwiftUI

struct ILCandidateTileView: View {
    let candidate: ILCandidate

    private var backgroundColor: Color {
        switch candidate.politicalParty {
        case "Democratic":
            return Color.blue
        case "Republican":
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
                Text("\(candidate.firstName) \(candidate.lastName)")
                    .font(.title2).bold()
                Text(candidate.politicalParty)
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
