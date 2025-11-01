//
//  WACandidateTileView.swift
//  VoteVault
//

import SwiftUI

struct WACandidateTileView: View {
    let candidate: WACandidate

    private var backgroundColor: Color {
        switch candidate.party {
        case "DEMOCRATIC":
            return Color.blue
        case "REPUBLICAN":
            return Color.red
        default:
            return Color(UIColor.lightGray)
        }
    }
    
    private var textColor: Color {
        if ["DEMOCRATIC", "REPUBLICAN"].contains(candidate.party) {
            return .white
        }
        return .primary
    }

    private var formattedName: String {
        let name = candidate.filer_name
        if let range = name.range(of: "(") {
            return String(name[..<range.lowerBound]).trimmingCharacters(in: .whitespaces).capitalized
        }
        return name.capitalized
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedName)
                    .font(.title2).bold()
                Text("Filer ID: " + candidate.filer_id)
                    // .font(.footnote)
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

