//
//  DetailViewModel.swift
//  Dispo Take Home
//
//  Created by Davis, R. Steven on 1/9/22.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func refreshView()
}

class DetailViewModel {
    private(set) var gifData: GifObject?
    
    weak var view: DetailViewModelDelegate?
    
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
