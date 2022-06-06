//
//  Preventivi.swift
//  Quote
//
//  Created by riccardo on 27/11/2019.
//  Copyright © 2019 ViewSoftware. All rights reserved.
//


import Foundation

//Struct che identifica un Preventivo
struct PreventivoStruct: Codable {

    var IdPreventivo: Int!
    var IdCliente: Int!
    var RiferimentoInterno: String!
    var RagioneSociale: String!

    //Funzione che inizializza la struct del Preventivo
    init(IdPreventivo: Int) {
        self.IdPreventivo = 0
        self.IdCliente = 0
        self.RiferimentoInterno = ""
        self.RagioneSociale = ""
    }
}

//Classe che identifica un preventivo
public class Preventivo {

    private var PreventivoInterno: PreventivoStruct = PreventivoStruct.init(IdPreventivo: 0)

    //Costruttore con cantiere
    init() {

    }

    //Costurttore con cantiere a preventivo
    init(PreventivoPassed: PreventivoStruct)
    {
        self.PreventivoInterno.IdPreventivo = PreventivoPassed.IdPreventivo
        self.PreventivoInterno.IdCliente = PreventivoPassed.IdCliente
        self.PreventivoInterno.RiferimentoInterno = PreventivoPassed.RiferimentoInterno
        self.PreventivoInterno.RagioneSociale = PreventivoPassed.RagioneSociale
    }

    //Recupero l'IdCliente
    func GetIdCliente() -> Int {
        return PreventivoInterno.IdCliente
    }

    //Recupero l'IdPreventivo
    func GetIdPreventivo() -> Int {
        return PreventivoInterno.IdPreventivo
    }

    //Recupero il riferimento interno
    func GetRiferimentoInterno() -> String {
        return PreventivoInterno.RiferimentoInterno
    }

    //Recupero il riferimento interno
    func GetRagioneSociale() -> String {
        return PreventivoInterno.RagioneSociale
    }

    //Recupero i cantieri a preventivi senza il cantiere agganciato
    func CaricaCantieriSenzaPreventivoAgganciato(completion: @escaping ([PreventivoStruct]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let temp = PreventiviModel()
            temp.CaricaCantieriSenzaPreventivoAgganciato(completion: {
                result in
                completion(result)
            })
        }

    }

}



