import Foundation

struct AnimeDetailModel: Codable {
    let id: Int?
    let title: String?
    let mainPicture: Picture?
    let alternativeTitles: AlternativeTitles?
    let startDate, endDate, synopsis: String?
    let mean: Double?
    let rank, popularity, numListUsers, numScoringUsers: Int?
    let nsfw: String?
    let createdAt: String? // Change type to String
    let updatedAt: String?
    let mediaType, status: String?
    let genres: [Genre]?
    let numEpisodes: Int?
    let startSeason: StartSeason?
    let broadcast: Broadcast?
    let source: String?
    let averageEpisodeDuration: Int?
    let rating: String?
    let pictures: [Picture]?
    let background: String?
    let relatedAnime: [RelatedAnime]?
    let recommendations: [Recommendation]?
    let studios: [Genre]?
    let statistics: Statistics?

    enum CodingKeys: String, CodingKey {
        case id, title
        case mainPicture = "main_picture"
        case alternativeTitles = "alternative_titles"
        case startDate = "start_date"
        case endDate = "end_date"
        case synopsis, mean, rank, popularity
        case numListUsers = "num_list_users"
        case numScoringUsers = "num_scoring_users"
        case nsfw
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mediaType = "media_type"
        case status, genres
        case numEpisodes = "num_episodes"
        case startSeason = "start_season"
        case broadcast, source
        case averageEpisodeDuration = "average_episode_duration"
        case rating, pictures, background
        case relatedAnime = "related_anime"
        case recommendations, studios, statistics
    }
}

struct AlternativeTitles: Codable {
    let synonyms: [String]?
    let en, ja: String?
}

struct Broadcast: Codable {
    let dayOfTheWeek, startTime: String?

    enum CodingKeys: String, CodingKey {
        case dayOfTheWeek = "day_of_the_week"
        case startTime = "start_time"
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}

struct Picture: Codable {
    let medium, large: String?
}

struct Recommendation: Codable {
    let node: AnimeDetailsNode?
    let numRecommendations: Int?

    enum CodingKeys: String, CodingKey {
        case node
        case numRecommendations = "num_recommendations"
    }
}

struct AnimeDetailsNode: Codable {
    let id: Int?
    let title: String?
    let mainPicture: Picture?

    enum CodingKeys: String, CodingKey {
        case id, title
        case mainPicture = "main_picture"
    }
}

struct RelatedAnime: Codable {
    let node: AnimeDetailsNode?
    let relationType, relationTypeFormatted: String?

    enum CodingKeys: String, CodingKey {
        case node
        case relationType = "relation_type"
        case relationTypeFormatted = "relation_type_formatted"
    }
}

struct StartSeason: Codable {
    let year: Int?
    let season: String?
}

struct Statistics: Codable {
    let status: Status?
    let numListUsers: Int?

    enum CodingKeys: String, CodingKey {
        case status
        case numListUsers = "num_list_users"
    }
}

//struct Status: Codable {
//    let watching, onHold, dropped: String?
//    let completed: Any?
//
//    enum CodingKeys: String, CodingKey {
//        case watching
//        case completed
//        case onHold = "on_hold"
//        case dropped
//    }
//
//}

struct Status: Codable {
    let watching, onHold, dropped: String?
    let completed: Any?

    enum CodingKeys: String, CodingKey {
        case watching, onHold = "on_hold", dropped, completed
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        watching = try container.decodeIfPresent(String.self, forKey: .watching)
        onHold = try container.decodeIfPresent(String.self, forKey: .onHold)
        dropped = try container.decodeIfPresent(String.self, forKey: .dropped)
        
        // Decode 'completed' as a nested container
        if let completedContainer = try? container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: .completed) {
            completed = try Status.decodeCompletedValue(from: completedContainer)
        } else {
            completed = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(watching, forKey: .watching)
        try container.encodeIfPresent(onHold, forKey: .onHold)
        try container.encodeIfPresent(dropped, forKey: .dropped)

        // Encode 'completed' as a nested container
        if let completed = completed {
            var completedContainer = container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: .completed)
            try Status.encode(completed, to: &completedContainer)
        }
    }

    private static func decodeCompletedValue(from container: KeyedDecodingContainer<AnyCodingKey>) throws -> Any {
        if let stringValue = try? container.decode(String.self, forKey: AnyCodingKey(stringValue: "stringValue")) {
            return stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: AnyCodingKey(stringValue: "intValue")) {
            return intValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: AnyCodingKey(stringValue: "completed"), in: container, debugDescription: "Unexpected type for completed")
        }
    }

    private static func encode(_ value: Any, to container: inout KeyedEncodingContainer<AnyCodingKey>) throws {
        switch value {
        case let stringValue as String:
            try container.encode(stringValue, forKey: AnyCodingKey(stringValue: "stringValue"))
        case let intValue as Int:
            try container.encode(intValue, forKey: AnyCodingKey(stringValue: "intValue"))
        default:
            fatalError("Unexpected type for completed value: \(type(of: value))")
        }
    }
}

// A custom coding key type for handling Any type
struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}


// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {
    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
