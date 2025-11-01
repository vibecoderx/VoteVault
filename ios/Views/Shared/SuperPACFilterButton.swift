//
//  SuperPACFilterButton.swift
//  VoteVault
//

import SwiftUI

// MARK: - Super PAC Filter Button (New)
struct SuperPACFilterButton: View {
    let title: String
    let type: SuperPACView.SupportType
    @Binding var selection: SuperPACView.SupportType
    
    var isSelected: Bool {
        selection == type
    }
    
    var backgroundColor: Color {
        if !isSelected { return .clear }
        return type == .supporting ? .green : .orange
    }
    
    var foregroundColor: Color {
        if isSelected { return .white }
        return type == .supporting ? .green : .orange
    }
    
    var borderColor: Color {
        return type == .supporting ? .green : .orange
    }
    
    var body: some View {
        Button(action: {
            selection = type
        }) {
            Text(title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: 2)
                )
        }
    }
}
