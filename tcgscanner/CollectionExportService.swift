//
//  CollectionExportService.swift
//  starwarscardscanner
//
//  Export collection data to CSV and PDF formats
//

import Foundation
import SwiftUI
import PDFKit
import UniformTypeIdentifiers

class CollectionExportService {
    static let shared = CollectionExportService()
    
    private init() {}
    
    // MARK: - Export to CSV
    func exportToCSV(cards: [SavedCard]) -> URL? {
        let fileName = "StarWarsCollection_\(Date().formatted(date: .abbreviated, time: .omitted)).csv"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        // CSV Header
        var csvContent = "Name,Type,Game,Faction,Rarity,Set Code,Condition,PSA Rating,TCGPlayer Price,Date Scanned\n"
        
        // Add each card
        for card in cards {
            let name = escapeCSV(card.name)
            let type = escapeCSV(card.cardType)
            let game = escapeCSV(card.starWarsGameType?.rawValue ?? card.gameType)
            let faction = escapeCSV(card.faction ?? "Unknown")
            let rarity = escapeCSV(card.rarity)
            let setCode = escapeCSV(card.attributes?["setCode"] as? String ?? "")
            let condition = escapeCSV(card.condition ?? "Unknown")
            let psaRating = card.psaRating != nil ? "\(card.psaRating!)" : ""
            let price = card.tcgplayerPrice != nil ? String(format: "%.2f", card.tcgplayerPrice!) : ""
            let dateScanned = card.dateScanned.formatted(date: .abbreviated, time: .omitted)
            
            csvContent += "\(name),\(type),\(game),\(faction),\(rarity),\(setCode),\(condition),\(psaRating),\(price),\(dateScanned)\n"
        }
        
        do {
            try csvContent.write(to: tempURL, atomically: true, encoding: .utf8)
            return tempURL
        } catch {
            print("Error writing CSV: \(error)")
            return nil
        }
    }
    
    // MARK: - Export to PDF
    func exportToPDF(cards: [SavedCard]) -> URL? {
        let fileName = "StarWarsCollection_\(Date().formatted(date: .abbreviated, time: .omitted)).pdf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        let pdfMetaData = [
            kCGPDFContextCreator: "Star Wars Card Scanner",
            kCGPDFContextAuthor: "Star Wars Card Scanner App",
            kCGPDFContextTitle: "Star Wars Card Collection"
        ]
        
        UIGraphicsBeginPDFContextToFile(tempURL.path, CGRect(x: 0, y: 0, width: 612, height: 792), pdfMetaData as? [String: Any])
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Start first page
        UIGraphicsBeginPDFPage()
        
        // Draw title
        drawTitle(in: context)
        
        // Draw summary
        drawSummary(cards: cards, in: context, startY: 120)
        
        // Draw cards table
        var currentY: CGFloat = 250
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 50
        let rowHeight: CGFloat = 25
        
        // Table headers
        drawTableHeaders(in: context, startY: currentY)
        currentY += rowHeight + 10
        
        // Draw each card
        for (index, card) in cards.enumerated() {
            // Check if we need a new page
            if currentY + rowHeight > pageHeight - margin {
                UIGraphicsBeginPDFPage()
                currentY = margin
                drawTableHeaders(in: context, startY: currentY)
                currentY += rowHeight + 10
            }
            
            drawCardRow(card: card, index: index, in: context, startY: currentY)
            currentY += rowHeight
        }
        
        UIGraphicsEndPDFContext()
        
        return tempURL
    }
    
    // MARK: - Helper Methods
    private func escapeCSV(_ string: String) -> String {
        if string.contains(",") || string.contains("\"") || string.contains("\n") {
            return "\"\(string.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return string
    }
    
    private func drawTitle(in context: CGContext) {
        let title = "STAR WARS CARD COLLECTION"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.black
        ]
        
        let titleSize = title.size(withAttributes: titleAttributes)
        let titleRect = CGRect(x: (612 - titleSize.width) / 2, y: 50, width: titleSize.width, height: titleSize.height)
        
        title.draw(in: titleRect, withAttributes: titleAttributes)
        
        // Draw date
        let date = "Generated: \(Date().formatted(date: .complete, time: .shortened))"
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.gray
        ]
        
        let dateSize = date.size(withAttributes: dateAttributes)
        let dateRect = CGRect(x: (612 - dateSize.width) / 2, y: 80, width: dateSize.width, height: dateSize.height)
        
        date.draw(in: dateRect, withAttributes: dateAttributes)
    }
    
    private func drawSummary(cards: [SavedCard], in context: CGContext, startY: CGFloat) {
        let summaryAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.black
        ]
        
        let totalCards = "Total Cards: \(cards.count)"
        let totalValue = cards.compactMap { $0.tcgplayerPrice }.reduce(0, +)
        let valueString = "Total Value: $\(String(format: "%.2f", totalValue))"
        
        let uniqueCards = Set(cards.map { $0.name }).count
        let uniqueString = "Unique Cards: \(uniqueCards)"
        
        totalCards.draw(at: CGPoint(x: 50, y: startY), withAttributes: summaryAttributes)
        valueString.draw(at: CGPoint(x: 250, y: startY), withAttributes: summaryAttributes)
        uniqueString.draw(at: CGPoint(x: 450, y: startY), withAttributes: summaryAttributes)
        
        // Faction breakdown
        let factionCounts = Dictionary(grouping: cards) { $0.faction ?? "Unknown" }
        var factionY = startY + 30
        
        let factionTitle = "Faction Distribution:"
        factionTitle.draw(at: CGPoint(x: 50, y: factionY), withAttributes: summaryAttributes)
        factionY += 20
        
        for (faction, factionCards) in factionCounts.sorted(by: { $0.value.count > $1.value.count }) {
            let factionText = "\(faction): \(factionCards.count) cards"
            factionText.draw(at: CGPoint(x: 70, y: factionY), withAttributes: summaryAttributes)
            factionY += 18
        }
    }
    
    private func drawTableHeaders(in context: CGContext, startY: CGFloat) {
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor: UIColor.black
        ]
        
        // Draw headers
        "Name".draw(at: CGPoint(x: 50, y: startY), withAttributes: headerAttributes)
        "Type".draw(at: CGPoint(x: 200, y: startY), withAttributes: headerAttributes)
        "Faction".draw(at: CGPoint(x: 280, y: startY), withAttributes: headerAttributes)
        "Rarity".draw(at: CGPoint(x: 350, y: startY), withAttributes: headerAttributes)
        "Condition".draw(at: CGPoint(x: 420, y: startY), withAttributes: headerAttributes)
        "Value".draw(at: CGPoint(x: 500, y: startY), withAttributes: headerAttributes)
        
        // Draw line under headers
        context.setStrokeColor(UIColor.gray.cgColor)
        context.setLineWidth(0.5)
        context.move(to: CGPoint(x: 50, y: startY + 18))
        context.addLine(to: CGPoint(x: 562, y: startY + 18))
        context.strokePath()
    }
    
    private func drawCardRow(card: SavedCard, index: Int, in context: CGContext, startY: CGFloat) {
        let rowAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: index % 2 == 0 ? UIColor.black : UIColor.darkGray
        ]
        
        // Truncate long names
        let name = card.name.count > 25 ? String(card.name.prefix(22)) + "..." : card.name
        let type = card.cardType.count > 12 ? String(card.cardType.prefix(10)) + "..." : card.cardType
        let faction = (card.faction ?? "Unknown").count > 10 ? String((card.faction ?? "Unknown").prefix(8)) + "..." : (card.faction ?? "Unknown")
        let rarity = card.rarity.count > 10 ? String(card.rarity.prefix(8)) + "..." : card.rarity
        let condition = (card.condition ?? "Unknown").count > 12 ? String((card.condition ?? "Unknown").prefix(10)) + "..." : (card.condition ?? "Unknown")
        let value = card.tcgplayerPrice != nil ? "$\(String(format: "%.2f", card.tcgplayerPrice!))" : "N/A"
        
        name.draw(at: CGPoint(x: 50, y: startY), withAttributes: rowAttributes)
        type.draw(at: CGPoint(x: 200, y: startY), withAttributes: rowAttributes)
        faction.draw(at: CGPoint(x: 280, y: startY), withAttributes: rowAttributes)
        rarity.draw(at: CGPoint(x: 350, y: startY), withAttributes: rowAttributes)
        condition.draw(at: CGPoint(x: 420, y: startY), withAttributes: rowAttributes)
        value.draw(at: CGPoint(x: 500, y: startY), withAttributes: rowAttributes)
    }
}

// MARK: - Export Sheet View
struct ExportOptionsSheet: View {
    let cards: [SavedCard]
    @Environment(\.dismiss) private var dismiss
    @State private var showingShareSheet = false
    @State private var exportURL: URL?
    @State private var exportFormat: ExportFormat = .csv
    
    enum ExportFormat: String, CaseIterable {
        case csv = "CSV"
        case pdf = "PDF"
        
        var icon: String {
            switch self {
            case .csv: return "tablecells"
            case .pdf: return "doc.text"
            }
        }
        
        var description: String {
            switch self {
            case .csv: return "Spreadsheet format, compatible with Excel"
            case .pdf: return "Printable document with formatting"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                StarsBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("EXPORT COLLECTION")
                        .font(.starWarsTitle(24))
                        .foregroundColor(.white)
                        .starWarsGlow()
                        .padding(.top)
                    
                    Text("\(cards.count) cards will be exported")
                        .font(.starWarsBody(14))
                        .foregroundColor(.gray)
                    
                    VStack(spacing: 15) {
                        ForEach(ExportFormat.allCases, id: \.self) { format in
                            Button(action: {
                                exportFormat = format
                                performExport()
                            }) {
                                HStack {
                                    Image(systemName: format.icon)
                                        .font(.title2)
                                        .frame(width: 40)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Export as \(format.rawValue)")
                                            .font(.starWarsTitle(16))
                                            .foregroundColor(.white)
                                        
                                        Text(format.description)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.starWarsYellow)
                                }
                                .padding()
                                .background(Color.imperialGray.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.starWarsYellow.opacity(0.3), lineWidth: 1)
                                )
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.starWarsYellow)
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let url = exportURL {
                ShareSheet(items: [url])
            }
        }
    }
    
    private func performExport() {
        switch exportFormat {
        case .csv:
            exportURL = CollectionExportService.shared.exportToCSV(cards: cards)
        case .pdf:
            exportURL = CollectionExportService.shared.exportToPDF(cards: cards)
        }
        
        if exportURL != nil {
            showingShareSheet = true
        }
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}