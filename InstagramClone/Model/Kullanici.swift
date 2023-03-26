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
  //  let takipciSayisi: Int
  //  let takipSayisi: Int
    
    init(kullaniciVerisi: [String: Any]){
        self.kullaniciAdi = kullaniciVerisi["KullaniciAdi"] as? String ?? ""
        self.kullaniciID = kullaniciVerisi["KullaniciID"] as? String ?? ""
        self.profilGoruntuUrl = kullaniciVerisi["ProfilGoruntuURL"] as? String ?? ""
     //   self.takipciSayisi = kullaniciVerisi["TakipciSayisi"] as? Int ?? 0
    //    self.takipSayisi = kullaniciVerisi["TakipSayisi"] as? Int ?? 0
    }
}
