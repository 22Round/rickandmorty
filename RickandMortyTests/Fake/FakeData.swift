import Foundation

final class FakeData {
    
    let dummyFile: String
    
    init(dummy: String) {
        dummyFile = dummy
    }
    
    func dummyData() async -> Data {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: dummyFile, ofType: "json"),
              let json = try? String(contentsOfFile: pathString, encoding: .utf8),
              let data = json.data(using: .utf8)
              else {
            fatalError("Error occured")
        }
        return data
    }
}
