//
//  Media.swift
//  NewsAssessment
//
//  Created by Mohammad Abu Maizer on 6/14/20.
//  Copyright © 2020 Mohammad Abu Maizer. All rights reserved.
//

import Foundation
struct Media : Codable {
	let type : String?
	let subtype : String?
	let caption : String?
	let copyright : String?
	let approved_for_syndication : Int?
	let MediaMetadatas : [MediaMetadata]?

	enum CodingKeys: String, CodingKey {

		case type = "type"
		case subtype = "subtype"
		case caption = "caption"
		case copyright = "copyright"
		case approved_for_syndication = "approved_for_syndication"
		case MediaMetadatas = "media-metadata"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		subtype = try values.decodeIfPresent(String.self, forKey: .subtype)
		caption = try values.decodeIfPresent(String.self, forKey: .caption)
		copyright = try values.decodeIfPresent(String.self, forKey: .copyright)
		approved_for_syndication = try values.decodeIfPresent(Int.self, forKey: .approved_for_syndication)
		MediaMetadatas = try values.decodeIfPresent([MediaMetadata].self, forKey: .MediaMetadatas)
	}

}
