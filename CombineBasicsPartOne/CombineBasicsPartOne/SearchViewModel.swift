//
//  SearchViewModel.swift
//  CombineBasicsPartOne
//
//  Created by Khushal on 14/03/2026.
//

import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var results: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    func performSearch(query: String) {
        isLoading = true
        errorMessage = nil
        
        let urlString = "https://api.imdbapi.dev/search/titles?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
        // 1. Check for HTTP errors
            .tryMap { element -> Data in
                guard let response = element.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return element.data
            }
        
        // 2. Decode the Data
            .decode(type: SearchMovieResponse.self, decoder: JSONDecoder())
        
        // 3. Convert errors into our custom NetworkError
            .mapError { error -> NetworkError in
                if let decodingErr = error as? DecodingError {
                    return .decodingError(decodingErr)
                }
                return .invalidResponse
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    print("Debug: \(error)") // Console log for the teacher/dev
                }
            }, receiveValue: { [weak self] response in
                self?.results = response.titles
            })
            .store(in: &cancellables)
    }
}
