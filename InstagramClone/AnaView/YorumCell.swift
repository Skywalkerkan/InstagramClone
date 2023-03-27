//
//  YorumCell.swift
//  InstagramClone
//
//  Created by Erkan on 27.03.2023.
//

import UIKit
import SDWebImage

class YorumCell: UICollectionViewCell{
    
    var yorum: Yorum?{
        didSet{
            
            guard let yorum = yorum else{return}
         //   guard let goruntuUrl = yorum?.kullanici?.profilGoruntuUrl else{return}
            imageKullaniciPP.sd_setImage(with: URL(string: yorum.kullanici.profilGoruntuUrl), completed: nil)
        //    lblYorum.text = yorum?.yorumMesaji ?? ""
            
           // guard let kullaniciAdi = yorum?.kullanici?.kullaniciAdi else{return}
            let attrText = NSMutableAttributedString(string: yorum.kullanici.kullaniciAdi, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
            attrText.append(NSAttributedString(string: " " + (yorum.yorumMesaji), attributes: [.font: UIFont.systemFont(ofSize: 13)]))
            lblYorum.attributedText = attrText
        }
    }
    
    let imageKullaniciPP: UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
      //  image.backgroundColor = .red
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 50 / 2
        return image
    }()
    
    let lblYorum: UITextView = {
        let label = UITextView()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.isScrollEnabled = false
        label.isEditable = false
       // label.numberOfLines = 0
      //  label.backgroundColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       // backgroundColor = .brown
        addSubview(imageKullaniciPP)
        imageKullaniciPP.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 10, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 50, height: 50)
        
        addSubview(lblYorum)
        lblYorum.anchor(top: topAnchor, bottom: bottomAnchor, leading: imageKullaniciPP.trailingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: -5, paddingLeft: 10, paddingRight: -5, width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
