//
//  UIViewController.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 02.08.2023.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "", message: String = "") {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(vc, animated: true)
    }
    
    func showAlertInMainThread(title: String = "", message: String = "") {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { fatalError("can't grab self: UIViewController extension")}
            let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
            self.present(vc, animated: true)
        }
    }
}
