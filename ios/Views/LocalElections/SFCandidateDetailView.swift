//
//  SFCandidateDetailView.swift
//  VoteVault
//


import SwiftUI

struct SFCandidateDetailView: View {
    let candidate: SFMayoralCandidate
    let year: String
    
    @State private var selectedTab = 0
    
    // States for Tabs
    @State private var contributions: [SFTransaction] = []
    @State private var expenditures: [SFTransaction] = []
    @State private var totalContributions: Double? = nil // New state for total
    @State private var totalExpenditures: Double? = nil // New state for total
    
    @State private var isLoadingContributions = false
    @State private var isLoadingExpenditures = false
    @State private var contributionError: String?
    @State private var expenditureError: String?
    @State private var hasFetchedContributions = false
    @State private var hasFetchedExpenditures = false
    
    // SF App Token
    @State private var appToken: String?
    
    var body: some View {
        VStack {
            Picker("Data", selection: $selectedTab) {
                Text("Contributions").tag(0)
                Text("Expenditures").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Group {
                if selectedTab == 0 {
                    contributionsView
                } else {
                    expendituresView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle(candidate.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadAppTokenAndFetch()
        }
        .onChange(of: selectedTab) {
            // Only fetch if token is loaded and data hasn't been fetched
            if appToken != nil {
                fetchDataForCurrentTab()
            }
        }
    }
    
    // MARK: - View Builders
    
    @ViewBuilder
    private var contributionsView: some View {
        if isLoadingContributions {
            ProgressView("Fetching Contributions...").padding(.top)
        } else if let error = contributionError {
            VStack {
                 Text("Error Loading Contributions")
                     .font(.headline).foregroundColor(.red)
                 Text(error).font(.callout).foregroundColor(.gray).multilineTextAlignment(.center)
             }.padding()
        } else if contributions.isEmpty && totalContributions == nil && hasFetchedContributions {
             Text("No contributions found for this candidate.").foregroundColor(.secondary).padding()
        } else {
            List {
                // NEW: Section for Total Contributions
                if let total = totalContributions {
                    Section {
                        HStack {
                            Text("Total Contributions:")
                                .font(.headline)
                            Spacer()
                            Text(formatAmount(total))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                // Section for Top 100 Contributions
                if !contributions.isEmpty {
                    Section(header: Text("Top 100 Contributions").font(.headline)) {
                        ForEach(contributions) { transaction in
                            SFTransactionRowView(transaction: transaction)
                        }
                    }
                }
            }
            .listStyle(.plain) // Use plain style, or .insetGrouped for sections
        }
    }
    
    @ViewBuilder
    private var expendituresView: some View {
        if isLoadingExpenditures {
            ProgressView("Fetching Expenditures...").padding(.top)
        } else if let error = expenditureError {
            VStack {
                 Text("Error Loading Expenditures")
                     .font(.headline).foregroundColor(.red)
                 Text(error).font(.callout).foregroundColor(.gray).multilineTextAlignment(.center)
             }.padding()
        } else if expenditures.isEmpty && totalExpenditures == nil && hasFetchedExpenditures {
            Text("No expenditures found for this candidate.").foregroundColor(.secondary).padding()
        } else {
             List {
                 // NEW: Section for Total Expenditures
                 if let total = totalExpenditures {
                     Section {
                         HStack {
                             Text("Total Expenditures:")
                                 .font(.headline)
                             Spacer()
                             Text(formatAmount(total))
                                 .font(.headline)
                                 .fontWeight(.bold)
                                 .foregroundColor(.blue)
                         }
                     }
                 }
                 
                 // Section for Top 100 Expenditures
                 if !expenditures.isEmpty {
                     Section(header: Text("Top 100 Expenditures").font(.headline)) {
                         ForEach(expenditures) { transaction in
                             SFTransactionRowView(transaction: transaction)
                         }
                     }
                 }
             }
             .listStyle(.plain)
        }
    }
    
    // MARK: - Data Fetching
    
    private func loadAppTokenAndFetch() {
        guard let token = Secrets.get(key: "SF_APP_TOKEN") else {
            // Set errors for both tabs if token is missing
            self.contributionError = "App Token (SF_APP_TOKEN) is missing. Please check Secrets.xcconfig."
            self.expenditureError = "App Token (SF_APP_TOKEN) is missing. Please check Secrets.xcconfig."
            return
        }
        self.appToken = token
        
        // Fetch data for the currently selected tab
        fetchDataForCurrentTab()
    }
    
    private func fetchDataForCurrentTab() {
        // Use a DispatchGroup to coordinate multiple API calls for one tab
        let group = DispatchGroup()
        
        if selectedTab == 0 && !hasFetchedContributions {
            isLoadingContributions = true
            contributionError = nil
            hasFetchedContributions = true
            
            // Fetch list of contributions
            fetchTransactions(formType: "A", group: group)
            // Fetch total contributions
            fetchTotal(formType: "A", group: group)
            
            // When both are done, stop loading
            group.notify(queue: .main) {
                isLoadingContributions = false
            }
            
        } else if selectedTab == 1 && !hasFetchedExpenditures {
            isLoadingExpenditures = true
            expenditureError = nil
            hasFetchedExpenditures = true
            
            // Fetch list of expenditures
            fetchTransactions(formType: "E", group: group)
            // Fetch total expenditures
            fetchTotal(formType: "E", group: group)
            
            // When both are done, stop loading
            group.notify(queue: .main) {
                isLoadingExpenditures = false
            }
        }
    }
    
    // Fetches the list of top 100 transactions
    private func fetchTransactions(formType: String, group: DispatchGroup) {
        guard let appToken = appToken else { return } // Should be loaded already
        
        group.enter() // Enter group for transaction list fetch
        
        var urlComponents = URLComponents(string: "https://data.sfgov.org/api/v3/views/pitq-e56w/query.json")
        
        let queryClause = "SELECT * WHERE fppc_id = '\(candidate.filerId)' AND form_type='\(formType)' ORDER BY calculated_amount DESC"
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "$$app_token", value: appToken),
            URLQueryItem(name: "pageNumber", value: "1"),
            URLQueryItem(name: "pageSize", value: "100"),
            URLQueryItem(name: "query", value: queryClause)
        ]
        
        guard let url = urlComponents?.url else {
            let errorMsg = "Internal error: Could not create transaction API URL."
            if formType == "A" { self.contributionError = errorMsg }
            else { self.expenditureError = errorMsg }
            group.leave()
            return
        }
        
        print("DEBUG: SF API (List) URL: \(url.absoluteString)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { group.leave() } // Leave group when task finishes
            DispatchQueue.main.async {
                let errorState = (formType == "A") ? $contributionError : $expenditureError
                let dataList = (formType == "A") ? $contributions : $expenditures
                
                if let error = error {
                    print("DEBUG: Network Error - \(error.localizedDescription)")
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nNetwork error (list): \(error.localizedDescription)"
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    print("DEBUG: HTTP Error - Status Code \(statusCode)")
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nServer error (list): \(statusCode)."
                    return
                }
                
                guard let data = data else {
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nNo data received (list)."
                    return
                }
                
                do {
                    let transactions = try JSONDecoder().decode([SFTransaction].self, from: data)
                    dataList.wrappedValue = transactions
                    // print("DEBUG: Successfully parsed \(transactions.count) transactions.")
                } catch {
                    // print("DEBUG: JSON Decoding Error (List) - \(error)")
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nFailed to parse list: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    // NEW: Fetches the total (sum) for contributions or expenditures
    private func fetchTotal(formType: String, group: DispatchGroup) {
        guard let appToken = appToken else { return } // Should be loaded already

        group.enter() // Enter group for total fetch

        var urlComponents = URLComponents(string: "https://data.sfgov.org/api/v3/views/pitq-e56w/query.json")
        
        // Build the SoQL query for sum
        let soqlQuery = "SELECT sum(calculated_amount) WHERE fppc_id = '\(candidate.filerId)' AND form_type = '\(formType)'"

        urlComponents?.queryItems = [
            URLQueryItem(name: "$$app_token", value: appToken),
            URLQueryItem(name: "query", value: soqlQuery) // Use the 'query' parameter
        ]

        guard let url = urlComponents?.url else {
            let errorMsg = "Internal error: Could not create total API URL."
            if formType == "A" { self.contributionError = errorMsg }
            else { self.expenditureError = errorMsg }
            group.leave()
            return
        }

        print("DEBUG: SF API (Total) URL: \(url.absoluteString)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { group.leave() } // Leave group when task finishes
            DispatchQueue.main.async {
                let errorState = (formType == "A") ? $contributionError : $expenditureError
                let totalState = (formType == "A") ? $totalContributions : $totalExpenditures
                
                if let error = error {
                    print("DEBUG: Network Error (Total) - \(error.localizedDescription)")
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nNetwork error (total): \(error.localizedDescription)"
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    print("DEBUG: HTTP Error (Total) - Status Code \(statusCode)")
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nServer error (total): \(statusCode)."
                    return
                }
                
                guard let data = data else {
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nNo data received (total)."
                    return
                }

                do {
                    // Socrata sum() returns an array with one object: [{"sum_calculated_amount":"12345.67"}]
                    let totalResponse = try JSONDecoder().decode([SFTotalAmount].self, from: data)
                    
                    if let totalString = totalResponse.first?.sum_calculated_amount,
                       let totalValue = Double(totalString) {
                        totalState.wrappedValue = totalValue
                        // print("DEBUG: Successfully parsed total: \(totalValue)")
                    } else {
                         print("DEBUG: Could not parse sum from response: \(String(data: data, encoding: .utf8) ?? "N/A")")
                        // Don't set an error, just means total is 0 or null
                        totalState.wrappedValue = 0.0 // Explicitly set to 0 if null/unparsable
                    }
                } catch {
                    // print("DEBUG: JSON Decoding Error (Total) - \(error)")
                    errorState.wrappedValue = (errorState.wrappedValue ?? "") + "\nFailed to parse total: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    // Helper function to format currency
    private func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct SFCandidateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCandidate = SFMayoralCandidate(name: "London Breed", party: "Democrat", filerId: "1441599")
        NavigationView {
            SFCandidateDetailView(candidate: sampleCandidate, year: "2024")
        }
    }
}

