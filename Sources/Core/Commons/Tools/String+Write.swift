//
//  String+Write.swift
//  
//
//  Created by Thibault Wittemberg on 2020-06-03.
//

public extension String {
    func write(filename: String) -> Result<Void, Xccov.Error> {
        guard (try? self.write(toFile: filename, atomically: true, encoding: .utf8)) != nil else {
            return .failure(.unableToWriteFile(self))
        }

        return .success(())
    }
}
