//
//  NYCCFBContributionRowView.swift
//  VoteVault

import SwiftUI

struct NYCCFBContributionRowView: View {
    let contribution: NYCCFBContribution

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(contribution.contributorName.capitalized) // Capitalize name
                    .font(.headline)
                Spacer()
                Text(formatContributionAmount(contribution.contributionAmount))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green) // Use green for contributions
            }

            // Use InfoRow for consistent display, handle empty strings
            InfoRow(label: "Date", value: formattedDate(contribution.contributionDate))
            if !contribution.contributorLocation.isEmpty {
                InfoRow(label: "Location", value: contribution.contributorLocation)
            }
            // MODIFIED: Apply cleaning function to employerOccupation
            let cleanedEmployerOcc = cleanEmployerOccupation(contribution.employerOccupation)
            if !cleanedEmployerOcc.isEmpty {
                 InfoRow(label: "Employer/Occ", value: cleanedEmployerOcc)
            }
            // InfoRow(label: "Receipt ID", value: contribution.receiptId) // Still commented out

        }
        .padding(.vertical, 6) // Add some vertical padding to each row
    }

    // Helper to format the amount string safely
    private func formatContributionAmount(_ amount: Double?) -> String {
        guard let amount = amount else { return "N/A" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

    // Helper to format date string (adjust format as needed based on actual API data)
    private func formattedDate(_ dateString: String) -> String {
        // Assuming format might be MM/DD/YYYY, attempt to parse and reformat
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

    // NEW: Helper function to clean the Employer/Occupation string
    private func cleanEmployerOccupation(_ text: String) -> String {
        var cleanedText = text
        // Remove prefixes (case-insensitive) and trim whitespace
        cleanedText = cleanedText.replacingOccurrences(of: "Employer:", with: "", options: .caseInsensitive)
        cleanedText = cleanedText.replacingOccurrences(of: "Occupation:", with: "", options: .caseInsensitive)
        // Optionally, replace multiple spaces that might result from removal with a single space
        cleanedText = cleanedText.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        return cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// Preview for the Row View
struct NYCCFBContributionRowView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data matching the expected array structure
        let sampleData = ["JOHN DOE", "NEW YORK, NY", "RECIPIENT INFO", "Employer: ACME Corp Occupation: Engineer", "01/15/2021", "$100.00", "R12345"]
        if let sampleContribution = NYCCFBContribution(data: sampleData) {
            NYCCFBContributionRowView(contribution: sampleContribution)
                .padding()
        } else {
            Text("Failed to create sample contribution")
        }
    }
}

