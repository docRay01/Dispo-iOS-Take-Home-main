import UIKit

class MainViewController: UIViewController {
    
    let cellName = "gifCell"
    let cellHeight:Float = 150
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        
        viewModel.view = self
        viewModel.populateInitialCells()
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "search gifs..."
        searchBar.delegate = self
        return searchBar
    }()
    
    private var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        return layout
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.register(MainCollectionViewCell.self,
                                forCellWithReuseIdentifier: cellName)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
}

extension MainViewController: MainViewModelDelegate {
    func reloadCells(from start: Int, count: Int) {
        DispatchQueue.main.async {
            var indexPaths: [IndexPath] = []
            for i in 0 ... count - 1 {
                indexPaths.append(IndexPath(row: start + i, section: 0))
            }
            self.collectionView.reloadItems(at: indexPaths)
        }
    }
    
    func refreshCollectionView() {
        DispatchQueue.main.async {
            let firstCellPath = IndexPath(item: 0, section: 0)
            
            if self.collectionView(self.collectionView, numberOfItemsInSection: 0) > 0 {
                self.collectionView.scrollToItem(at: firstCellPath, at: .top, animated: false)
            } else {
                self.collectionView.setContentOffset(.zero, animated: false)
            }
            self.collectionView.reloadData()
        }
    }
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Wait 0.5 seconds before kicking off search to avoid spamming service
        viewModel.setSearchString(text: searchText, delaySearch: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // If there is a change in the text from the previous search text, then
        // kick off a search
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let gifData = self.viewModel.getCell(indexPath.row) else {
            return
        }
        let detailViewController = DetailViewController(gifId: gifData.id)
                                                        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let possibleCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        guard let cell = possibleCell as? MainCollectionViewCell,
              let data:GifObject = self.viewModel.getCell(indexPath.row) else {
            return possibleCell
        }
        cell.loadData(gifData: data)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
}
