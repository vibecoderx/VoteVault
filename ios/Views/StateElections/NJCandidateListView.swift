//
//  NJCandidateListView.swift
//  VoteVault
//

import SwiftUI

struct NJCandidateListView: View {
    let office: NJOfficeInfo
    let year: Int

    @State private var candidates: [NJCandidate] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var partyFilter: String? // Added state for party filter

    // Added computed property to filter candidates based on selection
    var filteredCandidates: [NJCandidate] {
        if let party = partyFilter {
            if party == "OTHER" {
                // Filter for parties that are NOT Democrat or Republican
                return candidates.filter {
                    let upperParty = $0.PARTY.uppercased()
                    return upperParty != "DEMOCRAT" && upperParty != "REPUBLICAN"
                }
            } else {
                // Filter for Democrat or Republican (case-insensitive)
                return candidates.filter { $0.PARTY.uppercased() == party }
            }
        } else {
            // No filter applied, return all candidates
            return candidates
        }
    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Candidates...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red).padding()
            } else if candidates.isEmpty {
                Text("No candidates found for this selection.").foregroundColor(.secondary).padding()
            } else {
                List {
                    VStack {
                        HStack(spacing: 15) {
                            FilterButton(title: "Dem", party: "DEMOCRAT", selection: $partyFilter)
                            FilterButton(title: "Rep", party: "REPUBLICAN", selection: $partyFilter)
                            FilterButton(title: "Other", party: "OTHER", selection: $partyFilter)
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)

                    // Iterate over filteredCandidates instead of candidates
                    ForEach(filteredCandidates) { candidate in
                        NavigationLink(destination: NJCandidateDetailView(candidate: candidate, year: year)) {
                            NJCandidateTileView(candidate: candidate)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("\(year) \(office.name) Race")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchNJCandidates()
        }
    }

    private func fetchNJCandidates() {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "https://www.njelecefilesearch.com/api/VWEntity/Entities20") else {
            self.errorMessage = "Invalid API handler URL."
            self.isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let postDataString = "draw=1&columns%5B0%5D%5Bdata%5D=ENTITYNAME&columns%5B0%5D%5Bname%5D=ENTITYNAME&columns%5B0%5D%5Bsearchable%5D=true&columns%5B0%5D%5Borderable%5D=true&columns%5B0%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B0%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B1%5D%5Bdata%5D=LOCATION&columns%5B1%5D%5Bname%5D=LOCATION&columns%5B1%5D%5Bsearchable%5D=true&columns%5B1%5D%5Borderable%5D=true&columns%5B1%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B1%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B2%5D%5Bdata%5D=OFFICE&columns%5B2%5D%5Bname%5D=OFFICE&columns%5B2%5D%5Bsearchable%5D=true&columns%5B2%5D%5Borderable%5D=true&columns%5B2%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B2%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B3%5D%5Bdata%5D=PARTY&columns%5B3%5D%5Bname%5D=PARTY&columns%5B3%5D%5Bsearchable%5D=true&columns%5B3%5D%5Borderable%5D=true&columns%5B3%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B3%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B4%5D%5Bdata%5D=ELECTIONTYPE&columns%5B4%5D%5Bname%5D=ELECTIONTYPE&columns%5B4%5D%5Bsearchable%5D=true&columns%5B4%5D%5Borderable%5D=true&columns%5B4%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B4%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B5%5D%5Bdata%5D=ELECTIONYEAR&columns%5B5%5D%5Bname%5D=ELECTIONYEAR&columns%5B5%5D%5Bsearchable%5D=true&columns%5B5%5D%5Borderable%5D=true&columns%5B5%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B5%5D%5Bsearch%5D%5Bregex%5D=false&order%5B0%5D%5Bcolumn%5D=5&order%5B0%5D%5Bdir%5D=desc&order%5B0%5D%5Bname%5D=ELECTIONYEAR&order%5B1%5D%5Bcolumn%5D=0&order%5B1%5D%5Bdir%5D=asc&order%5B1%5D%5Bname%5D=ENTITYNAME&start=0&length=15&search%5Bvalue%5D=&search%5Bregex%5D=false&NONPACOnly=true&FirstName=&LastName=&MI=&Suffix=&NonIndName=&OfficeCodes=\(office.officeCode)&PartyCodes=&LocationCodes=&ElectionTypeCodes=G&ElectionYears=\(year)&SortColumn=ElectionYear&SortBy=desc"

        request.httpBody = postDataString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Network Error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received from server."
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(NJCandidateResponse.self, from: data)
                    self.candidates = decodedResponse.data
                } catch {
                    self.errorMessage = "Failed to parse candidate data: \(error.localizedDescription)"
                    print("DEBUG: Parsing error: \(error)")
                }
            }
        }.resume()
    }
}
