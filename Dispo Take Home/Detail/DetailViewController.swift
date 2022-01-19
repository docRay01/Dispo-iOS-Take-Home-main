import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    let viewModel = DetailViewModel()
    
    let imageView = AnimatedImageView(frame: CGRect(x: 0, y: 200, width: 400, height: 400))
    let titleLabel = UILabel(frame: CGRect(x: 10, y: 610, width: 400, height: 200))
    let logoImage = UIImageView(frame: CGRect(x: 0, y: 810, width: 97, height: 31))
    
    init(gifId: String) {
        super.init(nibName: nil, bundle: nil)
        initialize()
        viewModel.loadSearchResult(id: gifId)
    }
    
    override func loadView() {
        view = UIView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        self.viewModel.view = self
        
        // Image at full size
        //imageView.frame = CGRect(origin: .zero, size: CGSize(width: self.view.frame.width, height: 400))
        self.view.addSubview(imageView)
        
        // title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(titleLabel)
        
        // giphy logo
        logoImage.image = UIImage(named: "GiphyLogo")
        self.view.addSubview(logoImage)
    }
    
    func refreshView() {
        guard let gifData = self.viewModel.gifData else {
            return
        }
        let url: URL = gifData.images.fixed_height.url
        let animatedImageViewResource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
            imageView.kf.setImage(with: animatedImageViewResource)
        
        DispatchQueue.main.async {
            self.titleLabel.text = gifData.title
        }
    }
}
