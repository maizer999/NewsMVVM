//
//  NewsCellViewModel.swift
//  NewsAssessment
//
//  Created by Mohammad Abu Maizer on 6/15/20.
//  Copyright © 2020 Mohammad Abu Maizer. All rights reserved.
//

import Foundation

class  NewsCellViewModel {
    
    var newsTitle: String?
    var newsAuthor: String?
    var newsDate: String?
    var newsImageUrl : String?
   
//
    init( withModel model: NewsModel ) {
        newsTitle    = model.title
        newsAuthor   = model.byline
        newsDate     = model.published_date
        if (model.media?.count ?? 0 > 0) {
            if (model.media?[0].MediaMetadatas?.count ?? 0 > 0) {
                if let mediaURL = model.media?[0].MediaMetadatas?[0].url {
                    newsImageUrl = mediaURL
                }
            }
        }
    }
}
