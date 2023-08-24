import Foundation

final class HomeViewModel {
    private let service: AdvertisementServiceProtocol
    
    init(service: AdvertisementServiceProtocol) {
        self.service = service
        self.fetchAdvertisements()
    }
    
    var advertisements: Observable<[Advertisement]> = Observable([])
    var viewState: Observable<ViewState> = Observable(ViewState.none)
    
    func fetchAdvertisements() {
        viewState.value = .loading
        
        service.fetchAdvertisements { result in
            switch result {
            case .success(let data):
                self.advertisements.value = data.advertisements
                self.viewState.value = .loaded
            case .failure:
                self.viewState.value = .error
            }
        }
    }
}

enum ViewState: String {
    case none
    case error
    case loading
    case loaded
    
    var message: String {
        switch self {
        case .none:
            return "unknown"
        case .error:
            return "не удалось загрузить"
        case .loading:
            return "загружается"
        case .loaded:
            return "загрузилось"
        }
    }
}
