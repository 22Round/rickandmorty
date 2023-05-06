import SwiftUI

struct CharacterDetailView: View {
    let model: CharacterModel

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                AsyncImageComponentView(path: model.image, size: 120, cornerRadius: 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Name: \(model.name)")
                        .font(.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                    
                    VStack(alignment: .leading) {
                        Text("Status: \(model.status)")
                        Text("Species: \(model.species)")
                        Text("Gender: \(model.gender)")
                    }
                    .font(.body)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Label("\(model.origin.name)", systemImage: "house.fill")
                Label("\(model.location.name)", systemImage: "location.square.fill")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            List {
                Section(header: Text("Episodes")) {
                    ForEach(model.episode, id: \.self) { episode in
                        CharacterDetaiEpisodeCellView(episode: episode, viewModel: .init(networkSetvice: NetworkService()))
                    }
                }
            }
        }
    }
}
