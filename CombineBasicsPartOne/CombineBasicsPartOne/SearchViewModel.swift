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
    private let apiService = APIService()
    private var tempCancellable: AnyCancellable?
    
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
        
        // MARK: API call using Future publisher
        let moviePublisher = apiService.fetchMoviePublisher(movieID: "tt0499549")

        moviePublisher.sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("kjkj FP fetchMovie Future Completed")
                    case .failure(let error):
                        print("kjkj FP Error:", error)
                    }
                },
                receiveValue: { movie in
                    print("kjkj FP Movie:", movie)
                }
            )
            .store(in: &cancellables)


        // MARK: API call using Future publisher
        moviePublisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("kjkj FP ONCE AGAIN fetchMovie Future Completed")
                    case .failure(let error):
                        print("kjkj FP ONCE AGAIN Error:", error)
                    }
                },
                receiveValue: { movie in
                    print("kjkj FP ONCE AGAIN Movie:", movie)
                }
            )
            .store(in: &cancellables)
        
        // MARK: API call using Future with Deferred publisher

         apiService.fetchMovieDeferredPublisher(movieID: "tt0120338")
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("kjkj DFP fetchMovie FutureDeferred Completed")
                    case .failure(let error):
                        print("kjkj DFP Error:", error)
                    }
                },
                receiveValue: { movie in
                    print("kjkj DFP Movie:", movie)
                }
            )
            .store(in: &cancellables)

        // MARK: share() operator

        // MARK: Search API Call with and without using share() [need to remove share() from publisher

        let sharedSearchPublisher = sharedSearchMoviePublisher(query: query)

        // subscriber one
        sharedSearchPublisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    print("Debug: \(error)") // Console log for the teacher/dev
                }
            }, receiveValue: { [weak self] response in
                print("kjkj first time results")
                self?.results = response.titles
            })
            .store(in: &cancellables)

        // subscriber two
        sharedSearchPublisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    print("Debug: \(error)") // Console log for the teacher/dev
                }
            }, receiveValue: { [weak self] response in
                print("kjkj second time results")
                self?.results = response.titles
            })
            .store(in: &cancellables)

        // MARK: multicast() operator

        let passThroughSubject = PassthroughSubject<Data, URLError>()
        
        let multicastedPublisher = URLSession.shared.dataTaskPublisher(for: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)
            .map { $0.data }
            .print("kjkj MP Mulitcast example")
            .multicast(subject: passThroughSubject)
        
        multicastedPublisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("kjkj MP First Finished")
                    case .failure(let error):
                        print("kjkj MP First Error:", error)
                    }
                },
                receiveValue: { value in
                    print("kjkj MP Multi First Value:", value)
                }
            )
            .store(in: &cancellables)
        
        multicastedPublisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("kjkj MP Second Finished")
                    case .failure(let error):
                        print("kjkj MP Second Error:", error)
                    }
                },
                receiveValue: { value in
                    print("kjkj MP Second Value:", value)
                }
            )
            .store(in: &cancellables)

        // trigger point for execution
        multicastedPublisher.connect()
            .store(in: &cancellables)
    }
    
    func sharedSearchMoviePublisher(query: String) -> AnyPublisher<SearchMovieResponse, NetworkError> {
        let urlString = "https://api.imdbapi.dev/search/titles?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        guard let url = URL(string: urlString) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
//            .handleEvents(receiveSubscription: { _ in
//                    print("kjkj SEARCH API Call Started")
//                })
            .print("ABC")

            // Check for HTTP errors
            .tryMap { element -> Data in
                guard let response = element.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return element.data
            }
        
            // Decode the Data
            .decode(type: SearchMovieResponse.self, decoder: JSONDecoder())
        
            // Convert errors into our custom NetworkError
            .mapError { error -> NetworkError in
                if let decodingErr = error as? DecodingError {
                    return .decodingError(decodingErr)
                }
                return .invalidResponse
            }
            .share()
            .eraseToAnyPublisher()
    }
}
