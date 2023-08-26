import Foundation

enum ViewState {
    case none
    case error(message: String)
    case loading
    case loaded
}
