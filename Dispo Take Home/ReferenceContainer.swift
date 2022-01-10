//
//  ReferenceContainer.swift
//  Dispo Take Home
//
//  Created by Davis, R. Steven on 1/9/22.
//

import Foundation

class ReferenceContainer {
    public private(set) static var shared: ReferenceContainer = ReferenceContainer()
    
    public let giphyService: GifAPIClient = GifAPIClient()

}
