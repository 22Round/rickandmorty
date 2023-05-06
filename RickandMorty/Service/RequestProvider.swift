import Foundation

protocol RequestProviderProtocol {
  var urlRequest: URLRequest? { get }
}

class RequestProvider: RequestProviderProtocol {
    
    private let serverUrl: String
    init(service: EndPoints){
        serverUrl = service.description
    }
    
    var urlRequest: URLRequest? {
        guard let url: URL = .init(string: serverUrl) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}

extension RequestProvider {
    enum EndPoints {
        case character(Int)
        case search(String)
        case url(String?)
        
        var description: String {
            switch self {
            case .character(let page): return "\(GlobalConstants.baseURL)/character?page=\(page)"
            case .search(let name): return "\(GlobalConstants.baseURL)/character/?name=\(name)"
            case .url(let url): return "\(url ?? "")"
            }
        }
    }
}
