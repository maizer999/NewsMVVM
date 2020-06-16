//
//  NewsMainViewModel.swift
//  NewsAssessment
//
//  Created by Mohammad Abu Maizer on 6/15/20.
//  Copyright © 2020 Mohammad Abu Maizer. All rights reserved.
//

import Foundation

class NewsMainViewModel {

    var newsData:   Bindable<[NewsModel]>?

    var lastTotalItems: Int = 0
    var index:  Int    = 1
    let count:  Int    = 30
    var sortBy: String = ""
    let order:  String = ""

    
    var showLoadingHud: Bindable<Bool>?
    var onLoadData:            (() -> Void)?
    var onLoadFailed:          ((_ error:Error? ) -> Void)?
    
    
    func loadInitial(){
        
        self.index = 1
        self.newsData?.value.removeAll()
        self.newsData?.value = []
        
        loadNews()
        
    }
    
    func loadNext(){
        
        self.index += 1
        
        loadNews()
        
    }
    
    func loadNews() {
        
        self.showLoadingHud?.value = true
        
        WebServices.getNews(query: "", page: self.index, size: self.count, sortby: self.sortBy, order: self.order, result: { status, newAppointments, totalItems in
            
            self.showLoadingHud?.value = false
            
            if status > 0 {
                
                self.lastTotalItems = totalItems
                
                self.newsData?.value = (self.newsData?.value ?? []) + newAppointments
                
                self.onLoadData?()
                
            } else {
                self.onLoadFailed?( WebServiceError.unknownError )
            }
            
            return ()
            
        }, onFailure: { error in
            
            self.showLoadingHud?.value = false
            
            self.onLoadFailed?( error )
            
            return ()
            
        })
        
    }
}

