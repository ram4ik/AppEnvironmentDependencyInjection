//
//  FileClient.swift
//  AppEnvironmentDependencyInjection
//
//  Created by ramil on 30.04.2021.
//

import Combine
import Foundation

struct FileClient {
    var documentDirectory: () -> URL
    var loadFile: (URL) -> AnyPublisher<Data, Error>
    var saveFile: (URL, Data) -> AnyPublisher<Never, Error>
}

extension FileClient {
    public static var preview: Self {
        return Self(
            documentDirectory: {
                let mypath = #file
                let outputDirectory = mypath
                    .components(separatedBy: "/")
                    .dropLast() +
                    ["Preview Content"]
                
                let pathString = outputDirectory.joined(separator: "/")
                
                let outputDirURL = URL(fileURLWithPath: pathString, isDirectory: true)
                
                return outputDirURL
            },
            loadFile: Self.live.loadFile,
            saveFile: Self.live.saveFile
        )
    }
}

extension FileClient {
    public static var live: Self {
        return Self(
            documentDirectory: {
                FileManager.default
                    .urls(for: .documentDirectory, in: .userDomainMask)
                    .first!
            },
            loadFile: { url in
                Deferred {
                    Future<Data, Error> { promise in
                        do {
                            let data = try Data(contentsOf: url)
                            promise(.success(data))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }.eraseToAnyPublisher()
            },
            saveFile: { url, data in
                do {
                    try data.write(to: url)
                    return Just(())
                        .ignoreOutput()
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }
            }
        )
    }
}
