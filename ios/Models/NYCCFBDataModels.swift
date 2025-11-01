import Foundation

// MARK: - NYC CFB API Response Structures

// Represents the overall JSON structure for Contributions
struct NYCCFBContributionResponse: Codable {
    let iTotalAmount: Double
    let aaData: [[String]] // Array of arrays, where each inner array is a contribution row
}

// Represents the overall JSON structure for Expenditures (Same structure, different endpoint)
struct NYCCFBExpenditureResponse: Codable {
    let iTotalAmount: Double
    let aaData: [[String]] // Array of arrays, where each inner array is an expenditure row
}


// MARK: - NYC CFB Data Item Structures

// Represents a single contribution parsed from the API response
struct NYCCFBContribution: Identifiable {
    let id: String // Use Receipt ID for uniqueness
    let contributorName: String
    let contributorLocation: String
    // let recipientDetails: String // Field exists but is ignored as requested
    let employerOccupation: String
    let contributionDate: String
    let contributionAmountString: String
    let receiptId: String

    // Computed property to safely convert amount string to Double
    var contributionAmount: Double? {
        // Remove characters like '$', ',', etc., before converting
        let cleanedAmount = contributionAmountString
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(cleanedAmount)
    }

    // Initializer maps from the string array and strips HTML
    init?(data: [String]) {
        guard data.count >= 7 else { return nil } // Ensure array has enough elements

        // Strip potential HTML tags from string fields
        self.contributorName = stripHTMLTags(from: data[0])
        self.contributorLocation = stripHTMLTags(from: data[1])
        // self.recipientDetails = stripHTMLTags(from: data[2]) // Ignored
        self.employerOccupation = stripHTMLTags(from: data[3])
        self.contributionDate = stripHTMLTags(from: data[4])
        self.contributionAmountString = stripHTMLTags(from: data[5])
        self.receiptId = stripHTMLTags(from: data[6])
        self.id = self.receiptId // Use cleaned receiptId as the stable Identifier
    }
}

// NEW: Represents a single expenditure parsed from the API response
struct NYCCFBExpenditure: Identifiable {
    let id: String
    let payeeName: String
    let payeeLocation: String
    // let recipientName: String // Ignore, always the name of the candidate
    let expenditureDate: String
    let expenditureAmountString: String
    let expenditurePurpose: String
    let checkNumber: String

    // Computed property to safely convert amount string to Double
    var expenditureAmount: Double? {
        let cleanedAmount = expenditureAmountString
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(cleanedAmount)
    }

    // Initializer maps from the string array and strips HTML
    init?(data: [String]) {
        guard data.count >= 7 else { return nil }

        self.payeeName = stripHTMLTags(from: data[0])
        self.payeeLocation = stripHTMLTags(from: data[1])
        // Index 2 ignored for now
        self.expenditureDate = stripHTMLTags(from: data[3])
        self.expenditureAmountString = stripHTMLTags(from: data[4])
        self.expenditurePurpose = stripHTMLTags(from: data[5])
        self.checkNumber = stripHTMLTags(from: data[6])
        self.id = self.checkNumber + self.expenditureDate + self.expenditureAmountString // Create a composite ID
    }
}


// MARK: - Helper Function to Strip HTML Tags

// Uses regular expression to remove HTML tags from a string
private func stripHTMLTags(from string: String) -> String {
    // Regular expression to match HTML tags (e.g., <...> or </...>)
    let pattern = "<[^>]+>"
    // Replace occurrences of the pattern with an empty string
    return string.replacingOccurrences(of: pattern, with: "", options: .regularExpression, range: nil)
}

