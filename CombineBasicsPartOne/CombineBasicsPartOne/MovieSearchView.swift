//
//  MovieSearchView.swift
//  CombineBasicsPartOne
//
//  Created by Khushal on 14/03/2026.
//

import SwiftUI

struct MovieSearchView: View {
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("Movie Explorer")
                    .fontWidth(.expanded)
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                // 1. Our Styled Search Bar
                CustomSearchBar(text: $viewModel.searchText)
                    .padding(.top, 10)
                    .padding(.bottom, 25)
                    .padding(.horizontal)

                ZStack {
                    // 2. The Background Theme
                    Color(.systemGroupedBackground)
                        .edgesIgnoringSafeArea(.bottom)

                    if viewModel.results.isEmpty && !viewModel.isLoading {
                        // Empty State Styling
                        ContentUnavailableView("No Movies Found",
                                               systemImage: "film",
                                               description: Text("Try searching for something else."))
                    } else {
                        // 3. Results List
                        List(viewModel.results, id: \.self) { movie in
                            HStack {
                                Image(systemName: "play.tv.fill")
                                    .foregroundColor(.blue)
                                Text(movie.primaryTitle ?? "")
                                    .font(.body)
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                    
                    // 4. Loading State
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.1))
                    }
                }
            }
            .navigationTitle("Movie Explorer")
            .toolbarBackground(Color.blue, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    MovieSearchView()
}
