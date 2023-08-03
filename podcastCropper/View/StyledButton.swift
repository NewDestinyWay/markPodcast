//
//  StyledButton.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 03.08.2023.
//

import UIKit

final class StyledButton: UIButton {
    // MARK: - Interface
    var font: UIFont? {
        didSet {
            if #available(iOS 15, *) {
                var config = getConfig()
                config.set(font: font)
                self.configuration = config
            } else {
                self.titleLabel?.font = font
            }
        }
    }
    
    var title: String? {
        didSet {
            if #available(iOS 15, *) {
                var config = getConfig()
                config.title = title
                self.configuration = config
            } else {
                self.setTitle(title, for: .normal)
            }
        }
    }
    
    var titleColor: UIColor? {
        didSet {
            if #available(iOS 15, *) {
                var config = getConfig()
                config.baseForegroundColor = titleColor
                self.configuration = config
            } else {
                self.setTitleColor(titleColor, for: .normal)
            }
        }
    }
    
    var image: UIImage? {
        didSet {
            if #available(iOS 15, *) {
                var config = getConfig()
                config.image = image
                self.configuration = config
            } else {
                self.setImage(image, for: .normal)
            }
        }
    }
    
    var imagePadding: CGFloat? {
        didSet {
            if #available(iOS 15, *) {
                var config = getConfig()
                config.imagePadding = imagePadding ?? config.imagePadding
                self.configuration = config
            } else {
                self.imageEdgeInsets.right = imagePadding ?? self.imageEdgeInsets.right
            }
        }
    }
    
    /// constant = 48; Find this constraint in commonInit()
    var defaultHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Override
    override var backgroundColor: UIColor? {
        didSet {
            if #available(iOS 15, *) {
                var config = getConfig()
                config.baseBackgroundColor = backgroundColor
                self.configuration = config
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Private
    private func commonInit() {
        self.layer.cornerRadius = 16
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.defaultHeightConstraint = heightAnchor.constraint(equalToConstant: 48)
        self.defaultHeightConstraint?.isActive = true
        
        self.imagePadding = 10
        self.font = UIFont.systemFont(ofSize: 14)
//        self.font = FontMaker.getFont(fontSize: 14, fontWeight: 700)
    }
    
    private func getConfig() -> UIButton.Configuration {
        return self.configuration ?? UIButton.Configuration.plain()
    }
}

// MARK: - Interface
extension StyledButton {
    func setImage(imgName: String,
                  imgSize: CGSize,
                  imgColor: UIColor,
                  forState state: UIControl.State = .normal) {
        
        let styledImage = UIImage(named: imgName)?.resize(toSize: imgSize).withTintColor(imgColor)
        
        if #available(iOS 15, *) {
            var config = getConfig()
            config.image = styledImage
            self.configuration = config
        } else {
            self.setImage(styledImage, for: state)
        }
    }
}

