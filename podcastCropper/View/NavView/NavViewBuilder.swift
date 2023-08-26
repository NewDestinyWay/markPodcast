//
//  NavViewBuilder.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 26.08.2023.
//

import Foundation

enum NavViewBuilder {
    case createSnippet
    case categories
    
    func navView(delegate: NavViewDelegate?) -> NavView {
        var config = NavViewConfig()
        config.delegate = delegate
        
        switch self {
        case .createSnippet:
            config.leftBtnImage = nil
            config.leftBtnTitle = "Cancel"
            config.title = "Create Snippet"
            
        case .categories:
            config.leftBtnImage = AssetsManager.Navigation.navArrowLeft.icon
            config.leftBtnTitle = "Back"
            config.title = "Categories"
            config.rightBtnImage = nil
            config.rightBtnTitle = "Add New"
        }
        
        return NavView(config: config)
    }
}
