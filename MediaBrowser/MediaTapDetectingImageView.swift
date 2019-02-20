//
//  MediaTapDetectingImageView.swift
//  MediaBrowser
//
//  Created by Seungyoun Yi on 2017. 9. 6..
//  Copyright © 2017년 Seungyoun Yi. All rights reserved.
//
//

import Foundation

class MediaTapDetectingImageView: UIImageView {
    weak var tapDelegate: TapDetectingImageViewDelegate?
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)));
    
    @objc func longTap(_ sender: UIGestureRecognizer) {
        tapDelegate?.longTapDetectedInImageView(view: self, at: sender.location(in: self), state: sender.state)
    }
    
    override var transform: CGAffineTransform {
        get {return super.transform}
        set {
            super.transform = newValue
            for v in subviews {
                v.transform = self.transform.inverted()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        addGestureRecognizer(longPressGesture);
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        isUserInteractionEnabled = true
        addGestureRecognizer(longPressGesture);
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        isUserInteractionEnabled = true
        addGestureRecognizer(longPressGesture);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first  {
            let tapCount = touch.tapCount
            
            switch tapCount {
            case 1: handleSingleTap(touch: touch)
            case 2: handleDoubleTap(touch: touch)
            case 3: handleTripleTap(touch: touch)
            default: break
            }
        }
        
        next?.touchesEnded(touches, with: event)
    }
    private func handleSingleTap(touch: UITouch) {
        tapDelegate?.singleTapDetectedInImageView(view: self, touch: touch)
    }

    private func handleDoubleTap(touch: UITouch) {
        tapDelegate?.doubleTapDetectedInImageView(view: self, touch: touch)
    }

    private func handleTripleTap(touch: UITouch) {
        tapDelegate?.tripleTapDetectedInImageView(view: self, touch: touch)
    }
}

protocol TapDetectingImageViewDelegate: class {
    func singleTapDetectedInImageView(view: UIImageView, touch: UITouch)
    func doubleTapDetectedInImageView(view: UIImageView, touch: UITouch)
    func tripleTapDetectedInImageView(view: UIImageView, touch: UITouch)
    func longTapDetectedInImageView(view: UIImageView, at: CGPoint, state: UIGestureRecognizerState)
}
