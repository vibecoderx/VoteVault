//
//  NJCandidateDetailView.swift
//  VoteVault
//

import SwiftUI

struct NJCandidateDetailView: View {
    let candidate: NJCandidate
    let year: Int

    // Contribution States
    @State private var totalContributions: Double? = nil
    @State private var topContributors: [NJContributorTotalResponse] = []
    @State private var isLoadingContributions = true
    @State private var contributionError: String?

    // Expenditure States (New)
    @State private var totalExpenditures: Double? = nil
    @State private var topPayees: [NJPayeeTotalResponse] = []
    @State private var isLoadingExpenditures = true
    @State private var expenditureError: String?

    // General States
    @State private var selectedTab = 0
    @State private var initialLoadComplete = false // Track initial load

    var body: some View {
        VStack {
            Picker("Data", selection: $selectedTab) {
                Text("Contributions").tag(0)
                Text("Expenditures").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal) // Apply padding only horizontally for the picker

            // Use GeometryReader or Spacer to manage space better if needed
            Group { // Group content to apply loading/error logic consistently
                if selectedTab == 0 {
                    // --- Contributions View ---
                    if isLoadingContributions {
                        ProgressView("Fetching Contribution Details...")
                            .padding(.top) // Add padding to center ProgressView a bit
                    } else if let error = contributionError {
                        Text(error).foregroundColor(.red).padding()
                    } else {
                        contributionListView
                    }
                } else {
                    // --- Expenditures View ---
                    if isLoadingExpenditures {
                        ProgressView("Fetching Expenditure Details...")
                            .padding(.top)
                    } else if let error = expenditureError {
                        Text(error).foregroundColor(.red).padding()
                    } else {
                        expenditureListView
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Allow content to expand
        }
        .navigationTitle(candidate.ENTITYNAME)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Fetch data for the initially selected tab only once
            if !initialLoadComplete {
                if selectedTab == 0 {
                    fetchContributionData()
                } else {
                    fetchExpenditureData()
                }
                initialLoadComplete = true
            }
        }
        .onChange(of: selectedTab) { // Use onChange without deprecated oldValue
            // Fetch data when tab changes if it hasn't been loaded yet
            if selectedTab == 1 && topPayees.isEmpty && expenditureError == nil {
                fetchExpenditureData()
            } else if selectedTab == 0 && topContributors.isEmpty && contributionError == nil {
                fetchContributionData()
            }
        }
    }

    // Extracted Contributions List View
    @ViewBuilder
    private var contributionListView: some View {
        List {
            if let total = totalContributions {
                Section {
                    HStack {
                        Text("Total Contributions:")
                            .font(.headline)
                        Spacer()
                        Text(formatCurrency(total))
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
            }

            if !topContributors.isEmpty {
                Section(header: Text("Top 100 Contributors").font(.headline)) {
                    ForEach(topContributors) { contributor in
                        HStack {
                            Text(contributor.Description)
                            Spacer()
                            Text(formatCurrency(contributor.Amount))
                                .fontWeight(.semibold)
                        }
                    }
                }
            } else if totalContributions != nil { // Show only if total was fetched successfully
                Section { // Use Section for consistent spacing
                    Text("No contributor data available.")
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    // Extracted Expenditures List View (New)
    @ViewBuilder
    private var expenditureListView: some View {
        List {
            if let total = totalExpenditures {
                Section {
                    HStack {
                        Text("Total Expenditures:")
                            .font(.headline)
                        Spacer()
                        Text(formatCurrency(total))
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
            }

            if !topPayees.isEmpty {
                Section(header: Text("Top 100 Payees").font(.headline)) {
                    ForEach(topPayees) { payee in
                        HStack {
                            Text(payee.Description)
                            Spacer()
                            Text(formatCurrency(payee.Amount))
                                .fontWeight(.semibold)
                        }
                    }
                }
            } else if totalExpenditures != nil { // Show only if total was fetched successfully
                 Section {
                    Text("No payee data available.")
                        .foregroundColor(.secondary)
                 }
            }
        }
    }


    // --- Data Fetching Functions ---

    // Renamed fetchAllDetails to be specific
    private func fetchContributionData() {
        isLoadingContributions = true
        contributionError = nil // Reset error on fetch attempt
        let group = DispatchGroup()

        group.enter()
        fetchTotalContributions { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let total):
                    self.totalContributions = total
                case .failure(let error):
                    self.contributionError = "Failed to fetch total contributions: \(error.localizedDescription)"
                }
            }
            group.leave()
        }

        group.enter()
        fetchTopContributors { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let contributors):
                    self.topContributors = contributors.sorted { $0.Amount > $1.Amount }
                case .failure(let error):
                    // Append error message if total fetch also failed
                     self.contributionError = (self.contributionError ?? "") + "\nFailed to fetch contributors: \(error.localizedDescription)"
                }
            }
            group.leave()
        }

        group.notify(queue: .main) {
            isLoadingContributions = false
            // Set error only if *both* fetches failed or returned no data when expected
             if self.totalContributions == nil && self.topContributors.isEmpty && self.contributionError != nil {
                 // Error already set by individual fetches
             } else if self.totalContributions == nil && self.topContributors.isEmpty && self.contributionError == nil {
                 // Handle case where API returns success but no data (e.g., 0 contributions)
                 // Keep error nil, the UI will show "No data" message
             } else if self.contributionError != nil {
                 print("Error fetching NJ contribution details: \(self.contributionError!)")
            }
        }
    }

    // New function to fetch expenditure data
    private func fetchExpenditureData() {
        isLoadingExpenditures = true
        expenditureError = nil // Reset error on fetch attempt
        let group = DispatchGroup()

        group.enter()
        fetchTotalExpenditures { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let total):
                    self.totalExpenditures = total
                case .failure(let error):
                    self.expenditureError = "Failed to fetch total expenditures: \(error.localizedDescription)"
                }
            }
            group.leave()
        }

        group.enter()
        fetchTopPayees { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let payees):
                    self.topPayees = payees.sorted { $0.Amount > $1.Amount }
                case .failure(let error):
                    self.expenditureError = (self.expenditureError ?? "") + "\nFailed to fetch payees: \(error.localizedDescription)"
                }
            }
            group.leave()
        }

        group.notify(queue: .main) {
            isLoadingExpenditures = false
             if self.totalExpenditures == nil && self.topPayees.isEmpty && self.expenditureError != nil {
                 // Error handled by individual fetches
             } else if self.totalExpenditures == nil && self.topPayees.isEmpty && self.expenditureError == nil {
                 // Handle case where API returns success but no data (e.g., 0 expenditures)
                 // Keep error nil, the UI will show "No data" message
             } else if self.expenditureError != nil {
                print("Error fetching NJ expenditure details: \(self.expenditureError!)")
            }
        }
    }


    // --- Individual API Call Functions ---

    private func fetchTotalContributions(completion: @escaping (Result<Double, Error>) -> Void) {
        let encodedCommitteeId = candidate.ENTITY_S
        let urlString = "https://www.njelecefilesearch.com/api/VWContributionDetail/GetTotals?ENTITY_S=\(encodedCommitteeId)"
        makeGetRequest(urlString: urlString, responseType: Double.self, completion: completion)
    }

    private func fetchTopContributors(completion: @escaping (Result<[NJContributorTotalResponse], Error>) -> Void) {
        let encodedCommitteeId = candidate.ENTITY_S
        let urlString = "https://www.njelecefilesearch.com/api/VWContributionDetail/GetContributorTotals?ENTITY_S=\(encodedCommitteeId)&TopCount=100"
        makeGetRequest(urlString: urlString, responseType: [NJContributorTotalResponse].self, completion: completion)
    }

    // New function for total expenditures
    private func fetchTotalExpenditures(completion: @escaping (Result<Double, Error>) -> Void) {
        let encodedCommitteeId = candidate.ENTITY_S
        let urlString = "https://www.njelecefilesearch.com/api/VWExpenseDetail/GetTotals?ENTITY_S=\(encodedCommitteeId)"
        makeGetRequest(urlString: urlString, responseType: Double.self, completion: completion)
    }

    // New function for top payees
    private func fetchTopPayees(completion: @escaping (Result<[NJPayeeTotalResponse], Error>) -> Void) {
        let encodedCommitteeId = candidate.ENTITY_S
        let urlString = "https://www.njelecefilesearch.com/api/VWExpenseDetail/GetPayeeTotals?ENTITY_S=\(encodedCommitteeId)&TopCount=100"
        makeGetRequest(urlString: urlString, responseType: [NJPayeeTotalResponse].self, completion: completion)
    }

    // Generic GET request helper
    private func makeGetRequest<T: Decodable>(urlString: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL: \(urlString)"])))
            return
        }
        print("DEBUG: Fetching URL: \(url)") // Log URL

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DEBUG: Network Error for \(url): \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                 print("DEBUG: No data received for \(url)")
                completion(.failure(NSError(domain: "Network", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            // Handle direct Double response for total endpoints
            if T.self == Double.self {
                if let totalString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
                   let total = Double(totalString) {
                    completion(.success(total as! T)) // Force cast is safe here due to the check
                } else {
                     print("DEBUG: Failed to parse Double from data for \(url). Data: \(String(data: data, encoding: .utf8) ?? "Invalid encoding")")
                     completion(.failure(NSError(domain: "Parsing", code: 3, userInfo: [NSLocalizedDescriptionKey: "Could not parse amount"])))
                }
                return
            }

            // Handle JSON array decoding for list endpoints
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("DEBUG: JSON Parsing Error for \(url): \(error.localizedDescription). Data: \(String(data: data, encoding: .utf8) ?? "Invalid encoding")")
                completion(.failure(error))
            }
        }.resume()
    }

    // --- Formatting ---
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

// Helper extension remains the same
extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self == nil || self!.isEmpty
    }
}
