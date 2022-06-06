//
//  ClienteModel.swift
//  Quote
//
//  Created by riccardo on 31/08/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import Foundation

//Classe che rappresenta il Cliente nel model
class ClienteModel {

    //Costruttore
    init() {

    }

    //Funzione per ricerca cliente
    func Ricerca(TestoRicerca: String, completion: @escaping ([ClienteStruct]) -> ())
    {
        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["TestoRicerca": "" + TestoRicerca]
        jsonrequest.GetArray(Tipo: "ClienteStruct", Router: "/cliente/ricerca", ValueArray: jsonarray, completion: { result in
            completion(result as! [ClienteStruct])
        })
    }

    //Funzione per l'inserimento di un cliente
    public func Inserisci(RagioneSociale: String, Indirizzo: String, Citta: String, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["RagioneSociale": RagioneSociale, "Indirizzo": Indirizzo, "Citta": Citta]
            jsonrequest.GetSingleValue(Router: "/cliente/crea", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }

    }

    //Funzione per eliminazione di un cliente
    public func Elimina(IdCliente: Int, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdCliente": IdCliente]
            jsonrequest.GetSingleValue(Router: "/cliente/elimina", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }

    }

    //Funzione per l'aggiornamento di un Cliente
    public func Aggiorna(IdCliente: Int, RagioneSociale: String, Indirizzo: String, Citta: String, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdCliente": IdCliente, "RagioneSociale": RagioneSociale, "Indirizzo": Indirizzo, "Citta": Citta]
            jsonrequest.GetSingleValue(Router: "/cliente/aggiorna", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }

    }


}
