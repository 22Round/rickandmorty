import Foundation
@testable import RickandMorty

class FakeNetworkService : NetworkServiceProtocol {
    private let dummy: String
    init(dummy: String) {
        self.dummy = dummy
    }
    func fetchData<Request: RequestProviderProtocol>(request: Request) async -> Result<Data, ResultError> {
        let fakeData: FakeData = .init(dummy: dummy)
        let data = await fakeData.dummyData()
        return .success(data)
    }
    
    func cancelFetchData() {
    }
}

