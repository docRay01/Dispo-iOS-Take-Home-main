//
//  DetailViewModel.swift
//  Dispo Take Home
//
//  Created by Davis, R. Steven on 1/9/22.
//

import Foundation

class DetailViewModel {
    private(set) var gifData: GifObject?
    
    weak var view: DetailViewController?
    
    func loadSearchResult(id: String) {
        ReferenceContainer.shared.giphyService.getGifDetails(gifID: id) { [weak self] apiInfoResponse in
            guard let self = self else {
                return
            }
            
            self.gifData = apiInfoResponse.data
            self.view?.refreshView()
        }
    }
}
