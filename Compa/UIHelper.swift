//
//  UIHelper.swift
//  Compa
//
//  Created by MacBook Pro on 5/9/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit


public extension UIView {
    public func round() {
        let width = bounds.width < bounds.height ? bounds.width : bounds.height
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: bounds.midX - width / 2, y: bounds.midY - width / 2), size: CGSize(width: width, height: width))).cgPath
        self.layer.mask = mask
    }
}

// http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
// imageView.downloadedFrom(link: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png")
public extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
