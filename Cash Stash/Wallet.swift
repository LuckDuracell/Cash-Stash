//
//  Wallet.swift
//  Wallet
//
//  Created by Luke Drushell on 7/25/21.
//

import Foundation
import SwiftUI
import CoreData

struct Wallet: Hashable, Codable, LocalFileStorable {
    static var fileName: String {
        return "Wallet"
    }
    var name: String
    var icon: String
    var amount: Double
}

struct Wallet2: Hashable, Codable, LocalFileStorable {
    static var fileName: String {
        return "Wallet2"
    }
    var name: String
    var icon: String
    var amount: Double
}

struct Wallet3: Hashable, Codable, LocalFileStorable {
    static var fileName: String {
        return "Wallet3"
    }
    var name: String
    var icon: String
    var amount: Double
}

protocol LocalFilesStorable: Codable {
    static var fileName: String { get }
}

extension LocalFilesStorable {
    static var localStorageURL: URL {
        guard let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Can NOT access file in Documents.")
        }
        
        return documentDirectory
            .appendingPathComponent(self.fileName)
            .appendingPathExtension("json")
    }
}

extension LocalFilesStorable {
    static func loadFromFile() -> [Self] {
        do {
            let fileWrapper = try FileWrapper(url: Self.localStorageURL, options: .immediate)
            guard let data = fileWrapper.regularFileContents else {
                throw NSError()
            }
            return try JSONDecoder().decode([Self].self, from: data)
            
        } catch _ {
            print("Could not load \(Self.self) the model uses an empty collection (NO DATA).")
            return []
        }
    }
}

extension LocalFilesStorable {
    static func saveToFile(_ collection: Self) {
        do {
            let data = try JSONEncoder().encode(collection)
            let jsonFileWrapper = FileWrapper(regularFileWithContents: data)
            try jsonFileWrapper.write(to: self.localStorageURL, options: .atomic, originalContentsURL: nil)
        } catch _ {
            print("Could not save \(Self.self)s to file named: \(self.localStorageURL.description)")
        }
    }
}

protocol LocalFileStorable: Codable {
    static var fileName: String { get }
}

extension LocalFileStorable {
    static var localStorageURL: URL {
        guard let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Can NOT access file in Documents.")
        }
        
        return documentDirectory
            .appendingPathComponent(self.fileName)
            .appendingPathExtension("json")
    }
}

extension LocalFileStorable {
    static func loadFromFile() -> [Self] {
        do {
            let fileWrapper = try FileWrapper(url: Self.localStorageURL, options: .immediate)
            guard let data = fileWrapper.regularFileContents else {
                throw NSError()
            }
            return try JSONDecoder().decode([Self].self, from: data)
            
        } catch _ {
            print("Could not load \(Self.self) the model uses an empty collection (NO DATA).")
            return []
        }
    }
}

extension LocalFileStorable {
    static func saveToFile(_ collection: [Self]) {
        do {
            let data = try JSONEncoder().encode(collection)
            let jsonFileWrapper = FileWrapper(regularFileWithContents: data)
            try jsonFileWrapper.write(to: self.localStorageURL, options: .atomic, originalContentsURL: nil)
        } catch _ {
            print("Could not save \(Self.self)s to file named: \(self.localStorageURL.description)")
        }
    }
}

extension Array where Element: LocalFileStorable {
    ///Saves an array of LocalFileStorables to a file in Documents
    func saveToFile() {
        Element.saveToFile(self)
    }
}
