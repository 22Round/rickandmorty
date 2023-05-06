import SwiftUI

struct CharacterView: View {
    @StateObject private var viewModel: CharacterListViewModel = .init(networkSetvice: NetworkService())

    var body: some View {
        NavigationStack {
            
            List {
                if viewModel.isDataLoading {
                    ProgressView()
                        .id(UUID())
                }
                
                ForEach(viewModel.characters, id: \.uniqueID) { character in
                    if character.id == nil {
                        CharacterListCellView(model: character)
                    } else {
                        NavigationLink {
                            CharacterDetailView(model: character)
                        } label: {
                            CharacterListCellView(model: character)
                        }
                    }
                }
                
                if !viewModel.isDataLoading,
                   viewModel.isNextPageAvailable {
                    
                    ProgressView()
                        .id(UUID())
                        .onAppear {
                            Task {
                                await viewModel.loadList()
                            }
                        }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: viewModel.searchText){ _ in
                viewModel.prepearSearch()
            }
            .navigationTitle("Rick & Morty")
            .alert(isPresented: $viewModel.showErrorAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.errorMessage?.description ?? ""),
                      dismissButton: .default(Text("OK")))
            }
        }
        
        .searchable(text: $viewModel.searchText)
        .onSubmit(of: .search, viewModel.prepearSearch)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView()
    }
}
