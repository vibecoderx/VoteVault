//
//  TopSuperPACExpendituresView.swift
//  VoteVault
//

import SwiftUI

struct TopSuperPACExpendituresView: View {
    let cycle: Int
    
    @State private var expendituresWithDetails: [ExpenditureWithCandidateDetail] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Top 50 Expenditures...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if expendituresWithDetails.isEmpty {
                Text("No expenditure data found for this cycle.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List(expendituresWithDetails) { item in
                    SuperPACExpenditureRowView(detail: item)
                }
            }
        }
        .navigationTitle("Top Expenditures (\(cycle))")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchTopExpenditures()
        }
    }
    
    private func getAPIKey() -> String {
        return "pNdJTlEjNg1iF0DX5idIiwfLfV50easOc7JhXHv6"
    }

    private func fetchTopExpenditures() {
        isLoading = true
        let apiKey = getAPIKey()
        let urlString = "https://api.open.fec.gov/v1/schedules/schedule_e/totals/by_candidate/?sort=-total&election_full=true&cycle=\(cycle)&per_page=50&api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL for fetching expenditures."
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(SuperPACExpenditureByCandidateResponse.self, from: data)
                        // Now fetch details for each candidate
                        fetchDetailsForAllCandidates(expenditures: decodedResponse.results)
                    } catch {
                        self.errorMessage = "Failed to parse expenditure data: \(error.localizedDescription)"
                        self.isLoading = false
                    }
                } else {
                    self.errorMessage = "Error fetching expenditure data: \(error?.localizedDescription ?? "Unknown error")"
                    self.isLoading = false
                }
            }
        }.resume()
    }
    
    private func fetchDetailsForAllCandidates(expenditures: [SuperPACExpenditureByCandidate]) {
        let group = DispatchGroup()
        var tempDetails: [String: CandidateDetail] = [:]
        
        for expenditure in expenditures {
            group.enter()
            fetchCandidateDetail(for: expenditure.candidate_id) { detail in
                if let detail = detail {
                    tempDetails[expenditure.candidate_id] = detail
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            // Combine original expenditures with fetched details
            self.expendituresWithDetails = expenditures.compactMap { expenditure in
                if let detail = tempDetails[expenditure.candidate_id] {
                    return ExpenditureWithCandidateDetail(expenditure: expenditure, candidateDetail: detail)
                }
                return nil
            }
            self.isLoading = false
        }
    }
    
    private func fetchCandidateDetail(for candidateId: String, completion: @escaping (CandidateDetail?) -> Void) {
        let apiKey = getAPIKey()
        let urlString = "https://api.open.fec.gov/v1/candidate/\(candidateId)/?election_year=\(cycle)&api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(CandidateDetailResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.results.first)
                }
            } catch {
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
}

