//
//  FotografSeciciHeader.swift
//  InstagramClone
//
//  Created by Erkan on 23.03.2023.
//

import UIKit


class FotografSeciciHeader: UICollectionViewCell{
    let imgHeader: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .purple
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgHeader)
        imgHeader.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
