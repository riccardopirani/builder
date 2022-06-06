//
//  ArticoloModel.swift
//  Quote
//
//  Created by riccardo on 26/04/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

//
//  CantiereModel.swift
//  Quote
//
//  Created by riccardo on 26/03/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import Foundation

//Classe che rappresenta l'articolo nel model
class ArticoloModel {

    //Costruttore
    init() {

    }

    //Ricerca Articoli
    func RicercaArticolo(CodArt: String, Descrizione: String, completion: @escaping ([ArticoloStruct]) -> ())
    {
        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["CodArt": CodArt, "RicercaArticoliSenzaCodiceaBarre": false, "CheckRicercaManodopera": false, "CheckCodArt": false, "CheckTipologia": false, "IdArticolo": "0", "Descrizione": "", "CodMarca": "", "Importato": ""]
        jsonrequest.GetArray(Tipo: "Articolo", Router: "/articolo/ricerca", ValueArray: jsonarray, completion: { result in
            completion(result as! [ArticoloStruct])
        })
    }

    //Caricamento Tipologie Articoli
    func CaricaTipologia(completion: @escaping ([TipologiaStruct]) -> ()) {
        let jsonrequest = JSON()
        let jsonarray: [String: Any] = [:]
        jsonrequest.GetArray(Tipo: "TipologiaStruct", Router: "/preventivo/caricatipologie", ValueArray: jsonarray, completion: { result in
            completion(result as! [TipologiaStruct])
        })

    }

    //Funzione di inserimento degli articoli in un cantiere
    func InserimentoArticoloCantiere(IdTipologia: Int, Rapportino: Bool, IdCantiere: Int, ExtraPreventivo: Int, IdUtente: Int, CodArt: String, Descrizione: String, CodMarca: String, CodiceValuta: String, Prezzo: Double, Quantita: Double, Fornitore: String, Importato: String, Data: String, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdTipologia": IdTipologia, "Rapportino": Rapportino, "IdCantiere": IdCantiere, "ExtraPreventivo": ExtraPreventivo, "IdUtente": IdUtente, "CodArt": CodArt, "Descrizione": Descrizione, "CodMarca": CodMarca, "CodiceValuta": CodiceValuta, "Prezzo": Prezzo, "Quantita": Quantita, "Fornitore": Fornitore, "Importato": Importato, "Data": Data]

            jsonrequest.GetSingleValue(Router: "/articolo/inserimentocantiere", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }
    }

    //Funzione per il caricamento degli Articoli Presenti nel Cantiere
    func CaricaArticoliCantiere(IdCantiere: Int, completion: @escaping ([ArticoloCantiereStruct]) -> ())
    {
        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["IdCantiere": IdCantiere]
        jsonrequest.GetArray(Tipo: "ArticoloCantiereStruct", Router: "/articolo/caricaarticolicantiere", ValueArray: jsonarray, completion: { result in
            completion(result as! [ArticoloCantiereStruct])
        })
    }

    //Eliminazione Articolo
    func EliminaArticolo(IdArticolo: Int, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdArticolo": IdArticolo]
            jsonrequest.GetSingleValue(Router: "/articolo/elimina", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }
    }

    //Eliminazione Articolo Cantiere
    func EliminazioneArticoloCantiere(IdArticoloCantiere: Int, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdArticoloCantiere": IdArticoloCantiere]
            jsonrequest.GetSingleValue(Router: "/articolo/eliminazionearticolocantiere", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }
    }

    //Funzione per l'inserimento di un Articolo
    public func Inserisci(UM: String, Prezzo: Float, Descrizione: String, CodArt: String, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["UM": UM, "Prezzo": "\(Prezzo)", "Descrizione": Descrizione, "CodArt": CodArt]
            jsonrequest.GetSingleValue(Router: "/articolo/creazionearticolo", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }

    }

    //Funzione per l'aggiornamento di un Articolo
    public func Aggiorna(IdArticolo: Int, UM: String, Prezzo: Float, Descrizione: String, CodArt: String, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdArticolo": IdArticolo, "UM": UM, "Prezzo": "\(Prezzo)", "Descrizione": Descrizione, "CodArt": CodArt]
            jsonrequest.GetSingleValue(Router: "/articolo/aggiornaarticolo", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }

    }
}

