import SwiftUI

struct SFCandidateTileView: View {
    let candidate: SFMayoralCandidate

    // Use a neutral color for SF candidates as party isn't in this data
    private var backgroundColor: Color
    private var textColor: Color = .white

    // Explicit internal initializer to fix the "inaccessible" build error
    // This initializer is accessible by default ('internal')
    init(candidate: SFMayoralCandidate) {
        self.candidate = candidate
        
        // Determine color based on party string
        let partyLower = candidate.party.lowercased()
        if partyLower.contains("democrat") {
            self.backgroundColor = Color.blue
        } else if partyLower.contains("republican") {
            self.backgroundColor = Color.red
        } else {
            self.backgroundColor = Color.gray.opacity(0.8) // Default for "Other"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(candidate.name)
                    .font(.title2).bold()
                // Display the party from the data store
                Text(candidate.party)
                    .font(.subheadline)
                 Text("Filer ID: \(candidate.filerId)")
                     .font(.caption)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(8)
            .padding(.top, -8)
            .padding(.horizontal, -12)
        }
        .padding(.vertical)
    }
}

struct SFCandidateTileView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCandidate = SFMayoralCandidate(name: "London Breed", party: "Democrat", filerId: "1441599")
        SFCandidateTileView(candidate: sampleCandidate)
            .padding()
    }
}

