//
//  FilterButton.swift
//  VoteVault
//

import SwiftUI

struct FilterButton: View {
    let title: String
    let party: String
    @Binding var selection: String?

    var isSelected: Bool {
        selection == party
    }
    
    private var partyColor: Color {
        // Standardized on short party codes for consistency
        switch party {
        case "DEM", "DEMOCRATIC", "DEMOCRAT": return .blue
        case "REP", "REPUBLICAN": return .red
        case "IND", "OTHER", "INDEPENDENT": return .gray
        default: return .primary
        }
    }

    var body: some View {
        Button(action: {
            if isSelected {
                selection = nil
            } else {
                selection = party
            }
        }) {
            Text(title)
                .fontWeight(.bold)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .background(isSelected ? partyColor : Color.clear)
                .foregroundColor(isSelected ? .white : partyColor)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(partyColor, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle()) // Prevent Button from inheriting List's tap behavior, if placed inside a list
    }
}

