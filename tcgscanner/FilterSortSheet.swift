//
//  FilterSortSheet.swift
//  starwarscardscanner
//
//  Filter and sort options for collection
//

import SwiftUI

struct FilterSortSheet: View {
    @Binding var sortOption: CollectionView.SortOption
    @Binding var filterFaction: String?
    @Binding var filterRarity: String?
    @Binding var filterGameType: String?
    
    let availableFactions: [String]
    let availableRarities: [String]
    let availableGameTypes: [String]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                StarsBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Sort Options
                        VStack(alignment: .leading, spacing: 15) {
                            Text("SORT BY")
                                .font(.starWarsTitle(18))
                                .foregroundColor(.white)
                                .starWarsGlow()
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(CollectionView.SortOption.allCases, id: \.self) { option in
                                    Button(action: { sortOption = option }) {
                                        HStack {
                                            Image(systemName: option.icon)
                                                .frame(width: 20)
                                            Text(option.rawValue)
                                                .font(.starWarsBody(12))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(sortOption == option ? Color.starWarsYellow.opacity(0.3) : Color.imperialGray.opacity(0.3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(sortOption == option ? Color.starWarsYellow : Color.clear, lineWidth: 1)
                                        )
                                        .cornerRadius(8)
                                        .foregroundColor(sortOption == option ? .starWarsYellow : .white)
                                    }
                                }
                            }
                        }
                        .padding()
                        .starWarsCard()
                        
                        // Faction Filter
                        filterSection(
                            title: "FACTION",
                            selectedValue: $filterFaction,
                            options: availableFactions,
                            icon: { factionIcon(for: $0) },
                            color: { factionColor(for: $0) }
                        )
                        
                        // Rarity Filter
                        filterSection(
                            title: "RARITY",
                            selectedValue: $filterRarity,
                            options: availableRarities,
                            icon: { _ in "star.fill" },
                            color: { rarityColor(for: $0) }
                        )
                        
                        // Game Type Filter
                        filterSection(
                            title: "GAME TYPE",
                            selectedValue: $filterGameType,
                            options: availableGameTypes,
                            icon: { _ in "gamecontroller.fill" },
                            color: { _ in .starWarsYellow }
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("FILTER & SORT")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear All") {
                        filterFaction = nil
                        filterRarity = nil
                        filterGameType = nil
                        sortOption = .dateNewest
                    }
                    .foregroundColor(.lightsaberRed)
                    .disabled(filterFaction == nil && filterRarity == nil && filterGameType == nil && sortOption == .dateNewest)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.starWarsYellow)
                }
            }
        }
    }
    
    @ViewBuilder
    func filterSection(
        title: String,
        selectedValue: Binding<String?>,
        options: [String],
        icon: @escaping (String) -> String,
        color: @escaping (String) -> Color
    ) -> some View {
        if !options.isEmpty {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text(title)
                        .font(.starWarsTitle(18))
                        .foregroundColor(.white)
                        .starWarsGlow()
                    
                    Spacer()
                    
                    if selectedValue.wrappedValue != nil {
                        Button("Clear") {
                            selectedValue.wrappedValue = nil
                        }
                        .font(.caption)
                        .foregroundColor(.lightsaberRed)
                    }
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                if selectedValue.wrappedValue == option {
                                    selectedValue.wrappedValue = nil
                                } else {
                                    selectedValue.wrappedValue = option
                                }
                            }) {
                                HStack(spacing: 5) {
                                    Image(systemName: icon(option))
                                        .foregroundColor(color(option))
                                    Text(option.uppercased())
                                        .font(.starWarsBody(12))
                                }
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .background(selectedValue.wrappedValue == option ? color(option).opacity(0.3) : Color.imperialGray.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selectedValue.wrappedValue == option ? color(option) : Color.clear, lineWidth: 1)
                                )
                                .cornerRadius(20)
                                .foregroundColor(selectedValue.wrappedValue == option ? color(option) : .white)
                            }
                        }
                    }
                }
            }
            .padding()
            .starWarsCard()
        }
    }
    
    func factionIcon(for faction: String) -> String {
        switch faction.lowercased() {
        case "light side", "hero":
            return "sun.max.fill"
        case "dark side", "villain":
            return "moon.fill"
        case "neutral":
            return "circle.hexagongrid.fill"
        default:
            return "sparkles"
        }
    }
    
    func factionColor(for faction: String) -> Color {
        switch faction.lowercased() {
        case "light side", "hero":
            return .lightsaberBlue
        case "dark side", "villain":
            return .lightsaberRed
        case "neutral":
            return .commonGray
        default:
            return .starWarsYellow
        }
    }
    
    func rarityColor(for rarity: String) -> Color {
        switch rarity.lowercased() {
        case "common": return .commonGray
        case "uncommon": return .uncommonGreen
        case "rare": return .rareBlue
        case "legendary": return .legendaryPurple
        case "hyperspace": return .hyperspacePurple
        default: return .starWarsYellow
        }
    }
}