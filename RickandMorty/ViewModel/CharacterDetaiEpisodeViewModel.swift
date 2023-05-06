import Foundation

final class CharacterDetaiEpisodeViewModel: BaseViewModel {
    @Published private(set) var characters: [CharacterModel] = []
    @Published private(set) var isDataLoading = false
    @Published private(set) var episode: EpisodeModel?
    @Published var showErrorAlert = false
    
    private(set) var errorMessage: ResultError?
    
    @MainActor
    func loadCharacters() async {
        guard let chars = episode?.characters, characters.isEmpty else { return }
        for url in chars {
            let request: RequestProviderProtocol = RequestProvider(service: .url(url))
            do {
                var characte = try await fetch(type: CharacterModel.self, request: request)
                characte.uniqueID = .init()
                characters.append(characte)
            } catch(let error) {
                errorMessage = error as? ResultError
                showErrorAlert = true
            }
        }
    }
    
    @MainActor
    func loadEpisode(url: String) async {
        isDataLoading = true
        let request: RequestProviderProtocol = RequestProvider(service: .url(url))
        do {
            episode = try await fetch(type: EpisodeModel.self, request: request)
        } catch(let error) {
            errorMessage = error as? ResultError
            showErrorAlert = true
        }
        isDataLoading = false
    }
}

