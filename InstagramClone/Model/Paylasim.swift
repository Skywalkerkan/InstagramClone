//
//  Paylasim.swift
//  InstagramClone
//
//  Created by Erkan on 23.03.2023.
//

import Firebase
import FirebaseFirestore


struct Paylasim{
    let kullanici: Kullanici
    let paylasimGoruntuUrl: String?
    let goruntuGenislik : Double?
    let goruntuYukseklik: Double?
    let kullaniciID: String?
    let mesaj: String?
    let paylasimTarihi: Timestamp
    
    init(kullanici: Kullanici, sozlukVerisi: [String : Any]){
        self.kullanici = kullanici
        self.paylasimGoruntuUrl = sozlukVerisi["PaylasimlGoruntuUrl"] as? String
        self.goruntuGenislik = sozlukVerisi["GoruntuGenislik"] as? Double
        self.goruntuYukseklik = sozlukVerisi["GoruntuYukseklik"] as? Double
        self.kullaniciID = sozlukVerisi["KullaniciID"] as? String
        self.mesaj = sozlukVerisi["Mesaj"] as? String
        self.paylasimTarihi = sozlukVerisi["PaylasimTarihi"] as? Timestamp ?? Timestamp(date: Date())
    }
    
}
