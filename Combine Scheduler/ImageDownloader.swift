//
//  ImageDownloader.swift
//  Combine Scheduler
//
//  Created by Hossam on 08/03/2021.
//


import Foundation
import UIKit
class ImageDownloadOperation : AsyncOperation {
    var downloadedImage : UIImage?
    let imageUrl : String
    let completion : (UIImage?)->Void
    var task : URLSessionTask?
    init(imageUrl : String , completion : @escaping (UIImage?)->Void) {
        self.imageUrl = imageUrl
        self.completion = completion
        super.init()
        qualityOfService = .background
    }
    
    
    
    override func main() {
        
        guard !isCancelled else {state = .finished  ; return}
        print(Thread.current , "📉")
        if let url = URL(string: imageUrl) {
            state = .executing
            task = URLSession.shared.dataTask(with: url , completionHandler:{ [weak self ]   data , response , error  in
                if let data = data {
                    let downloadedImage  = UIImage(data: data)
                    self?.state = .finished
                    self?.completion(downloadedImage)
                }
            })
            task?.resume()
            guard !isCancelled else {state = .finished ; task?.cancel() ; return}
        }
    }
}
