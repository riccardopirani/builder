//
//  Ristorante.swift
//  Quote
//
//  Created by riccardo on 25/11/2019.
//  Copyright © 2019 ViewSoftware. All rights reserved.
//


import Foundation

//Struttura che rappresenta il ristorante
struct RistoranteStruct: Codable {

    var Data: String!
    var Costo: Decimal!
    var DataInserimento: String!
    var ExtraPreventivo: Int!
    var IdCantiere: Int!
    var IdRistorante: Int!
    var IdUtenteInserimento: Int!
    var RagioneSociale: String!
    var InseritoDA: String!

    //Costruttore
    init(IdCantiere: Int) {
        self.IdCantiere = IdCantiere
        self.IdRistorante = 0
        self.Data = ""
        self.Costo = 0
        self.DataInserimento = ""
        self.ExtraPreventivo = 0
        self.IdUtenteInserimento = 0
        self.RagioneSociale = ""
        self.InseritoDA = ""
    }

}


//Classe che rappresenta il ristorante
public class Ristorante {

    //Rappresenta il Cantiere in cui è presente il ristorante!
    private var CantiereInterno: Cantiere!
    private var Ristorante: RistoranteStruct = RistoranteStruct.init(IdCantiere: 0)

    //Costruttore
    init(Cantiere: Cantiere) {
        self.CantiereInterno = Cantiere
    }

    //Costruttore
    init(SetRistorante: RistoranteStruct, Cantiere: Cantiere) {
        self.CantiereInterno = Cantiere
        self.Ristorante.IdCantiere = SetRistorante.IdCantiere
        self.Ristorante.IdRistorante = SetRistorante.IdRistorante
        self.Ristorante.Data = SetRistorante.Data
        self.Ristorante.InseritoDA = SetRistorante.InseritoDA
        self.Ristorante.RagioneSociale = SetRistorante.RagioneSociale
        self.Ristorante.Costo = SetRistorante.Costo
        self.Ristorante.IdUtenteInserimento = SetRistorante.IdUtenteInserimento
        self.Ristorante.DataInserimento = SetRistorante.DataInserimento
        self.Ristorante.ExtraPreventivo = SetRistorante.ExtraPreventivo
    }

    //Funzione che effettua l'inserimento di un ristorante
    func Inserisci(Data: String, RagioneSociale: String, Costo: String, completion: @escaping (Bool) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let model = RistornateModel()
            model.Inserisci(IdCantiere: self.CantiereInterno.GetIdCantiere(), Data: Data, RagioneSociale: RagioneSociale, Costo: Costo, IdUtenteInserimento: Int(GetIdUtenteLogin()), completion: {
                    result in
                    completion(result)
                })
        }
    }

    //Funzione che elimina il ristorante
    func Elimina(completion: @escaping (Bool) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let model = RistornateModel()
            model.Elimina(IdRistorante: self.Ristorante.IdRistorante, completion: {
                result in
                completion(result)
            })
        }
    }

    //Funzione per il caricamento dei ristoranti
    func Carica(completion: @escaping ([RistoranteStruct]) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let model = RistornateModel()
            model.Carica(IdCantiere: self.CantiereInterno.GetIdCantiere(), completion: {
                    result in
                    completion(result)
                })
        }

    }



}
