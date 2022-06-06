//
//  MagazzinoModel.swift
//  Quote
//
//  Created by riccardo on 21/02/19.
//  Copyright © 2019 ViewSoftware. All rights reserved.
//

import Foundation

//Classe che rappresenta il Magazzino
class MagazzinoModel {

    //Costruttore
    init() {

    }

    //Caricamento Magazzini
    func CaricaMagazzini(completion: @escaping ([MagazzinoStruct]) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["CodArt": ""]
            jsonrequest.GetArray(Tipo: "MagazzinoStruct", Router: "/magazzino/carica", ValueArray: jsonarray, completion: { result in
                completion(result as! [MagazzinoStruct])
            })
        }
    }

    //Ricerca Articoli in Magazzino
    func RicercaArticoliMagazzino(CodArt: String, IdMagazzino: Int, Barcode: String, completion: @escaping ([ArticoloMagazzinoStruct]) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["CodArt": CodArt, "IdMagazzino": IdMagazzino, "Barcode": Barcode]
            jsonrequest.GetArray(Tipo: "ArticoloMagazzino", Router: "/magazzino/recuperaarticoli", ValueArray: jsonarray, completion: { result in
                completion(result as! [ArticoloMagazzinoStruct])
            })
        }
    }

    //Router per il movimento degli articoli in magazzino
    func Aggiorna(IdArticoloMagazzino: Int, IdMagazzino1: Int, IdMagazzino2: Int, Quantita: Int, QuantitaPrecedente: Int, IdUtente: Int, Modalita: String, Descrizione:String,completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["Descrizione": Descrizione,"IdPreventivo": 0, "IdArticoloMagazzino": IdArticoloMagazzino, "IdMagazzino1": IdMagazzino1, "IdMagazzino2": IdMagazzino2, "Quantita": Quantita, "QuantitaPrecedente": QuantitaPrecedente, "IdUtente": IdUtente, "Modalita": Modalita]
            jsonrequest.GetSingleValue(Router: "/magazzino/aggiornaarticolo", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }
    }
}

