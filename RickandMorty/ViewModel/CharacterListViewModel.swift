import SwiftUI

final class CharacterListViewModel: BaseViewModel {
    
    @Published private(set) var characters: [CharacterModel] = []
    @Published private(set) var isDataLoading = false
    @Published var showErrorAlert = false
    @Published var searchText = ""
    
    private(set) var errorMessage: ResultError?
    
    private var serchListInfo: CharacterListModel.InfoModel?
    private var fetchListInfo: CharacterListModel.InfoModel?
    private var debounceSearch:Timer?
    private var isInitialLoading: Bool = true
    private var fetchPool: [CharacterModel] = [] {
        didSet {
            characters = fetchPool
        }
    }
    private var searchPool: [CharacterModel] = [] {
        didSet {
            characters = searchPool
        }
    }
    
    private var isSearching: Bool {
        !searchText.isEmpty
    }
    
    var isNextPageAvailable: Bool {
        if isInitialLoading { return true }
        let info = isSearching ? serchListInfo?.next : fetchListInfo?.next
        guard info != nil else { return false }
        return true
    }
    
    func prepearSearch() {
        searchPool = []
        cancelFetch()
        isDataLoading = true
        debounceSearch?.invalidate()
        debounceSearch = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            Task {
                await self.search()
            }
        }
    }
    
    @MainActor
    func search() async {
        if searchText.isEmpty {
            serchListInfo = nil
            searchPool = []
            characters = fetchPool
            cancelFetch()
            isDataLoading = false
            return
        }
        
        let request: RequestProviderProtocol = RequestProvider(service: .search(searchText))
        
        do {
            let result = try await fetch(type: CharacterListModel.self, request: request)
            if let error = result.error {
                searchPool = []
                searchPool.append(CharacterModel(
                    id: nil,
                    name: error,
                    status: "",
                    species: "",
                    type: "",
                    gender: "",
                    origin: .init(name: "", url: ""),
                    location: .init(name: "", url: ""),
                    image: "",
                    episode: []))
                
            } else {
                serchListInfo = result.info
                let listResult = conformResultToList(results: result.results)
                searchPool = listResult
            }
        } catch(let error) {
            errorMessage = error as? ResultError
            showErrorAlert = true
        }
        isDataLoading = false
    }
    
    @MainActor
    func loadList() async {
        if isSearching && isDataLoading { return }
        isDataLoading = true
        isInitialLoading = false
        let nextPage: String? = isSearching ? serchListInfo?.next : fetchListInfo?.next
        let url: RequestProvider.EndPoints = fetchListInfo?.next == nil ? .character(1) : .url(nextPage)
        let request: RequestProviderProtocol = RequestProvider(service: url)
        
        do {
            let result = try await fetch(type: CharacterListModel.self, request: request)
            let listResult = conformResultToList(results: result.results)
            
            if isSearching {
                serchListInfo = result.info
                searchPool.append(contentsOf: listResult)
            } else {
                fetchListInfo = result.info
                fetchPool.append(contentsOf: listResult)
            }
        } catch(let error) {
            errorMessage = error as? ResultError
            showErrorAlert = true
        }
        isDataLoading = false
    }
    
    private func conformResultToList(results: [CharacterModel]?) -> [CharacterModel] {
        guard let result = results else { return [] }
        let listResult = result.map { model in
            var ch: CharacterModel = model
            ch.uniqueID = .init()
            return ch
        }
        return listResult
    }
}
