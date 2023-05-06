import SwiftUI

struct CharacterDetaiEpisodeCellView: View {
    let episode: String
    @StateObject var viewModel: CharacterDetaiEpisodeViewModel
    @State private var isExpaned: Bool = false
    var body: some View {
        VStack {
            if isExpaned {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.characters, id: \.uniqueID) { character in
                            NavigationLink {
                                CharacterDetailView(model: character)
                            } label: {
                                AsyncImageComponentView(path: character.image, size: 40, cornerRadius: 20)
                            }
                        }
                    }
                }
            }
            HStack {
                if let episode = viewModel.episode?.name {
                    Text("Episode: \(episode)")
                }
                Spacer()
                Button(isExpaned ? "Close" : "Expand") {
                    withAnimation {
                        isExpaned.toggle()
                    }
                    
                    Task {
                        await viewModel.loadCharacters()
                    }
                }
            }
            .font(.subheadline)
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorMessage?.description ?? ""),
                  dismissButton: .default(Text("OK")))
        }
        .onLoad {
            Task {
                await viewModel.loadEpisode(url: episode)
            }
        }
    }
}
