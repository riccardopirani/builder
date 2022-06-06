//
//  Noleggio.swift
//  Quote
//
//  Created by riccardo on 26/11/2019.
//  Copyright © 2019 ViewSoftware. All rights reserved.
//

import Foundation

//Struttura che rappresenta il ristorante
struct NoleggioStruct: Codable {

    var NomeFornitore: String!
    var CostoNoleggio: Float!
    var DataInizioNoleggio: String!
    var DataTermineNoleggio: String!
    var DataInserimento: String!
    var ExtraPreventivo: Int!
    var IdCantiere: Int!
    var IdFornitore: Int!
    var IdNoleggio: Int!
    var IdUtenteInserimento: Int!
    var TipoMezzo: String!
    var Matricola: String!
    var Trasporto: Float!
    var InseritoDA: String!

    //Costruttore
    init(IdCantiere: Int) {
        self.IdCantiere = IdCantiere
        self.NomeFornitore = ""
        self.DataInizioNoleggio = ""
        self.DataInserimento = ""
        self.DataTermineNoleggio = ""
        self.ExtraPreventivo = 0
        self.IdCantiere = 0
        self.IdFornitore = 0
        self.IdNoleggio = 0
        self.IdUtenteInserimento = 0
        self.TipoMezzo = ""
        self.Matricola = ""
        self.Trasporto = 0
        self.InseritoDA = ""
    }

}


//Classe che rappresenta il ristorante
public class Noleggio {

    //Rappresenta il Cantiere in cui è presente il ristorante!
    private var CantiereInterno: Cantiere!
    private var Noleggio: NoleggioStruct = NoleggioStruct.init(IdCantiere: 0)

    //Costruttore
    init(Cantiere: Cantiere) {
        self.CantiereInterno = Cantiere
    }

    //Costruttore
    init(SetNoleggio: NoleggioStruct, Cantiere: Cantiere) {
        self.CantiereInterno = Cantiere
        self.Noleggio.IdCantiere = SetNoleggio.IdCantiere
        self.Noleggio.NomeFornitore = SetNoleggio.NomeFornitore
        self.Noleggio.DataInizioNoleggio = SetNoleggio.DataInizioNoleggio
        self.Noleggio.DataTermineNoleggio = SetNoleggio.DataTermineNoleggio
        self.Noleggio.DataInserimento = SetNoleggio.DataInserimento
        self.Noleggio.ExtraPreventivo = SetNoleggio.ExtraPreventivo
        self.Noleggio.IdCantiere = SetNoleggio.IdCantiere
        self.Noleggio.IdFornitore = SetNoleggio.IdFornitore
        self.Noleggio.IdNoleggio = SetNoleggio.IdNoleggio
        self.Noleggio.IdUtenteInserimento = SetNoleggio.IdUtenteInserimento
        self.Noleggio.TipoMezzo = SetNoleggio.TipoMezzo
        self.Noleggio.Matricola = SetNoleggio.Matricola
        self.Noleggio.Trasporto = SetNoleggio.Trasporto
        self.Noleggio.InseritoDA = SetNoleggio.InseritoDA
    }

    //Funzione che effettua l'inserimento di un noleggio
    func Inserisci(IdFornitore: Int, ExtraPreventivo: Int, TipoMezzo: String, Matricola: String, Trasporto: Float, CostoNoleggio: Float, DataInizioNoleggio: String, DataTermineNoleggio: String, completion: @escaping (Bool) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
           
            let model = NoleggioModel()
            model.Inserisci(IdCantiere: self.CantiereInterno.GetIdCantiere(), IdUtente: Int(GetIdUtenteLogin()), IdFornitore: IdFornitore, ExtraPreventivo: 0, TipoMezzo: TipoMezzo, Matricola: Matricola, Trasporto: Trasporto, CostoNoleggio: CostoNoleggio, DataInizioNoleggio: DataInizioNoleggio, DataTermineNoleggio: DataTermineNoleggio, completion: {
                    result in
                    completion(result)
                })
        }

    }

    //Funzione che elimina il ristorante
    func Elimina(completion: @escaping (Bool) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let model = NoleggioModel()
            model.Elimina(IdDelete: self.Noleggio.IdNoleggio, completion: {
                result in
                completion(result)
            })
        }
    }

    //Funzione per il caricamento dei noleggi
    func Carica(completion: @escaping ([NoleggioStruct]) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let model = NoleggioModel()
            model.Carica(IdCantiere: self.CantiereInterno.GetIdCantiere(), completion: {
                    result in
                    completion(result)
                })
        }

    }



}
