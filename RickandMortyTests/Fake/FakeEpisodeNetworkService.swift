import Foundation
@testable import RickandMorty

class FakeEpisodeNetworkService : NetworkServiceProtocol {
    func fetchData<Request: RequestProviderProtocol>(request: Request) async -> Result<Data, ResultError> {
        let dummy: String = (request.urlRequest?.url?.absoluteString.contains("fakeepisode") ?? true) ? "Episode" : "Character"
        let fakeData: FakeData = .init(dummy: dummy)
        let data = await fakeData.dummyData()
        return .success(data)
    }
    
    func cancelFetchData() {
    }
}

