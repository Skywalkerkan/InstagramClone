//
//  Yorum.swift
//  InstagramClone
//
//  Created by Erkan on 27.03.2023.
//

import Foundation

struct Yorum{
    
    let kullanici: Kullanici
    let yorumMesaji: String
    let kullaniciID: String
    
    init(kullanici: Kullanici, sozlukVerisi: [String: Any]) {
        self.kullanici = kullanici
        self.yorumMesaji = sozlukVerisi["yorumMesaji"] as? String ?? ""
        self.kullaniciID = sozlukVerisi["kullaniciID"] as? String ?? ""
    }
    
}
