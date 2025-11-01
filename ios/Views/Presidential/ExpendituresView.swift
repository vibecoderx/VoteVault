//
// File: ExpendituresView.swift
// Folder: Views/Presidential
//

import SwiftUI

struct ExpendituresView: View {
    let committeeId: String
    let electionYear: Int
    let candidateName: String
    
    enum ExpenditureType: String, CaseIterable, Identifiable {
        case byAmount = "By Amount"
        case byPurpose = "By Purpose (Agg.)"
        case byRecipient = "By Recipient (Agg.)"
        var id: Self { self }
    }
    
    @State private var selectedType: ExpenditureType = .byAmount
    @State private var expenditures: [ItemizedDisbursement] = []
    @State private var expendituresByPurpose: [ExpenditureByPurpose] = []
    @State private var expendituresByRecipient: [ExpenditureByRecipient] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            Picker("Expenditure Type", selection: $selectedType) {
                ForEach(ExpenditureType.allCases) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            if isLoading {
                ProgressView("Fetching Expenditures...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red).padding()
            } else {
                if selectedType == .byAmount {
                    List {
                        ForEach(expenditures) { expenditure in
                            ExpenditureTileView(disbursement: expenditure)
                        }
                    }
                } else if selectedType == .byPurpose {
                    List {
                        ForEach(expendituresByPurpose) { item in
                            HStack {
                                Text(item.purpose)
                                Spacer()
                                Text(formatCurrencyShorthand(item.total))
                            }
                        }
                    }
                } else if selectedType == .byRecipient {
                    List {
                        ForEach(expendituresByRecipient) { item in
                            RecipientExpenditureTileView(recipientData: item)
                        }
                    }
                }
            }
        }
        .navigationTitle("Top Expenditures")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchInitialData()
        }
        .onChange(of: selectedType) {
            fetchDataForCurrentTab()
        }
    }

    func getAPIKey() -> String? {
        return "pNdJTlEjNg1iF0DX5idIiwfLfV50easOc7JhXHv6"
    }

    func fetchInitialData() {
        // Fetch data for the default tab on first appearance
        fetchDataForCurrentTab()
    }
    
    func fetchDataForCurrentTab() {
        // Fetch data when the tab changes
        switch selectedType {
        case .byAmount:
            if expenditures.isEmpty { fetchExpendituresByAmount() }
        case .byPurpose:
            if expendituresByPurpose.isEmpty { fetchExpendituresByPurpose() }
        case .byRecipient:
            if expendituresByRecipient.isEmpty { fetchExpendituresByRecipient() }
        }
    }

    func fetchExpendituresByAmount() {
        isLoading = true
        errorMessage = nil
        
        guard let apiKey = getAPIKey() else {
            errorMessage = "API Key is missing."
            isLoading = false
            return
        }

        let urlString = "https://api.open.fec.gov/v1/schedules/schedule_b/?sort=-disbursement_amount&per_page=100&committee_id=\(committeeId)&api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(ItemizedDisbursementResponse.self, from: data)
                        self.expenditures = decodedResponse.results.filter {
                            guard let committee = $0.committee, let cycle = committee.cycle else { return false }
                            return cycle == self.electionYear
                        }
                    } catch {
                        self.errorMessage = "Failed to parse expenditure data. Error: \(error.localizedDescription)"
                    }
                } else {
                    let errorMessageString = error?.localizedDescription ?? "An unknown error occurred."
                    self.errorMessage = "Error fetching expenditure data: \(errorMessageString)"
                }
            }
        }.resume()
    }
    
    func fetchExpendituresByPurpose() {
        isLoading = true
        errorMessage = nil
        
        guard let apiKey = getAPIKey() else {
            errorMessage = "API Key is missing."
            isLoading = false
            return
        }
        
        let urlString = "https://api.open.fec.gov/v1/schedules/schedule_b/by_purpose/?sort=-total&per_page=50&committee_id=\(committeeId)&cycle=\(electionYear)&api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(ExpenditureByPurposeResponse.self, from: data)
                        self.expendituresByPurpose = decodedResponse.results
                    } catch {
                        self.errorMessage = "Failed to parse expenditure data. Error: \(error.localizedDescription)"
                    }
                } else {
                    let errorMessageString = error?.localizedDescription ?? "An unknown error occurred."
                    self.errorMessage = "Error fetching expenditure data: \(errorMessageString)"
                }
            }
        }.resume()
    }
    
    func fetchExpendituresByRecipient() {
        isLoading = true
        errorMessage = nil
        
        guard let apiKey = getAPIKey() else {
            errorMessage = "API Key is missing."
            isLoading = false
            return
        }
        
        let urlString = "https://api.open.fec.gov/v1/schedules/schedule_b/by_recipient/?sort=-total&per_page=50&committee_id=\(committeeId)&cycle=\(electionYear)&api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(ExpenditureByRecipientResponse.self, from: data)
                        self.expendituresByRecipient = decodedResponse.results
                    } catch {
                        self.errorMessage = "Failed to parse expenditure data. Error: \(error.localizedDescription)"
                    }
                } else {
                    let errorMessageString = error?.localizedDescription ?? "An unknown error occurred."
                    self.errorMessage = "Error fetching expenditure data: \(errorMessageString)"
                }
            }
        }.resume()
    }
}

