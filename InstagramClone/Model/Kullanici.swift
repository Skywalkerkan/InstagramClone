//
//  Kullanici.swift
//  InstagramClone
//
//  Created by Erkan on 19.03.2023.
//

import Foundation


struct Kullanici{
    let kullaniciAdi: String
    let kullaniciID: String
    let profilGoruntuUrl: String
    
    init(kullaniciVerisi: [String: Any]){
        self.kullaniciAdi = kullaniciVerisi["KullaniciAdi"] as? String ?? ""
        self.kullaniciID = kullaniciVerisi["KullaniciID"] as? String ?? ""
        self.profilGoruntuUrl = kullaniciVerisi["ProfilGoruntuURL"] as? String ?? ""
    }
}
