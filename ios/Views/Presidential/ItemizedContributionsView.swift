//
// File: ItemizedContributionsView.swift
// Folder: Views/Presidential
//

import SwiftUI

struct ItemizedContributionsView: View {
    let committeeId: String
    let electionYear: Int
    let candidateName: String
    let partyAffiliation: String?
    
    enum ContributorType: String, CaseIterable, Identifiable {
        case individuals = "Individuals"
        case committees = "Committees"
        var id: Self { self }
    }
    
    @State private var selectedType: ContributorType = .individuals
    @State private var individualContributions: [ItemizedContribution] = []
    @State private var nonIndividualContributions: [ItemizedContribution] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    private var partyColor: Color {
        switch partyAffiliation {
        case "DEM": return .blue
        case "REP": return .red
        case "IND": return .gray
        default: return .primary
        }
    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Itemized Contributions...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                Picker("Contributor Type", selection: $selectedType) {
                    ForEach(ContributorType.allCases) { type in
                        Text(type.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                List {
                    if selectedType == .individuals {
                        Section(header: Text("Individual Donors").font(.headline).foregroundColor(partyColor)) {
                            ForEach(individualContributions) { contribution in
                                ContributionTileView(contribution: contribution)
                            }
                        }
                    } else {
                        Section(header: Text("Commitee Donors").font(.headline).foregroundColor(partyColor)) {
                            ForEach(nonIndividualContributions) { contribution in
                                NonIndividualContributionTileView(contribution: contribution)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Top Donors")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchAllItemizedContributions()
        }
    }
    
    func getAPIKey() -> String? {
        return "pNdJTlEjNg1iF0DX5idIiwfLfV50easOc7JhXHv6"
    }
    
    func fetchAllItemizedContributions() {
        let group = DispatchGroup()
        isLoading = true
        
        fetchItemizedContributions(isIndividual: true, group: group)
        fetchItemizedContributions(isIndividual: false, group: group)
        
        group.notify(queue: .main) {
            isLoading = false
        }
    }
    
    func fetchItemizedContributions(isIndividual: Bool, group: DispatchGroup) {
        guard let apiKey = getAPIKey() else {
            errorMessage = "API Key is missing."
            return
        }
        
        let urlString = "https://api.open.fec.gov/v1/schedules/schedule_a/?sort=-contribution_receipt_amount&per_page=100&is_individual=\(isIndividual)&committee_id=\(committeeId)&api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL."
            return
        }
        
        group.enter()
        URLSession.shared.dataTask(with: url) { data, _, error in
            defer { group.leave() }
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(ItemizedContributionResponse.self, from: data)
                        let filtered = decodedResponse.results.filter {
                            guard let amount = $0.contribution_receipt_amount, amount > 0 else { return false }
                            guard let committee = $0.committee, let cycle = committee.cycle else { return false }
                            return cycle == self.electionYear
                        }
                        
                        if isIndividual {
                            self.individualContributions = filtered
                        } else {
                            self.nonIndividualContributions = filtered
                        }
                        
                    } catch {
                        self.errorMessage = "Failed to parse itemized data. Error: \(error.localizedDescription)"
                    }
                } else {
                    let errorMessageString = error?.localizedDescription ?? "An unknown error occurred."
                    self.errorMessage = "Error fetching itemized data: \(errorMessageString)"
                }
            }
        }.resume()
    }
}
