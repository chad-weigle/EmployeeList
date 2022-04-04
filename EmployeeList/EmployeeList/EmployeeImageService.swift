//
//  EmployeeImageService.swift
//  EmployeeList
//
//  Created by Chad Weigle on 4/3/22.
//

import Foundation
import UIKit

class EmployeeImageService {
    var network = Network()
    
    init() {
        let exists = FileManager.default.fileExists(atPath: getDocumentsDirectory().path)
        if !exists {
            do {
                try FileManager.default.createDirectory(at: getDocumentsDirectory(), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("ERROR: Something went wrong creating the directory for storing images!")
            }
        }
    }
    
    func getImage(url: String) async -> UIImage? {
        let components = url.components(separatedBy: "/")
        let imageId = components[components.count - 2]
        if let image = getImageFromDisk(id: imageId) {
            return image
        } else {
            // No image on disk, so call the api to retrieve it.
            if let smallImage = await network.fetchSmallImage(imageURLString: url) {
                saveImageToDisk(id: imageId, image: smallImage)
                return smallImage
            }
            return nil
        }
    }
    
    private func getImageFromDisk(id: String) -> UIImage? {
        let filePath = getDocumentsDirectory().appendingPathComponent("\(id)")
        if let fileData = FileManager.default.contents(atPath: filePath.path),
            let image = UIImage(data: fileData) {
            return image
        } else {
            return nil
        }
    }
    
    private func saveImageToDisk(id: String, image: UIImage) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let filename = getDocumentsDirectory().appendingPathComponent("\(id)")
            do  {
                try data.write(to: filename)
            } catch let error {
                print("ERROR: \(error)")
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
