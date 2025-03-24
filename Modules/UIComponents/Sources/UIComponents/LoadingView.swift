//
//  SwiftUIView.swift
//  UIComponents
//
//  Created by Miguel Alcantara on 24/03/2025.
//

import SwiftUI

public struct LoadingView: View {
    private let subtitle: String

    public init(subtitle: String) {
        self.subtitle = subtitle
    }

    public var body: some View {
        HStack {
            ProgressView()
                .progressViewStyle(.circular)
            Text(subtitle)
                .font(.footnote)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    LoadingView(subtitle: "Subtitle")
}
