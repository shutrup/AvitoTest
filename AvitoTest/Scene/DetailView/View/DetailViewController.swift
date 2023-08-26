import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModel
    
    init(service: AdvertisementServiceProtocol, detailId: String) {
        self.viewModel = DetailViewModel(service: service, detailId: detailId)
        self.viewModel.fetchDetailInfo()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private lazy var createdDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        
        observeViewState()
    }
    
    private func observeViewState() {
        self.viewModel.viewState.bind { state in
            switch state {
            case .loading:
                self.showActivityIndicator()
            case .loaded:
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.populateData()
                }
            case .error(let error):
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.presentErrorAlert(message: error, retryHandler: {
                        self.viewModel.fetchDetailInfo()
                    })
                }
            case nil: break
            case .some(.none): break
            }
        }
    }
    
    private func showActivityIndicator() {
        spinner = UIActivityIndicatorView(style: .large)
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    private func hideActivityIndicator(){
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
}

//MARK: UI SETUP
private extension DetailViewController {
    private func setupUI() {
        view.addSubviews(imageView, titleLabel, priceLabel, locationLabel, createdDateLabel, descriptionLabel, emailLabel, phoneNumberLabel, addressLabel)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        let padding: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 350),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            
            createdDateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            createdDateLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: createdDateLabel.bottomAnchor, constant: padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            emailLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            phoneNumberLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            
            addressLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 4),
            addressLabel.leadingAnchor.constraint(equalTo: phoneNumberLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: phoneNumberLabel.trailingAnchor),
            addressLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
    
    private func populateData() {
        guard let detail = viewModel.detail else {
            return
        }
        
        titleLabel.text = detail.title
        priceLabel.text = detail.price
        locationLabel.text = detail.location
        createdDateLabel.text = detail.createdDate
        descriptionLabel.text = detail.description
        emailLabel.text = detail.email
        phoneNumberLabel.text = detail.phoneNumber
        addressLabel.text = detail.address
        
        if let imageURL = URL(string: detail.imageURL) {
            imageView.sd_setImage(with: imageURL, completed: nil)
        }
    }
}
