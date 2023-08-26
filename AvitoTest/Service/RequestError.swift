import Foundation

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unknown
    
    var message: String {
        switch self {
        case .decode:
            return "Decode error"
        case .invalidURL:
            return "invalid URL"
        default:
            return "Unknown error"
        }
    }
}
