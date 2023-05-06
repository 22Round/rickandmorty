import Foundation

protocol NetworkServiceProtocol {
    func fetchData<Request: RequestProviderProtocol> (request: Request) async -> Result<Data, ResultError>
    func cancelFetchData()
}

class NetworkService: NetworkServiceProtocol {
    func cancelFetchData() {
        URLSession.shared.invalidateAndCancel()
    }
    func fetchData<Request: RequestProviderProtocol> (request: Request) async -> Result<Data, ResultError> {
        guard let url = request.urlRequest else { return .failure(.badURL) }
        do {
            let (data, response) = try await URLSession.shared.data(for: url, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.badURL)
            }
            switch response.statusCode {
            case 200...299:
                return .success(data)
            case 404:
                return .success(data)
            default:
                return .failure(.unknown)
            }
        } catch(let error) {
            return .failure(.parseError(error.localizedDescription))
        }
    }
}

enum ResultError: Error, Equatable {
    case badURL
    case dataError
    case parseError(String)
    case unknown
}

extension ResultError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown: return "Unknown Error"
        case .badURL: return "Bad URL!"
        case .dataError: return "The data couldn't be read because it isn't in the correct format."
        case .parseError(let error): return "During JSON parse something happened, error: \(error)"
        }
    }
}
