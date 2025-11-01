import SwiftUI

// MARK: - Main Content View (Landing Page)
struct ContentView: View {
    @State private var showingAboutSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Choose an Election Level")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                NavigationLink(destination: FederalElectionsView()) {
                    ElectionTypeRow(title: "Federal Elections", icon: "flag.fill")
                }
                
                NavigationLink(destination: SuperPACElectionCyclesView()) {
                    ElectionTypeRow(title: "Super PAC Expenditures", icon: "dollarsign.circle.fill")
                }
                
                NavigationLink(destination: StateSelectionView()) {
                    ElectionTypeRow(title: "State Elections", icon: "map.fill")
                }
                
                NavigationLink(destination: LocalCitySelectionView()) {
                    ElectionTypeRow(title: "Local Elections", icon: "building.columns.fill")
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAboutSheet.toggle()
                    }) {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .padding()
            .navigationTitle("VoteVault")
            .navigationViewStyle(.stack)
            .sheet(isPresented: $showingAboutSheet) {
                AboutView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Helper Views

func formatCurrencyShorthand(_ amount: Double) -> String {
    if amount >= 1_000_000 {
        return String(format: "$%.1fM", amount / 1_000_000)
    } else if amount >= 1_000 {
        return String(format: "$%.0fK", amount / 1_000)
    } else {
        return String(format: "$%.2f", amount)
    }
}

// MARK: - Xcode Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

