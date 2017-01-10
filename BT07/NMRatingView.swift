//
//  NMRatingView.swift
//  BT07
//
//  Created by Unima-TD-04 on 12/1/16.
//  Copyright © 2016 Unima-TD-04. All rights reserved.
//

import UIKit

@IBDesignable class NMRatingView: UIView {

    var emptyImageViews: [UIImageView] = []
    var fullImageViews: [UIImageView] = []
    var imageContentMode: UIViewContentMode = UIViewContentMode.scaleAspectFit
    
    var minImageSize: CGSize = CGSize(width: 5.0, height: 5.0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initImageViews()
        refresh()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initImageViews()
        refresh()
    }
    
	

    
    @IBInspectable var emptyImage: UIImage? {
        didSet {
            for imageView in emptyImageViews {
                imageView.image = emptyImage
                refresh()
            }
            
        }
    }
    
    @IBInspectable var fullImage: UIImage? {
        didSet {
            for imageView in fullImageViews {
                imageView.image = fullImage
            }
            refresh()
        }
    }
    
    @IBInspectable var minRating: Int  = 0 {
        didSet {

            if rating < minRating {
                rating = minRating
                refresh()
            }
        }
    }
    
    @IBInspectable var maxRating: Int = 0 {
        didSet {
            if maxRating != oldValue {
                removeImageViews()
                initImageViews()
                setNeedsLayout()
                refresh()
            }
        }
    }
    
    @IBInspectable var rating: Int = 1 {
        didSet {
            if rating != oldValue {
                refresh()
            }
        }
    }
    
    var editable: Bool = true
    
    func initImageViews() {
        guard emptyImageViews.isEmpty && fullImageViews.isEmpty else {
            return
        }
        
        // Add new image views
        for _ in 0..<maxRating {
            let emptyImageView = UIImageView()
            emptyImageView.contentMode = imageContentMode
            emptyImageView.image = emptyImage
            emptyImageViews.append(emptyImageView)
            addSubview(emptyImageView)
            
            let fullImageView = UIImageView()
            fullImageView.contentMode = imageContentMode
            fullImageView.image = fullImage
            fullImageViews.append(fullImageView)
            addSubview(fullImageView)
        }
    }
    
    func refresh() {
        for i in 0..<fullImageViews.count {
            let imageView = fullImageViews[i]
            
            if rating >= (i+1) {
                imageView.layer.mask = nil
                imageView.isHidden = false
            } else if rating > i && rating < (i+1) {
                let maskLayer = CALayer()
                maskLayer.frame = CGRect(x: 0, y: 0, width: CGFloat(rating)*imageView.frame.size.width, height: imageView.frame.size.height)
                maskLayer.backgroundColor = UIColor.black.cgColor
                imageView.layer.mask = maskLayer
                imageView.isHidden = false
            } else {
                imageView.layer.mask = nil
                imageView.isHidden = true
            }
        }
    }
    
    //---------------Size Image
    func sizeForImage(image: UIImage, inSize size: CGSize) -> CGSize {
        let imageRatio = image.size.width / image.size.height
        let viewRatio = size.width / size.height
        
        if imageRatio < viewRatio {
            let scale = size.height / image.size.height
            let width = scale * image.size.width
            
            return CGSize(width: width, height: size.height)
        } else {
            let scale = size.width / image.size.width
            let height = scale * image.size.height
            
            return CGSize(width: size.width, height: height)
        }
    }
    
    func removeImageViews() {
        for i in 0..<emptyImageViews.count {
            var imageView = emptyImageViews[i]
            imageView.removeFromSuperview()
            imageView = fullImageViews[i]
            imageView.removeFromSuperview()
        }
        emptyImageViews.removeAll(keepingCapacity: false)
        fullImageViews.removeAll(keepingCapacity: false)
    }

    
    func updateLocation(touch: UITouch) {
        guard editable else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        var newRating: Int = 0
        for i in stride(from: (maxRating-1), through: 0, by: -1) {
            let imageView = emptyImageViews[i]
            guard touchLocation.x > imageView.frame.origin.x else {
                continue
            }
            let newLocation = imageView.convert(touchLocation, from: self)
            if imageView.point(inside: newLocation, with: nil) {
                newRating = i + 1
            }
            break
        }
        
        rating = newRating < minRating ? minRating : newRating
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let emptyImage = emptyImage else {
            return
        }
        
        let desiredImageWidth = frame.size.width / CGFloat(emptyImageViews.count)
        let maxImageWidth = max(minImageSize.width, desiredImageWidth)
        let maxImageHeight = max(minImageSize.height, frame.size.height)
        let imageViewSize = sizeForImage(image: emptyImage, inSize: CGSize(width: maxImageWidth, height: maxImageHeight))
        let imageXOffset = (frame.size.width - (imageViewSize.width * CGFloat(emptyImageViews.count))) /
            CGFloat((emptyImageViews.count - 1))
        
        for i in 0..<maxRating {
            let imageFrame = CGRect(x: i == 0 ? 0 : CGFloat(i)*(imageXOffset+imageViewSize.width), y: 0, width: imageViewSize.width, height: imageViewSize.height)
            
            var imageView = emptyImageViews[i]
            imageView.frame = imageFrame
            
            imageView = fullImageViews[i]
            imageView.frame = imageFrame
        }
        
        refresh()
    }
    
    override var intrinsicContentSize: CGSize {

        return CGSize(width: self.frame.size.width, height: self.frame.size.width/CGFloat((rating+1)+1))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        updateLocation(touch: touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        updateLocation(touch: touch)
    }
}
