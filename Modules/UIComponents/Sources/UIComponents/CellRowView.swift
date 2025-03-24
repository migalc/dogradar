//
//  SwiftUIView.swift
//  UIComponents
//
//  Created by Miguel Alcantara on 24/03/2025.
//

import SwiftUI

public struct CellRowView: View {
    private let text: String
    
    public init(text: String) {
        self.text = text
    }

    public var body: some View {
        HStack {
            Text(text)
                .font(.caption)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
    }
}

// MARK: - Previews

struct Element: Identifiable {
    let id: String
}

let uuids = (0...100).map { _ in UUID().uuidString }
let data = uuids.map(Element.init)

#Preview {
    @Previewable @State var searchText: String = ""
    
    var results: [Element] {
        if searchText.isEmpty {
            data
        } else {
            data.filter { $0.id.contains(searchText) }
        }
    }

    NavigationStack {
        List(results, id: \.id) { element in
            CellRowView(text: element.id)
        }
    }
    .searchable(text: $searchText)
}
