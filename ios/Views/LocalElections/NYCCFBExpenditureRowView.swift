//
//  NYCCFBExpenditureRowView.swift
//  VoteVault

import SwiftUI

struct NYCCFBExpenditureRowView: View {
    let expenditure: NYCCFBExpenditure

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(expenditure.payeeName.capitalized) // Capitalize name
                    .font(.headline)
                Spacer()
                Text(formatExpenditureAmount(expenditure.expenditureAmount))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.orange) // Use orange/red for expenditures
            }

            // Use InfoRow for consistent display, handle empty strings
            InfoRow(label: "Date", value: formattedDate(expenditure.expenditureDate))
            if !expenditure.payeeLocation.isEmpty {
                 InfoRow(label: "Location", value: expenditure.payeeLocation)
            }
            if !expenditure.expenditurePurpose.isEmpty {
                 InfoRow(label: "Purpose", value: expenditure.expenditurePurpose)
            }
            // InfoRow(label: "Check #", value: expenditure.checkNumber) // Or appropriate ID label

        }
        .padding(.vertical, 6) // Add some vertical padding to each row
    }

    // Helper to format the amount string safely
    private func formatExpenditureAmount(_ amount: Double?) -> String {
        guard let amount = amount else { return "N/A" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

    // Helper to format date string (adjust format as needed based on actual API data)
    private func formattedDate(_ dateString: String) -> String {
        // Assuming format might be MM/DD/YYYY
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy" // Adjust if API format is different

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .medium
            outputFormatter.timeStyle = .none
            return outputFormatter.string(from: date)
        }
        return dateString // Return original if parsing fails
    }
}

// Preview for the Row View
struct NYCCFBExpenditureRowView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data matching the expected array structure for expenditures
        let sampleData = ["VENDOR NAME INC", "BROOKLYN, NY", "SERVICE DETAILS", "CONSULTING", "02/20/2024", "$5,000.00", "CHK101"]
        if let sampleExpenditure = NYCCFBExpenditure(data: sampleData) {
            NYCCFBExpenditureRowView(expenditure: sampleExpenditure)
                .padding()
        } else {
            Text("Failed to create sample expenditure")
        }
    }
}
