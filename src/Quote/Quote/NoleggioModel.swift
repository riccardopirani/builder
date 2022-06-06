//
//  NoleggioModel.swift
//  Quote
//
//  Created by riccardo on 27/11/2019.
//  Copyright © 2019 ViewSoftware. All rights reserved.
//

import Foundation

//Classe dei Noleggi
class NoleggioModel {

    //Costruttore
    init() {

    }

    //Funzione di eliminazione del noleggio
    func Elimina(IdDelete: Int, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdNoleggio": IdDelete]

            jsonrequest.GetSingleValue(Router: "/noleggio/elimina", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }
    }

    //Funzione inserimento del noleggio
    func Inserisci(IdCantiere: Int, IdUtente: Int, IdFornitore: Int, ExtraPreventivo: Int, TipoMezzo: String, Matricola: String, Trasporto: Float, CostoNoleggio: Float, DataInizioNoleggio: String, DataTermineNoleggio: String, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            print("Model: inserimento noleggio")
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdFornitore": IdFornitore,"IdCantiere": IdCantiere, "IdUtente": IdUtente, "ExtraPreventivo": ExtraPreventivo, "TipoMezzo": TipoMezzo, "Matricola": Matricola, "Trasporto": Trasporto, "CostoNoleggio": CostoNoleggio, "DataInizioNoleggio": DataInizioNoleggio, "DataTermineNoleggio": DataTermineNoleggio, "IdUtenteInserimento": IdUtente]

            jsonrequest.GetSingleValue(Router: "/noleggio/inserisci", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }
    }

    //Funzione per il caricamento dei noleggi
    func Carica(IdCantiere: Int, completion: @escaping ([NoleggioStruct]) -> ())
    {
        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["IdCantiere": IdCantiere]
        jsonrequest.GetArray(Tipo: "NoleggioStruct", Router: "/noleggio/carica", ValueArray: jsonarray, completion: { result in
            completion(result as! [NoleggioStruct])
        })
    }


}
