import SwiftUI

struct CharacterListCellView: View {
    let model: CharacterModel
    var body: some View {
        HStack {
            if !model.image.isEmpty {
                AsyncImageComponentView(path: model.image, size: 44, cornerRadius: 10)
            }
            Text(model.name)
        }
        .frame(height: 50)
    }
}
