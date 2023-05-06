import Foundation
@testable import RickandMorty

class FakeNetworkErrorService : NetworkServiceProtocol {
    private let error: ResultError
    init(error: ResultError) {
        self.error = error
    }
    func fetchData<Request: RequestProviderProtocol>(request: Request) async -> Result<Data, ResultError> {
        return .failure(error)
    }
    
    func cancelFetchData() {
    }
}
