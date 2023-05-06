import XCTest
@testable import RickandMorty

final class RickandMortyNetworkTest: XCTestCase {

    func testNetworkCharacterList() async throws {
        let request: RequestProviderProtocol = RequestProvider(service: .character(1))
        
        let sut: NetworkServiceProtocol = NetworkService()
        
        let result = await sut.fetchData(request: request)
        
        if case .success(let data) = result {
            let json = await Parser().parseJSON(json: data, type: CharacterListModel.self)
            switch json {
            case .success(let model):
                XCTAssertNotNil(model.results)
            case .failure(let error):
                XCTFail(error.description)
            }
        } else {
            XCTFail("Character List Network Test Failed")
        }
    }
    
    func testNetworkSearchFailed() async throws {
        let request: RequestProviderProtocol = RequestProvider(service: .search("Zoe"))
        
        let sut: NetworkServiceProtocol = NetworkService()
        
        let result = await sut.fetchData(request: request)
        
        if case .success(let data) = result {
            let json = await Parser().parseJSON(json: data, type: CharacterListModel.self)
            switch json {
            case .success(let model):
                XCTAssertNotNil(model.error)
                XCTAssertEqual(model.error, "There is nothing here")
            case .failure(let error):
                XCTFail(error.description)
            }
        } else {
            XCTFail("Search Network Test Failed")
        }
    }
    
    func testNetworkEpisodeSuccess() async throws {
        let url = "https://rickandmortyapi.com/api/episode/1"
        let request: RequestProviderProtocol = RequestProvider(service: .url(url))
        
        let sut: NetworkServiceProtocol = NetworkService()
        
        let result = await sut.fetchData(request: request)
        
        if case .success(let data) = result {
            let json = await Parser().parseJSON(json: data, type: EpisodeModel.self)
            switch json {
            case .success(let model):
                XCTAssertNotNil(model.name)
                XCTAssertNotNil(model.episode)
                XCTAssertNotNil(model.characters)

            case .failure(let error):
                XCTFail(error.description)
            }
        } else {
            XCTFail("Episode Network Test Failed")
        }
    }
    
    func testNetworkEpisodeFailed() async throws {
        let url = "https://rickandmortyapi.com/api/episode/100000"
        let request: RequestProviderProtocol = RequestProvider(service: .url(url))
        
        let sut: NetworkServiceProtocol = NetworkService()
        
        let result = await sut.fetchData(request: request)
        
        if case .success(let data) = result {
            let json = await Parser().parseJSON(json: data, type: EpisodeModel.self)
            switch json {
            case .success(let model):
                XCTAssertNil(model.name)
                XCTAssertNotNil(model.error)
                XCTAssertEqual(model.error, "Episode not found")

            case .failure(let error):
                XCTFail(error.description)
            }
        } else {
            XCTFail("Episode Network Test Failed")
        }
    }
}
