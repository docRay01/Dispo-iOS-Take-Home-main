import UIKit

class DetailViewController: UIViewController {
    let viewModel = DetailViewModel()
    
    init(searchResult: SearchResult) {
        super.init(nibName: nil, bundle: nil)
        initialize()
    }
    
    override func loadView() {
        view = UIView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        
    }
}
