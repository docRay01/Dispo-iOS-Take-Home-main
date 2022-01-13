import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    let viewModel = DetailViewModel()
    
    let imageView = AnimatedImageView(frame: CGRect(x: 0, y: 200, width: 400, height: 400))
    let titleLabel = UILabel(frame: CGRect(x: 10, y: 610, width: 400, height: 200))
    
    // TODO: Remove this function
    init(searchResult: SearchResult) {
        super.init(nibName: nil, bundle: nil)
        initialize()
        
        if let url: URL = searchResult.gifUrl {
            let animatedImageViewResource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
            imageView.kf.setImage(with: animatedImageViewResource)
        }
        
        titleLabel.text = searchResult.title
        //sourceLabel.text = searchResult
    }
    
    override func loadView() {
        view = UIView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        // Image at full size
        //imageView.frame = CGRect(origin: .zero, size: CGSize(width: self.view.frame.width, height: 400))
        self.view.addSubview(imageView)
        
        // title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(titleLabel)
        
        // giphy logo
        // TODO
    }
}
