import SwiftUI

struct NYCMayoralCandidateDetailView: View {
    let candidate: NYCMayoralCandidate
    let year: Int

    @State private var selectedTab = 0 // 0 for Contributions, 1 for Expenditures

    // States for Contributions Tab
    @State private var contributions: [NYCCFBContribution] = []
    @State private var totalContributions: Double = 0.0
    @State private var isLoadingContributions = false
    @State private var contributionError: String? = nil
    @State private var hasFetchedContributions = false

    // States for Expenditures Tab
    @State private var expenditures: [NYCCFBExpenditure] = [] // New state for expenditures
    @State private var totalExpenditures: Double = 0.0
    @State private var isLoadingExpenditures = false
    @State private var expenditureError: String? = nil
    @State private var hasFetchedExpenditures = false

    var body: some View {
        VStack {
            Picker("Data", selection: $selectedTab) {
                Text("Contributions").tag(0)
                Text("Expenditures").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            // Content Area
            Group {
                if selectedTab == 0 {
                    contributionsView
                } else {
                    expendituresView // Use the new expenditures view
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle(candidate.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Fetch initial data only if it hasn't been fetched before
            if selectedTab == 0 && !hasFetchedContributions {
                fetchContributions()
            } else if selectedTab == 1 && !hasFetchedExpenditures {
                fetchExpenditures() // Fetch expenditures if starting on that tab
            }
        }
        .onChange(of: selectedTab) { // Use modern onChange
            // Fetch data when tab changes if needed
            if selectedTab == 0 && !hasFetchedContributions {
                fetchContributions()
            } else if selectedTab == 1 && !hasFetchedExpenditures {
                fetchExpenditures() // Fetch expenditures when switching to tab 1
            }
        }
    }

    // --- Extracted ViewBuilders ---

    @ViewBuilder
    private var contributionsView: some View {
        if isLoadingContributions {
            ProgressView("Fetching Contributions...")
                .padding(.top)
        } else if let error = contributionError {
            VStack {
                 Text("Error Loading Contributions")
                     .font(.headline).foregroundColor(.red)
                 Text(error).font(.callout).foregroundColor(.gray).multilineTextAlignment(.center)
             }.padding()
        } else if contributions.isEmpty && hasFetchedContributions {
            Text("No contributions found for this candidate.").foregroundColor(.secondary).padding()
        } else if !contributions.isEmpty {
            VStack {
                Spacer()
                Section {
                    HStack {
                        Text("Total Contributions:")
                            .font(.headline)
                        Spacer()
                        Text(formatCurrency(totalContributions))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                List(contributions) { contribution in
                    NYCCFBContributionRowView(contribution: contribution)
                }
                .listStyle(.plain)
            }
        } else {
            Spacer()
        }
    }

    @ViewBuilder
    private var expendituresView: some View {
        if isLoadingExpenditures {
            ProgressView("Fetching Expenditures...")
                .padding(.top)
        } else if let error = expenditureError {
            VStack {
                 Text("Error Loading Expenditures")
                     .font(.headline).foregroundColor(.red)
                 Text(error).font(.callout).foregroundColor(.gray).multilineTextAlignment(.center)
             }.padding()
        } else if expenditures.isEmpty && hasFetchedExpenditures {
            Text("No expenditures found for this candidate.")
                .foregroundColor(.secondary)
                .padding()
        } else if !expenditures.isEmpty {
            VStack {
                Spacer()
                Section {
                    HStack {
                        Text("Total Expenditures:")
                            .font(.headline)
                        Spacer()
                        Text(formatCurrency(totalExpenditures))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                List(expenditures) { expenditure in
                    NYCCFBExpenditureRowView(expenditure: expenditure)
                }
                .listStyle(.plain)
            }
        } else {
            Spacer()
        }
    }


    // --- Data Fetching ---

    private func fetchContributions() {
        // print("Fetching contributions for \(candidate.name) (\(year)), ID: \(candidate.id)")
        isLoadingContributions = true
        contributionError = nil // Reset error before fetch
        hasFetchedContributions = true // Mark fetch as attempted
        
        let urlString = "https://www.nyccfb.info/FTMSearch/Candidates/ContriputionsAjaxHandler?sEcho=3&iColumns=7&sColumns=%2C%2C%2C%2C%2C%2C&iDisplayStart=0&iDisplayLength=100&mDataProp_0=0&bSortable_0=true&mDataProp_1=1&bSortable_1=true&mDataProp_2=2&bSortable_2=true&mDataProp_3=3&bSortable_3=true&mDataProp_4=4&bSortable_4=true&mDataProp_5=5&bSortable_5=true&mDataProp_6=6&bSortable_6=true&iSortCol_0=5&sSortDir_0=desc&iSortingCols=1&election_cycle=\(year)&office_cd=1%2C11&&cand_id=\(candidate.id)&c_cd=IND%2CCAN%2CSPO%2CFAM%2CPCOMC%2CPCOMZ%2CPCOMP%2Cempo%2CCORP%2CPART%2CLLC%2Cothr_unkn&RecipientType=can&TransactionType_ID=ABC&page_no=&rows_per_page=&action_type=search&view_mode=list"
        
        let url = URL(string: urlString)

        // print("DEBUG: NYC CFB URL: \(String(describing: url))") // Log the final URL

        // Perform the GET request
        URLSession.shared.dataTask(with: url!) { data, response, error in
            DispatchQueue.main.async {
                self.isLoadingContributions = false // Stop loading indicator

                if let error = error {
                    print("DEBUG: Network Error - \(error.localizedDescription)")
                    self.contributionError = error.localizedDescription
                    return
                }

                guard let data = data else {
                     print("DEBUG: No data received")
                    self.contributionError = "No data received from server."
                    return
                }
                
                // Debug: Print raw response string
                // print("DEBUG: Raw Response - \(String(data: data, encoding: .utf8) ?? "Invalid encoding")")


                do {
                    // Decode the JSON response
                    let decodedResponse = try JSONDecoder().decode(NYCCFBContributionResponse.self, from: data)
                    
                    self.totalContributions = decodedResponse.iTotalAmount

                    // Map the array of string arrays to our struct
                    self.contributions = decodedResponse.aaData.compactMap { NYCCFBContribution(data: $0) }
                     // print("DEBUG: Successfully parsed \(self.contributions.count) contributions.")

                } catch {
                     print("DEBUG: JSON Decoding Error - \(error)")
                     // Provide more context about the decoding error
                    self.contributionError = "Failed to parse data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    // NEW: Function to fetch expenditures
    private func fetchExpenditures() {
        // print("Fetching expenditures for \(candidate.name) (\(year)), ID: \(candidate.id)")
        isLoadingExpenditures = true
        expenditureError = nil
        hasFetchedExpenditures = true

        let urlString = "https://www.nyccfb.info/FTMSearch/Candidates/ExpendituresAjaxHandler?sEcho=3&iColumns=7&sColumns=%2C%2C%2C%2C%2C%2C&iDisplayStart=0&iDisplayLength=100&mDataProp_0=0&bSortable_0=true&mDataProp_1=1&bSortable_1=true&mDataProp_2=2&bSortable_2=true&mDataProp_3=3&bSortable_3=true&mDataProp_4=4&bSortable_4=true&mDataProp_5=5&bSortable_5=true&mDataProp_6=6&bSortable_6=true&iSortCol_0=4&sSortDir_0=desc&iSortingCols=1&election_cycle=\(year)&office_cd=1%2C11&cand_id=\(candidate.id)&TransactionType_ID=F&Account_ID=&sort_expression=&sort_direction=&page_no=&rows_per_page=&action_type=search&internCode=&CommunicationType_ID=&Communication_ID=&comm_id=&spender_ID=&contributor_id=&Sond_cd=&IndependentSpenderSearchName=&Payee_Name=&view_mode=list"
        
        let url = URL(string: urlString)

        // print("DEBUG: NYC CFB URL: \(String(describing: url))") // Log the final URL

        URLSession.shared.dataTask(with: url!) { data, response, error in
             DispatchQueue.main.async {
                self.isLoadingExpenditures = false

                if let error = error {
                    print("DEBUG: Network Error - \(error.localizedDescription)")
                    self.expenditureError = "Network error: \(error.localizedDescription)"
                    return
                }
                 
                guard let data = data else {
                    print("DEBUG: Expend No data received")
                    self.expenditureError = "No data received from server."
                    return
                }
                
                do {
                    // Use NYCCFBExpenditureResponse for decoding
                    let decodedResponse = try JSONDecoder().decode(NYCCFBExpenditureResponse.self, from: data)
                    
                    self.totalExpenditures = decodedResponse.iTotalAmount
                    
                    // Map using NYCCFBExpenditure initializer
                    self.expenditures = decodedResponse.aaData.compactMap { NYCCFBExpenditure(data: $0) }
                    
                    // print("DEBUG: Successfully parsed \(self.expenditures.count) expenditures.")
                    self.expenditureError = nil
                } catch {
                     print("DEBUG: Expend JSON Decoding Error - \(error)")
                    self.expenditureError = "Failed to parse data: \(error.localizedDescription)"
                     print("DEBUG: Expend Data that failed parsing: \(String(data: data, encoding: .utf8) ?? "Invalid encoding")")
                }
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

// Preview remains the same
struct NYCMayoralCandidateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCandidate = NYCMayoralCandidate(id: "1437", name: "Eric L. Adams", party: "Democrat")
        NavigationView {
             NYCMayoralCandidateDetailView(candidate: sampleCandidate, year: 2021)
        }
    }
}

