//
//  Showplace.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 06.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

class Showplace: Codable {

    // MARK: - Properties
    
    let id: Int
    var name: String
    var imageURLString: String?
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURLString = "image_URL"
    }
    
    
    // MARK: - Initialization
    
    init(id: Int, name: String, imageURLString: String?) {
        self.id = id
        self.name = name
        self.imageURLString = imageURLString
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        
        if let imageURLString = try container.decodeIfPresent(String.self, forKey: .imageURLString) {
            self.imageURLString = imageURLString
        }
    }
    
    //MARK: - Codable methods
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.imageURLString, forKey: .imageURLString)
    }
    
    
}
