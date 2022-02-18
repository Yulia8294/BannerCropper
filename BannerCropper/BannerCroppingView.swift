//
//  TestView.swift
//  BannerCroppingView
//
//  Created by Yulia Novikova on 2/10/22.
//

import UIKit

class BannerCroppingView: UIView {
    
    private var config: BannerCropperCofiguration!

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var bannerView: CroppingAreaView = {
        let banner = CroppingAreaView()
        banner.isUserInteractionEnabled = false
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    private lazy var dimView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure(with configuration: BannerCropperCofiguration) {
        self.config = configuration
        
        bannerView.configure(with: CroppingAreaViewModel(gridColor:    configuration.gridColor,
                                                         displaysGrid: configuration.displayGrid,
                                                         borderColor:  configuration.cropAreaBorderColor,
                                                         borderWidth:  configuration.cropAreaBorderWidth))
        
        imageView.image         = config.image
        dimView.backgroundColor = config.cropperViewBackgroundColor
        backgroundColor         = config.cropperViewBackgroundColor
        
        constraintLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMinZoomScaleForSize(bounds.size)
        alignContent(position: config.cropperImagePosition)
        updateDimmingMaskFrame()
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        addSubview(bannerView)
        addSubview(dimView)
    }
    
    private func configure() {
       addSubviews()
    }
    
    //MARK: - Layout setup
    
    private func alignContent(position: ImageAlignment) {
        switch position {
        case .top:
            scrollView.setContentOffset(.zero, animated: false)
        case .center:
            let height = imageView.realImageRect().height
            let centerOffsetY = (height - scrollView.frame.size.height) / 2
            scrollView.setContentOffset(CGPoint(x: 0, y: centerOffsetY), animated: false)
        case .bottom:
            let contentOffsetY = scrollView.frame.size.height - bannerView.frame.height
            scrollView.setContentOffset(CGPoint(x: 0, y: contentOffsetY), animated: false)
        }
    }
    
    private func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
//        let heightScale = size.height / imageView.bounds.height
//        let minScale = min(widthScale, heightScale)
        let minScale = widthScale
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    private func constraintLayout() {
        NSLayoutConstraint.activate([
            bannerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: config.bannerHeight),
            
            scrollView.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: bannerView.heightAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            dimView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimView.topAnchor.constraint(equalTo: topAnchor),
            dimView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        switch config.cropperImagePosition {
        case .center:
            NSLayoutConstraint.activate([
                bannerView.centerYAnchor.constraint(equalTo: centerYAnchor),
                bannerView.centerXAnchor.constraint(equalTo: centerXAnchor),
                scrollView.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor),
                scrollView.centerXAnchor.constraint(equalTo: bannerView.centerXAnchor)
            ])
        case .top:
            NSLayoutConstraint.activate([
                bannerView.topAnchor.constraint(equalTo: topAnchor),
                scrollView.topAnchor.constraint(equalTo: bannerView.topAnchor)
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                bannerView.bottomAnchor.constraint(equalTo: bottomAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
        }
    }
    
    private func updateDimmingMaskFrame() {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = dimView.bounds
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        let path = UIBezierPath(rect: dimView.bounds)
        path.append(UIBezierPath(rect: bannerView.frame))
        maskLayer.path = path.cgPath
        dimView.layer.mask = maskLayer
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self { return scrollView }
        return view
    }

}

extension BannerCroppingView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

//MARK: - Cropping image

extension BannerCroppingView {
    
    func croppedImage() -> UIImage? {
        let visibleRect = calcVisibleRectForResizeableCropArea()
        
        guard let image = imageView.image,
              let cropped = image.cgImage?.cropping(to: visibleRect) else {
                  print("Error when cropping")
                  return nil
              }
        return UIImage(cgImage: cropped, scale: image.scale, orientation: image.imageOrientation)
    }
    
    private func calcVisibleRectForResizeableCropArea() -> CGRect {
        var sizeScale = self.imageView.image!.size.width / self.imageView.frame.size.width
        sizeScale *= self.scrollView.zoomScale
        var visibleRect = bannerView.convert(bannerView.bounds, to: imageView)
        visibleRect = CroppingAreaView.scaleRect(rect: visibleRect, scale: sizeScale)
        return visibleRect
    }
}

