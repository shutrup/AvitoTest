import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModel
    
    init(detailId: String) {
        self.viewModel = DetailViewModel(detailId: detailId)
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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        
            self.viewModel.viewState.bind { state in
                switch state {
                case .loading:
                    self.showActivityIndicator()
                case .loaded:
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                        self.populateData()
                    }
                case .error:
                    self.hideActivityIndicator()
                    self.title = state?.message
                case nil: break
                case .some(.none): break
                }
        }
    }
   
    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        view.addSubview(locationLabel)
        view.addSubview(createdDateLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(emailLabel)
        view.addSubview(phoneNumberLabel)
        view.addSubview(addressLabel)
        
        let padding: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 400.0),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8.0),
            locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            createdDateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8.0),
            createdDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: createdDateLabel.bottomAnchor, constant: padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding),
            emailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            phoneNumberLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8.0),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            addressLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 8.0),
            addressLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addressLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
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
