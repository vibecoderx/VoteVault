//
// File: CandidateDetailView.swift
// Folder: Views/Presidential
//

import SwiftUI

struct CandidateDetailView: View {
    let summary: PresidentialFinancialSummary
    let electionYear: String

    @State private var contributionsBySize: [ContributionBySize] = []
    @State private var contributionsByState: [ContributionByState] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    private var partyColor: Color {
        switch summary.candidate_party_affiliation {
        case "DEM": return .blue
        case "REP": return .red
        case "IND": return .gray
        default: return .primary
        }
    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching contribution data...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red).padding()
            } else {
                List {
                    Section(header: Text("Contributions by Size").font(.headline).foregroundColor(partyColor)) {
                        ForEach(contributionsBySize) { contribution in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(sizeDescription(for: contribution.size))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(formatCurrency(contribution.contribution_receipt_amount))
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical, 4)
                        }
                    }
      
                    Section {
                        NavigationLink(destination: ItemizedContributionsView(committeeId: summary.committee_id ?? "", electionYear: Int(electionYear) ?? 0, candidateName: summary.candidate_name ?? "Details", partyAffiliation: summary.candidate_party_affiliation)) {
                            Text("Top Donors...")
                                .fontWeight(.bold)
                                .foregroundColor(partyColor)
                        }
                        
                        NavigationLink(destination: ExpendituresView(committeeId: summary.committee_id ?? "", electionYear: Int(electionYear) ?? 0, candidateName: summary.candidate_name ?? "Details")) {
                            Text("Top Expenditures...")
                                .fontWeight(.bold)
                                .foregroundColor(partyColor)
                        }

                        NavigationLink(destination: SuperPACView(candidateId: summary.candidate_id, electionYear: Int(electionYear) ?? 0)) {
                            Text("Super PACs Expenditures...")
                                .fontWeight(.bold)
                                .foregroundColor(partyColor)
                        }
                    }

                    Section(header: Text("Contributions by State").font(.headline).foregroundColor(partyColor)) {
                        ForEach(contributionsByState) { stateContribution in
                            HStack {
                                Text(stateContribution.contribution_state)
                                Spacer()
                                Text(formatCurrency(stateContribution.contribution_receipt_amount))
                            }
                        }
                    }

                }
            }
        }
        .navigationTitle("\(summary.candidate_name ?? "Details") (\(electionYear))")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchAllContributionData()
        }
    }

    func getAPIKey() -> String? {
        return "pNdJTlEjNg1iF0DX5idIiwfLfV50easOc7JhXHv6"
    }

    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    private func sizeDescription(for size: Int) -> String {
        switch size {
        case 0: return "Sum of all contributions where individual contribution was $200 or less"
        case 200: return "Sum of all contributions where individual contribution was greater than $200"
        case 500: return "Sum of all contributions where individual contribution was greater than $500"
        case 1000: return "Sum of all contributions where individual contribution was greater than $1000"
        case 2000: return "Sum of all contributions where individual contribution was greater than $2000"
        default: return "Sum of contributions"
        }
    }

    func fetchAllContributionData() {
        isLoading = true
        let group = DispatchGroup()
        
        fetchContributionData(from: "by_size", group: group)
        fetchContributionData(from: "by_state", group: group)
        
        group.notify(queue: .main) {
            isLoading = false
        }
    }

    func fetchContributionData(from endpoint: String, group: DispatchGroup) {
        guard let apiKey = getAPIKey() else {
            errorMessage = "Error: API Key is missing."
            return
        }
        
        let sortKey = endpoint == "by_size" ? "-size" : "-contribution_receipt_amount"
        let urlString = "https://api.open.fec.gov/v1/presidential/contributions/\(endpoint)/?sort=\(sortKey)&page=1&election_year=\(electionYear)&candidate_id=\(summary.candidate_id)&per_page=60&api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Error: Invalid URL for \(endpoint)."
            return
        }

        group.enter()
        URLSession.shared.dataTask(with: url) { data, _, error in
            defer { group.leave() }
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        if endpoint == "by_size" {
                            let decodedResponse = try JSONDecoder().decode(ContributionBySizeResponse.self, from: data)
                            self.contributionsBySize = decodedResponse.results
                        } else { // by_state
                            let decodedResponse = try JSONDecoder().decode(ContributionByStateResponse.self, from: data)
                            self.contributionsByState = decodedResponse.results
                        }
                    } catch {
                        self.errorMessage = "Error parsing \(endpoint) JSON: \(error.localizedDescription)"
                    }
                } else {
                    let errorMessageString = error?.localizedDescription ?? "An unknown network error occurred."
                    self.errorMessage = "Error fetching \(endpoint) data: \(errorMessageString)"
                }
            }
        }.resume()
    }
}
