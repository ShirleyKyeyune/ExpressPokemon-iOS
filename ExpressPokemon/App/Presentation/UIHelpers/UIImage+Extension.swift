//
//  UIImage+Extension.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import UIKit

extension UIImage {
    /// Average color of the image, nil if it cannot be found
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }

        let xOrigin = inputImage.extent.origin.x + (size.width / 3)
        let yOrigin = inputImage.extent.origin.y + (size.height / 3)
        let extentVector = CIVector(
            x: xOrigin,
            y: yOrigin,
            z: inputImage.extent.size.width / 3,
            w: inputImage.extent.size.height / 3
        )

        guard let filter = CIFilter(
            name: "CIAreaAverage",
            parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]
        ), let outputImage = filter.outputImage else {
            return nil
        }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])

        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )

        return UIColor(
            red: CGFloat(bitmap[0]) / 255,
            green: CGFloat(bitmap[1]) / 255,
            blue: CGFloat(bitmap[2]) / 255,
            alpha: CGFloat(bitmap[3]) / 255
        )
    }

    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        color.setFill()
        UIRectFill(rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
              let cgImage = image.cgImage else {
            return nil
        }
        UIGraphicsEndImageContext()
        self.init(cgImage: cgImage)
    }

    var withMonoEffect: UIImage? {
        guard let filter = CIFilter(name: "CIPhotoEffectMono"),
              let ciImage = CIImage(image: self) else { return nil }

        filter.setValue(ciImage, forKey: kCIInputImageKey)

        guard let output = filter.outputImage,
              let image = CIContext().createCGImage(output, from: output.extent) else {
            return nil
        }

        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }
}
