//
//  Magazzino.swift
//  Quote
//
//  Created by riccardo on 21/02/19.
//  Copyright © 2019 ViewSoftware. All rights reserved.
//

import Foundation

//Struttura Articolo Magazzino ricerca di default
struct ArticoloMagazzinoStruct: Codable {

    var IdArticoloMagazzino: Int!
    var CodArt: String!
    var Descrizione: String!
    var Quantita: Int!
    var Magazzino: String!
    var Fornitore: String!
    var DataInserimento: String!
    var IdMagazzino: Int!
    var Utente: String!
}

//Struttura Magazzino
struct MagazzinoStruct: Codable {
    var IdMagazzino: Int!
    var Nome: String!
    var Indirizzo: String!
    var DataCreazione: String!
}


public class Magazzino {

    var Articolo: ArticoloMagazzinoStruct = ArticoloMagazzinoStruct()
    var u: User = User()

    init(User: User) {
        self.u = User
    }

    init(SetArticolo: ArticoloMagazzinoStruct, User: User) {
        self.u = User
        self.Articolo.IdArticoloMagazzino = SetArticolo.IdArticoloMagazzino!
        self.Articolo.CodArt = SetArticolo.CodArt!
        self.Articolo.Descrizione = SetArticolo.Descrizione!
        self.Articolo.Quantita = SetArticolo.Quantita!
        self.Articolo.Magazzino = SetArticolo.Magazzino!
        self.Articolo.Fornitore = SetArticolo.Fornitore!
        self.Articolo.DataInserimento = SetArticolo.DataInserimento!
        self.Articolo.IdMagazzino = SetArticolo.IdMagazzino!
        self.Articolo.Utente = SetArticolo.Utente!

    }

    func CaricaMagazzini(completion: @escaping ([MagazzinoStruct]) -> ())
    {

        DispatchQueue.global(qos: .userInteractive).async {
            let articolo_temp = MagazzinoModel()
            articolo_temp.CaricaMagazzini(completion: {
                result in
                completion(result)
            })
        }

    }

    func RicercaArticoliMagazzino(CodArt: String, IdMagazzino: Int, Barcode: String, completion: @escaping ([ArticoloMagazzinoStruct]) -> ())
    {

        DispatchQueue.global(qos: .userInteractive).async {
            let articolo_temp = MagazzinoModel()

            articolo_temp.RicercaArticoliMagazzino(CodArt: CodArt, IdMagazzino: IdMagazzino, Barcode: Barcode, completion: {
                result in
                completion(result)
            })
        }

    }

    public func Aggiorna(Quantita: Int, QuantitaPrecedente: Int, IdMagazzino2: Int, Modalita: String,Descrizione:String ,completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let articolo_temp = MagazzinoModel()

            var idtemp: Int = IdMagazzino2
            if(!(idtemp > 0)) {

                idtemp = 0
            }

            print("\n Controller: IdMagazzino2 vale: \(IdMagazzino2)")
            articolo_temp.Aggiorna(IdArticoloMagazzino: self.Articolo.IdArticoloMagazzino!, IdMagazzino1: self.Articolo.IdMagazzino!, IdMagazzino2: idtemp, Quantita: Quantita, QuantitaPrecedente: QuantitaPrecedente, IdUtente: self.u.GetIdUtente(), Modalita: Modalita,Descrizione: Descrizione, completion: {
                    result in
                    completion(result)
                })
        }

    }

}
