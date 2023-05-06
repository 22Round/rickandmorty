import SwiftUI

struct AsyncImageComponentView: View {
    let path: String
    let size: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: path)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
           ProgressView()
        }
        .frame(width: size, height: size)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(cornerRadius)
    }
}
