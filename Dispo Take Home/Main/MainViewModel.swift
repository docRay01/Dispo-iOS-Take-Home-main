//
//  MainViewModel.swift
//  Dispo Take Home
//
//  Created by Davis, R. Steven on 1/9/22.
//

import Foundation

class MainViewModel {
    let apiClient = ReferenceContainer.shared.giphyService
    
    var listResponse: APIListResponse?
    
    var numberOfCells: Int {
        if listResponse == nil {
            ReferenceContainer.shared.giphyService.getTrending(count: 25, offset: 0) { apiListResponse in
                print(apiListResponse)
            }
        }
        
        // TODO: Connect to the APIs
        return 10
    }
}
