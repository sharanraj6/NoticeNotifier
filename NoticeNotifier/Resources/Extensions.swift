//
//  Extensions.swift
//  NoticeNotifier
//
//  Created by Sai Sharan Raj Parepalli on 11/02/21.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
 
    var text: String
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
 
        textView.font = UIFont(name: "AvenirNext-Regular", size: 13)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = false
        textView.isUserInteractionEnabled = true
 
        return textView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var animate: Bool
    let activityIndicatorStyle: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let loadingView = UIActivityIndicatorView(style: activityIndicatorStyle)
        return loadingView
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        animate ? uiView.startAnimating() : uiView.stopAnimating()
    }
}


/// This funciton fetches the images from specific URL
/// - Parameters:
///   - from: Address of the Image
///   - closure: Closure which sends back the Image
func fetchImage(from: URL, closure: @escaping ((_ gotData: UIImage) -> Void)) {
    let session = URLSession.shared
    let placeHolderImage = UIImage(imageLiteralResourceName: "image_placeholder")
    let dataTask = session.dataTask(with: from) { (data, response, error) in
        if error != nil {
            closure(placeHolderImage)
        } else {
            guard let imageData = data, let image = UIImage(data: imageData)  else { return }
            closure(image)
        }
    }
    dataTask.resume()
}
