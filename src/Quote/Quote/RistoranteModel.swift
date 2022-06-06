//
//  RistorantiModel.swift
//  Quote
//
//  Created by riccardo on 25/11/2019.
//  Copyright © 2019 ViewSoftware. All rights reserved.
//

import Foundation

//Classe che si occupa del model del Ristorante
class RistornateModel {

    //Costruttore
    init() {

    }

    //Funzione per il caricamento dei ristoranti
    func Carica(IdCantiere: Int, completion: @escaping ([RistoranteStruct]) -> ())
    {
        let jsonrequest = JSON()
        let valuepass: String = "\(IdCantiere)"
        let jsonarray: [String: Any] = ["IdCantiere": valuepass]
        jsonrequest.GetArray(Tipo: "RistoranteStruct", Router: "/ristoranti/carica", ValueArray: jsonarray, completion: { result in
            completion(result as! [RistoranteStruct])
        })
    }

    //Funzione per l'inserimento di un ristorante
    public func Inserisci(IdCantiere: Int, Data: String, RagioneSociale: String, Costo: String, IdUtenteInserimento: Int, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let valuepass: String = "\(IdCantiere)"
            let jsonarray: [String: Any] = ["IdCantiere": valuepass, "ExtraPreventivo": "0", "Data": Data, "RagioneSociale": RagioneSociale, "Costo": Costo, "IdUtenteInserimento": IdUtenteInserimento]
            jsonrequest.GetSingleValue(Router: "/ristoranti/inserimento", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }

    }

    //Funzione per eliminazione di eliminare un ristorante
    public func Elimina(IdRistorante: Int, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdRistorante": IdRistorante]
            jsonrequest.GetSingleValue(Router: "/ristoranti/elimina", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }

    }

}
