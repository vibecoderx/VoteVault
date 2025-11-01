//
//  HouseCandidateDetailView.swift
//  VoteVault
//


import SwiftUI

struct HouseCandidateDetailView: View {
    let candidate: ElectionSummary
    let electionYear: Int

    @State private var contributionsBySize: [SenateContributionBySize] = []
    @State private var contributionsByState: [SenateContributionByState] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    private var partyColor: Color {
        switch candidate.party_full {
        case "DEMOCRATIC PARTY": return .blue
        case "REPUBLICAN PARTY": return .red
        default: return .gray
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
                                
                                Text(formatCurrency(contribution.total ?? 0))
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical, 4)
                        }
                    }
      
                    Section {
                        NavigationLink(destination: ItemizedContributionsView(committeeId: candidate.candidate_pcc_id ?? "", electionYear: electionYear, candidateName: candidate.candidate_name ?? "Details", partyAffiliation: candidate.party_full)) {
                            Text("Top Donors...")
                                .fontWeight(.bold)
                                .foregroundColor(partyColor)
                        }
                        
                        NavigationLink(destination: ExpendituresView(committeeId: candidate.candidate_pcc_id ?? "", electionYear: electionYear, candidateName: candidate.candidate_name ?? "Details")) {
                            Text("Top Expenditures...")
                                .fontWeight(.bold)
                                .foregroundColor(partyColor)
                        }

                        NavigationLink(destination: SuperPACView(candidateId: candidate.candidate_id, electionYear: electionYear)) {
                            Text("Super PACs Expenditures...")
                                .fontWeight(.bold)
                                .foregroundColor(partyColor)
                        }
                    }

                    Section(header: Text("Contributions by State").font(.headline).foregroundColor(partyColor)) {
                        ForEach(contributionsByState) { stateContribution in
                            HStack {
                                Text(stateContribution.state)
                                Spacer()
                                Text(formatCurrency(stateContribution.total))
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("\(candidate.candidate_name ?? "Details") (\(electionYear))")
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
        
        let sortKey = endpoint == "by_size" ? "-size" : "-total"
        
        let urlString = "https://api.open.fec.gov/v1/schedules/schedule_a/\(endpoint)/?cycle=\(electionYear)&committee_id=\(candidate.candidate_pcc_id ?? "")&sort=\(sortKey)&per_page=60&api_key=\(apiKey)"
        
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
                        if endpoint.contains("by_size") {
                            let decodedResponse = try JSONDecoder().decode(SenateContributionBySizeResponse.self, from: data)
                            self.contributionsBySize = decodedResponse.results
                        } else { // by_state
                            let decodedResponse = try JSONDecoder().decode(SenateContributionByStateResponse.self, from: data)
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
