//
//  NavView.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 26.08.2023.
//

import UIKit

protocol NavViewDelegate {
    func leftBtnTapped()
    func rightBtnTapped()
}

final class NavView: UIView {
    // MARK: - Vars
    private var delegate: NavViewDelegate?
    
    // MARK: - UI
    private let leftBtn: StyledButton = {
        let btn = StyledButton()
        btn.titleColor = .blue
        btn.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        btn.widthAnchor.constraint(equalToConstant: 64).isActive = true
        return btn
    }()
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()
    private let rightBtn: StyledButton = {
        let btn = StyledButton()
        btn.titleColor = .blue
        btn.widthAnchor.constraint(equalToConstant: 64).isActive = true
        return btn
    }()
    
    // MARK: - Init
    init(config: NavViewConfig) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(viewConfig cfg: NavViewConfig = NavViewConfig()) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        leftBtn.attachTo(view: self, toSides: [.centerY])
        titleLbl.attachTo(view: self, toSides: [.centerY, .centerX])
        rightBtn.attachTo(view: self, toSides: [.centerY])
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 48),
            leftBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            rightBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        ])
        
        leftBtn.title = cfg.leftBtnTitle
        leftBtn.image = cfg.leftBtnImage
        leftBtn.isHidden = cfg.isLeftBtnHidden
        leftBtn.addTarget(self, action: #selector(leftBtnTapped), for: .touchUpInside)
        
        titleLbl.text = cfg.title
        
        rightBtn.title = cfg.rightBtnTitle
        rightBtn.image = cfg.rightBtnImage
        rightBtn.isHidden = cfg.isRightBtnHidden
        rightBtn.addTarget(self, action: #selector(rightBtnTapped), for: .touchUpInside)
        
        delegate = cfg.delegate
    }
}

// MARK: - Actions
private extension NavView {
    @objc func leftBtnTapped() {
        delegate?.leftBtnTapped()
    }
    
    @objc func rightBtnTapped() {
        delegate?.rightBtnTapped()
    }
}
