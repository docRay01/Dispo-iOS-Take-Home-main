//
//  MainViewModel.swift
//  Dispo Take Home
//
//  Created by Davis, R. Steven on 1/9/22.
//

import Foundation

class MainViewModel: NSObject {
    let apiClient = ReferenceContainer.shared.giphyService
    
    weak var view: MainViewController?
    
    private var cellData: [Int: GifObject] = [:]
    private var requestsBeingMade: [Int: Int] = [:]
    
    private var hasCompletedInitialLoad = false
    private var displayedSearchQuery: String?
    
    var numberOfCells: Int {
        if hasCompletedInitialLoad {
            return 5000
        } else {
            return 0
        }
    }
    
    func populateInitialCells() {
        // Wipe the stored cells
        cellData = [:]
        
        if let searchQuery = displayedSearchQuery {
            ReferenceContainer.shared.giphyService.getSearch(query: searchQuery, count: 25, offset: 0) { [weak self] apiListResponse in
            
                guard let self = self else { return }
                print(apiListResponse)
                self.processAPIResults(apiListResponse: apiListResponse, requestOffset: 0)
                self.hasCompletedInitialLoad = true
                self.view?.refreshCollectionView()
            }
        } else {
            ReferenceContainer.shared.giphyService.getTrending(count: 25, offset: 0) { [weak self] apiListResponse in
            
                guard let self = self else { return }
                print(apiListResponse)
                self.processAPIResults(apiListResponse: apiListResponse, requestOffset: 0)
                self.hasCompletedInitialLoad = true
                self.view?.refreshCollectionView()
            }
        }
    }
    
    var queuedSearchString = ""
    func setSearchString(text: String, delaySearch: Bool) {
        queuedSearchString = text
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(doSearch), object: nil)
        if delaySearch {
            self.perform(#selector(doSearch), with: nil, afterDelay: 0.5)
        } else {
            doSearch()
        }
    }
    
    @objc private func doSearch() {
        print ("Ding")
        
        guard !queuedSearchString.isEmpty else {
            displayedSearchQuery = nil
            return
        }
        
        guard self.displayedSearchQuery != queuedSearchString else {
            return
        }
        
        self.displayedSearchQuery = queuedSearchString
        self.populateInitialCells()
    }
    
    func getCell(_ index: Int) -> GifObject? {
        if let gifObject = cellData[index] {
            return gifObject
        } else if hasCompletedInitialLoad {
            // Check to see if there are any requests to get that character open yet.
            let requestOffset = index - (index % 25)
            if requestsBeingMade[requestOffset] == nil {
                // If there is not, open that request
                requestsBeingMade[requestOffset] = index
                
                if let searchQuery = displayedSearchQuery {
                    ReferenceContainer.shared.giphyService.getSearch(query: searchQuery, count: 25, offset: requestOffset) { [weak self] apiListResponse in
                        
                        guard let self = self else { return }
                        self.processAPIResults(apiListResponse: apiListResponse, requestOffset:requestOffset)
                    }
                } else {
                    ReferenceContainer.shared.giphyService.getTrending(count: 25, offset: requestOffset) { [weak self] apiListResponse in
                        
                        guard let self = self else { return }
                        self.processAPIResults(apiListResponse: apiListResponse, requestOffset:requestOffset)
                    }
                }
                
            }
        }
        
        return nil
    }
    
    private func processAPIResults(apiListResponse: APIListResponse, requestOffset: Int) {
        self.requestsBeingMade[requestOffset] = nil
        
        for i in (0 ... apiListResponse.data.count - 1) {
            self.cellData[requestOffset + i] = apiListResponse.data[i]
        }
        
        self.view?.reloadCells(from: requestOffset, count: apiListResponse.data.count)
    }
}
