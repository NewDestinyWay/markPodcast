//
//  NavViewConfig.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 26.08.2023.
//

import UIKit

struct NavViewConfig {
    var leftBtnTitle: String? {
        didSet {
            isLeftBtnHidden = leftBtnTitle == nil && leftBtnImage == nil
        }
    }
    var leftBtnImage: UIImage? {
        didSet {
            isLeftBtnHidden = leftBtnTitle == nil && leftBtnImage == nil
        }
    }
    
    var title: String?
    
    var rightBtnTitle: String? {
        didSet {
            isRightBtnHidden = rightBtnTitle == nil && rightBtnImage == nil
        }
    }
    var rightBtnImage: UIImage? {
        didSet {
            isRightBtnHidden = rightBtnTitle == nil && rightBtnImage == nil
        }
    }
    
    var delegate: NavViewDelegate?
    
    private(set) var isLeftBtnHidden = true
    private(set) var isRightBtnHidden = true
}
