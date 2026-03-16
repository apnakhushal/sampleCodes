//
//  CustomSearchBar.swift
//  CombineBasicsPartOne
//
//  Created by Khushal on 14/03/2026.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search movies...", text: $text)
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6)) // Themed background
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    CustomSearchBar(text: .constant("hello"))
}
