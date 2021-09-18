//
//  UIImage+imageWithImage.swift
//  Music ++
//
//  Created by QUANG on 1/21/17.
//  Copyright © 2017 Q.U.A.N.G. All rights reserved.
//

extension UIImage
{
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!;
    }
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

extension UITableView {
    var capturedImage: UIImage {
        UIGraphicsBeginImageContext(contentSize);
        scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: UITableViewScrollPosition.top, animated: false)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let row = numberOfRows(inSection: 0)
        let numberofRowthatShowinscreen = 4
        let scrollCount = row / numberofRowthatShowinscreen
        
        for i in 0 ..< scrollCount  {
            scrollToRow(at: NSIndexPath(row: (i+1)*numberofRowthatShowinscreen, section: 0) as     IndexPath, at: UITableViewScrollPosition.top, animated: false)
            layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return image;
    }
}
