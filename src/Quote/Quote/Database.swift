//
//  Database.swift
//  Quote
//
//  Created by riccardo on 16/03/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class JSON {

    func GetSingleInteger(Router: String, ValueArray: [String: Any], completion: @escaping (Int) -> ())
    {
        let semaphore = DispatchSemaphore(value: 1)
        semaphore.wait()
        let db = Database()
        let json: [String: Any] = ValueArray
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: URL(string: db.GetServerURL() + Router)!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // the expected response is also JSON
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(0)
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let read = responseJSON["return"]!
                let IdUser = Int(String(describing: read))!
                if (IdUser > 0) {

                    completion(IdUser)
                }
                else {
                    completion(0)
                }
            }

        }
        task.resume()
        semaphore.signal()

    }

    func GetSingleString(Router: String, ValueArray: [String: Any], completion: @escaping (String) -> ())
    {
        let semaphore = DispatchSemaphore(value: 1)
        semaphore.wait()
        let db = Database()
        let json: [String: Any] = ValueArray
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: URL(string: db.GetServerURL() + Router)!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion("false")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let read = responseJSON["return"]!
                completion(read as! String)
            }

        }
        task.resume()
        semaphore.signal()
    }

    func GetSingleValue(Router: String, ValueArray: [String: Any], completion: @escaping (Bool) -> ())
    {
        let semaphore = DispatchSemaphore(value: 1)
        semaphore.wait()
        let db = Database()
        let json: [String: Any] = ValueArray
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: URL(string: db.GetServerURL() + Router)!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // the expected response is also JSON

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(false)
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let read = responseJSON["return"]!
                if((String(describing: read) == "1") || String(describing: read) == "true") {
                    completion(true)
                }
                else {
                    completion(false)
                }
            }

        }
        task.resume()
        semaphore.signal()
    }

    func GetArray(Tipo: String, Router: String, ValueArray: [String: Any], completion: @escaping (_ ret: Codable) -> ())
    {
        let semaphore = DispatchSemaphore(value: 1)
        semaphore.wait()
        let db = Database()
        let json: [String: Any] = ValueArray
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: URL(string: db.GetServerURL() + Router)!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                if(Tipo == "Articolo") {
                    let value = try JSONDecoder().decode([ArticoloStruct].self, from: data)
                    completion(value)
                }
                else if(Tipo == "ArticoloCantiereStruct") {
                    let value = try JSONDecoder().decode([ArticoloCantiereStruct].self, from: data)
                    completion(value)
                }
                else if(Tipo == "Cantiere") {
                    let value = try JSONDecoder().decode([CantiereStruct].self, from: data)
                    completion(value)
                }
                else if(Tipo == "User") {
                    let value = try JSONDecoder().decode([UserStruct].self, from: data)
                    completion(value)
                }
                else if(Tipo == "RisorsaUmanaStruct") {
                    let value = try JSONDecoder().decode([RisorsaUmanaStruct].self, from: data)
                    completion(value)
                }
                else if(Tipo == "KilometroStruct") {
                    let value = try JSONDecoder().decode([KilometroStruct].self, from: data)
                    completion(value)
                }
                else if(Tipo == "RapportinoRead") {
                    let value = try JSONDecoder().decode([RapportinoRead].self, from: data)
                    completion(value)
                }
                else if (Tipo == "ClienteStruct") {
                    let value = try JSONDecoder().decode([ClienteStruct].self, from: data)
                    completion(value)
                }
                else if (Tipo == "TipologiaStruct") {
                    let value = try JSONDecoder().decode([TipologiaStruct].self, from: data)
                    completion(value)
                }
                else if(Tipo == "ArticoloMagazzino") {
                    let value = try JSONDecoder().decode([ArticoloMagazzinoStruct].self, from: data)
                    completion(value)
                }
                else if(Tipo == "RistoranteStruct") {
                    let value = try JSONDecoder().decode([RistoranteStruct].self, from: data)
                    completion(value)
                }
                else if(Tipo == "MagazzinoStruct") {
                    let value = try JSONDecoder().decode([MagazzinoStruct].self, from: data)
                    completion(value)
                }
                else if(Tipo == "PreventivoStruct") {
                    let value = try JSONDecoder().decode([PreventivoStruct].self, from: data)
                    completion(value)
                }
                else if(Tipo == "NoleggioStruct") {
                    let value = try JSONDecoder().decode([NoleggioStruct].self, from: data)
                    completion(value)
                }

            } catch let error {
                print("Error JSON: ", error)
            }
        }.resume()
        semaphore.signal()
    }
}

class Database {

    var portSet = ""
    var serverSet = ""

    func GetServerURL() -> String {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Setup")
        request.returnsObjectsAsFaults = false;
        do {
            let result = try context.fetch(request)
            if result.count > 0
            {
                for result in result as! [NSManagedObject] {
                    if let server = result.value(forKey: "server")as? String
                    {
                        self.serverSet = server

                    }

                    if let port = result.value(forKey: "port") as? Int32
                    {
                        self.portSet = "\(port)"
                    }
                }
            }
        }
        catch {
            print("Errore caricamento Parametri DB \(error)")

        }
        var ret = "\(serverSet):\(portSet)"
        if(serverSet == "" || portSet == "") {
            ret = ""
        }
        return ret

    }

    func getServer() -> String {
        return serverSet
    }

    func GetPort() -> String {
        return portSet
    }

    func SetServer(Server: String, Port: Int32) -> Bool
    {
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let NewServer = NSEntityDescription.insertNewObject(forEntityName: "Setup", into: context)
            NewServer.setValue(Server, forKeyPath: "server")
            NewServer.setValue(Port, forKeyPath: "port")

            try context.save()
            print("Saved Server Parameter")
            return true
        }
        catch {
            print("Not Saved Server Parameter")
            return false
        }

    }

    func SetPersistentValue(EntinyName: String, ValueName: String, Value: String) -> Bool {

        var ret: Bool = true
        DispatchQueue.main.async {
            do {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext

                let NewUser = NSEntityDescription.insertNewObject(forEntityName: EntinyName, into: context)
                NewUser.setValue(Value, forKeyPath: ValueName)
                try context.save()
            }
            catch {
                ret = false
                print("Not Saved Server Parameter")
            }
        }
        return ret

    }

    func removeEntity(EntinyName: String) -> Bool {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: EntinyName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print ("Eliminazione entity avvenuta")
            return true
        } catch {
            print ("Errore: Eliminazione entity ")
            return false
        }
    }

    func GetPersistentValue(EntinyName: String, ValueName: String) -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var value = ""
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: EntinyName)
        request.returnsObjectsAsFaults = false;
        do {
            let result = try context.fetch(request)
            if result.count > 0
            {
                for result in result as! [NSManagedObject] {
                    if let valuetemp = result.value(forKey: ValueName)as? String
                    {
                        value = valuetemp

                    }
                }
            }
        }
        catch {
            print("Errore caricamento Parametri DB \(error)")

        }
        return value
    }
}
