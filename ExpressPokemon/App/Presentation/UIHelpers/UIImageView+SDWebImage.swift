//
//  UIImageView+SDWebImage.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import UIKit
import SDWebImage

extension UIImageView {
    func loadRemoteImage(_ url: String, completion: ((_ image: UIImage?) -> Void)? = nil) {
        self.sd_setImage(
            with: URL(string: url),
            placeholderImage: UIImage(named: "placeholder")
        ) { image, _, _, _ in
                DispatchQueue.main.async {
                    completion?(image)
                }
        }
    }
}
