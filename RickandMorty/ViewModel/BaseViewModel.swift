import Foundation

class BaseViewModel: ObservableObject {
    private let networkSetvice: NetworkServiceProtocol
    init(networkSetvice: NetworkServiceProtocol) {
        self.networkSetvice = networkSetvice
    }
    
    func cancelFetch() {
        networkSetvice.cancelFetchData()
    }
    
    func fetch<T: Decodable>(type: T.Type, request: RequestProviderProtocol) async throws -> T {
        let result = await networkSetvice.fetchData(request: request)
        switch result {
        case .success(let dataLoaded):
            let parsedResult = await Parser().parseJSON(json: dataLoaded, type: T.self)
            switch parsedResult {
            case .success(let parserResult):
                return parserResult
                
            case .failure(let parseError):
                throw parseError
            }
        case .failure( let error):
            throw error
        }
    }
}
