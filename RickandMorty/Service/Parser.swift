import Foundation

class Parser {
    
    func parseJSON<T: Decodable>(json: Data, type: T.Type) async -> Result<T, ResultError> {
        
        let decoder = JSONDecoder()
        do {
            let mod: T = try decoder.decode(T.self, from: json)
            return .success(mod)
        } catch let error {
            return .failure(.parseError(error.localizedDescription))
        }
    }
}
