//
//  UserModel.swift
//  Quote
//
//  Created by riccardo on 16/03/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import Foundation

//Classe User
class UserModel {

    //Costruttore
    init() {
    }

    //Funzione di Login
    func Login(Username: String, Password: String, completion: @escaping (Int) -> ())
    {
        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["Username": "" + Username, "Password": "" + Password]
        jsonrequest.GetSingleInteger(Router: "/login", ValueArray: jsonarray, completion: { result in
            completion(result)
        })
    }

    //Caricamento Risorse
    func CaricaRisorse(completion: @escaping ([UserStruct]) -> ())
    {
        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["Default": "0"]
        jsonrequest.GetArray(Tipo: "User", Router: "/RisorseUmane/CaricaRisorse", ValueArray: jsonarray, completion: { result in
            completion(result as! [UserStruct])
        })
    }

    //Marcatura
    func Marcatura(IdUtente: Int, Longitudine: Float, Latitudine: Float, Stato: String, completion: @escaping (String) -> ())
    {
        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["IdUtente": IdUtente, "Longitudine": Longitudine, "Latitudine": Latitudine, "Stato": Stato]
        jsonrequest.GetSingleString(Router: "/Utente/Marcatura", ValueArray: jsonarray, completion: { result in
            completion(result)
        })
    }

    //Verifica permesso accesso
    func VerificaPermesso(TipologiaPermesso: String, completion: @escaping (String) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["TipologiaPermesso": TipologiaPermesso]
            jsonrequest.GetSingleString(Router: "/permessi/verifica", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }
    }
}
