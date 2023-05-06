import XCTest
@testable import RickandMorty

final class RickandMortyTests: XCTestCase {
    
    func testList() async throws {
        let fakeService = FakeNetworkService(dummy: "List")
        
        let sut: CharacterListViewModel = .init(networkSetvice: fakeService)
        await sut.loadList()
        
        XCTAssertFalse(sut.characters.isEmpty)
    }
    
    func testSearchEmptyResult() async throws {
        let fakeService = FakeNetworkService(dummy: "EmptySearch")
        
        let sut: CharacterListViewModel = .init(networkSetvice: fakeService)
        sut.searchText = "Empty Search Result"
        await sut.search()
        
        let element = sut.characters[0]
        
        XCTAssertEqual(sut.characters.count, 1)
        XCTAssertEqual(element.name, "There is nothing here")
    }
    
    func testListNextPageAvailability() async throws {
        let fakeService = FakeNetworkService(dummy: "List")
        
        let sut: CharacterListViewModel = .init(networkSetvice: fakeService)
        await sut.loadList()
        
        XCTAssertTrue(sut.isNextPageAvailable)
    }
    
    func testEpisode() async throws {
        let fakeService = FakeNetworkService(dummy: "Episode")
        
        let sut: CharacterDetaiEpisodeViewModel = .init(networkSetvice: fakeService)
        await sut.loadEpisode(url: "https://fakeepisode.com/")
        
        XCTAssertNotNil(sut.episode)
    }
    
    func testCharacter() async throws {
        let fakeService = FakeEpisodeNetworkService()
        
        let sut: CharacterDetaiEpisodeViewModel = .init(networkSetvice: fakeService)
        await sut.loadEpisode(url: "https://fakeepisode.com/")
        await sut.loadCharacters()
        
        XCTAssertFalse(sut.characters.isEmpty)
    }
    
    func testError() async throws {
        let fakeService = FakeNetworkErrorService(error: .badURL)
        
        let sut: CharacterListViewModel = .init(networkSetvice: fakeService)
        await sut.loadList()
        
        XCTAssertEqual(sut.errorMessage, .badURL)
    }

}
