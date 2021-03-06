//
//  CropperConfiguration.swift
//  BannerImageCropper
//
//  Created by Yulia Novikova on 2/10/22.
//

import UIKit

public typealias BannerCropperCompletion = (_ croppedImage: UIImage?, _ cropController: UIViewController) -> Void
public typealias BannerCropperDismissCompletion = (_ cropController: UIViewController) -> Void

public enum ImageAlignment {
    case top
    case center
    case bottom
}

public struct BannerCropperCofiguration {
    
    public var bannerHeight: CGFloat = 120
    public var image: UIImage
    public var displayGrid = false
    public var gridColor: UIColor?
    public var dimColor: UIColor?
    public var cropAreaBorderColor: UIColor?
    public var cropAreaBorderWidth: CGFloat?
    public var closeButtonText = "Back"
    public var saveButtonText = "Save"
    public var saveButtonFont: UIFont = .systemFont(ofSize: 14)
    public var closeButtonFont: UIFont = .systemFont(ofSize: 14)
    public var saveButtonTint: UIColor = .white
    public var closeButtonTint: UIColor = .white
    public var saveButtonBackground: UIColor = .blue
    public var closeButtonBackground: UIColor = .white
    public var cropperViewBackgroundColor: UIColor = .black
    public var closeButtonCornerRadius: CGFloat = 0
    public var cropButtonCornerRadius: CGFloat = 0
    public var cropperViewCornerRadius: CGFloat = 0
    public var topBarSeparatorColor: UIColor = .separator
    public var cropperImagePosition: ImageAlignment = .center

    public var titleText: String?
    public var titleFont: UIFont = .systemFont(ofSize: 14)
    public var titleColor: UIColor = .black
    
    public init(image: UIImage) {
        self.image = image
    }

}
