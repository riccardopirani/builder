import Foundation

struct ClienteStruct: Codable {

    var IdCliente: Int!
    var RagioneSociale: String!
    var Indirizzo: String!
    var Citta: String!
}

enum ModalitaCliente: String {
    case Ricerca = "Ricerca"
    case Inserisci = "Inserisci"
}

public class Cliente {

    private var RagioneSociale: String = ""
    private var IdCliente: Int = 0
    private var Indirizzo: String = "", Citta: String = ""

    //Costruttore 1
    init()
    {

    }

    //Costruttore 2
    init(RagioneSociale: String, IdCliente: Int, Citta: String, Indirizzo: String) {
        self.IdCliente = IdCliente
        self.RagioneSociale = RagioneSociale
        self.Indirizzo = Indirizzo
        self.Citta = Citta
    }

    //Ricerca Cliente
    func Ricerca(TestoRicerca: String, completion: @escaping ([ClienteStruct]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let ctemp = ClienteModel()

            ctemp.Ricerca(TestoRicerca: TestoRicerca, completion: { result in

                completion(result)
            })
        }
    }

    //Elimina cliente
    public func Elimina(completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let cmodel = ClienteModel()
            cmodel.Elimina(IdCliente: self.IdCliente, completion: {
                result in
                completion(result)
            })
        }
    }

    //Inserimento nuovo cliente
    public func Inserisci(RagioneSociale: String, Indirizzo: String, Citta: String, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let cmodel = ClienteModel()
            cmodel.Inserisci(RagioneSociale: RagioneSociale, Indirizzo: Indirizzo, Citta: Citta, completion: {
                result in
                completion(result)
            })
        }
    }

    //Aggiorna Cliente
    public func Aggiorna(RagioneSociale: String, Indirizzo: String, Citta: String, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let cmodel = ClienteModel()
            cmodel.Aggiorna(IdCliente: self.IdCliente, RagioneSociale: RagioneSociale, Indirizzo: Indirizzo, Citta: Citta, completion: {
                result in
                completion(result)
            })
        }
    }

    func GetIdCliente() -> Int {
        return self.IdCliente
    }

    func GetRagioneSociale() -> String {
        return self.RagioneSociale
    }

    func GetIndirizzo() -> String {
        return self.Indirizzo
    }
    func GetCitta() -> String {

        return self.Citta
    }

}
