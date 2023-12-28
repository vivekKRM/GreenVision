//
//  ShowImageVC.swift
//  Cleansing
//
//  Created by United It Services on 13/09/23.
//

import UIKit

class ShowImageVC: UIViewController , UIScrollViewDelegate {

        var imageView: UIImageView!
        var image: String?
        
        var scrollView: UIScrollView!

        override func viewDidLoad() {
            super.viewDidLoad()

            // Create and configure the scroll view
            scrollView = UIScrollView(frame: view.bounds)
            scrollView.delegate = self
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 5.0
//            scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(scrollView)

            // Create and configure the image view
            imageView = UIImageView()
            imageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width * 1.0, height: UIScreen.main.bounds.height * 1.0))
            getImageFromURL(imageView: imageView, stringURL: image ?? "")
//            imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            // Set up zooming properties
            scrollView.contentSize = imageView.frame.size

            // Add a double-tap gesture recognizer for zooming
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            scrollView.addGestureRecognizer(doubleTapGesture)
        }

        @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
            if scrollView.zoomScale == scrollView.minimumZoomScale {
                let zoomRect = zoomRectForScale(scrollView.maximumZoomScale, center: sender.location(in: sender.view))
                scrollView.zoom(to: zoomRect, animated: true)
            } else {
                scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            }
        }

        func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
            let size = CGSize(
                width: scrollView.frame.size.width / scale,
                height: scrollView.frame.size.height / scale
            )
            let origin = CGPoint(
                x: center.x - size.width / 2.0,
                y: center.y - size.height / 2.0
            )
            return CGRect(origin: origin, size: size)
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
        }
    }
