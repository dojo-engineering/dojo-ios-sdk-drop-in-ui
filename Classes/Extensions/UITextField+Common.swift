//
//
//  Created by Deniss Kaibagarovs on 05/04/2021.
//

import Foundation

extension UITextField {
    func leftImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        setImage(image, imageWidth: imageWidth, padding: padding, itemView: &leftView, viewMode: &leftViewMode)
        
    }
    
    func rightImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        setImage(image, imageWidth: imageWidth, padding: padding, itemView: &rightView, viewMode: &rightViewMode)
    }
    
    private func setImage(_ image: UIImage?,
                          imageWidth: CGFloat,
                          padding: CGFloat,
                          itemView: inout UIView?,
                          viewMode: inout UITextField.ViewMode) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageWidth, height: frame.height)
        imageView.contentMode = .scaleAspectFit
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(imageView)
        itemView = containerView
        viewMode = .always
    }
}
