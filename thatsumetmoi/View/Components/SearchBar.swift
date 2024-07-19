//
//  SearchBar.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 19/7/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)

                TextField("Search", text: $text)
                    .padding(7)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Spacer()

                            if !text.isEmpty {
                                Button(action: {
                                    self.text = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
            }
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    SearchBar(text: .constant("hello"))
}
