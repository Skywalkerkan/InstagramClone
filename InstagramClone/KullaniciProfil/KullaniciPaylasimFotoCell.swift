//
//  KullaniciPaylasimFotoCell.swift
//  InstagramClone
//
//  Created by Erkan on 23.03.2023.
//

import UIKit
import SDWebImage

class KullaniciPaylasimFotoCell: UICollectionViewCell{
    
    var paylasim: Paylasim?{
        didSet{
            if let url = URL(string: paylasim?.paylasimGoruntuUrl ?? ""){
                imgFotoPaylasim.sd_setImage(with: url, completed: nil)  //Hücreler 2 kez oluşturuluyor
            }
            
        }
    }
    
    let imgFotoPaylasim: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgFotoPaylasim)
        imgFotoPaylasim.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
