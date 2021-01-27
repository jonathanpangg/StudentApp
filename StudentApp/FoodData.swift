//
//  FoodData.swift
//  StudentApp
//
//  Created by Jonathan Pang on 1/21/21.
//

import SwiftUI
// \(getArrayAddress(pass.foodData.restaurants ?? [])[index])

struct StarRating: View {
    var rating: Int
    
    init(_ rating: Int) {
        self.rating = rating
    }
    
    var body: some View {
        HStack {
            Spacer()
            ForEach(1..<6) { number in
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 32, height: UIScreen.main.bounds.width / 32)
                    .foregroundColor(number <= self.rating ? Color.yellow: Color.gray)
            }
        }
    }
}

func FoodTile(_ name: String, _ stars: StarRating, _ width: CGFloat, _ height: CGFloat, _ background: Color, _ fontSize: CGFloat = 14, _ fontWeight: Font.Weight = .regular) -> some View {
    ZStack {
        Text("")
            .multilineTextAlignment(.leading)
            .font(.system(size: fontSize, weight: fontWeight))
            .frame(width: width, height: height)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
            .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
        VStack {
            HStack() {
                Spacer()
                stars
            }
            HStack {
                Text(name)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: fontSize, weight: fontWeight))
                    .background(background)
                Spacer()
            }
            Spacer()
        }
        .frame(width: width - width / 8, height: height - height / 8)
    }
    
}

func FunctionList(_ message: String, textfieldString: Binding<String>, _ width: CGFloat, _ height: CGFloat, _ background: Color, _ fontSize: CGFloat = 14, _ fontWeight: Font.Weight = .regular) -> some View {
    ZStack {
        HStack {
            Text("")
                .multilineTextAlignment(.leading)
                .font(.system(size: fontSize, weight: fontWeight))
                .frame(width: width, height: height)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), radius: 10, x: 6, y: 4)
            Spacer()
        }
        .padding(.leading)
        
        HStack(spacing: UIScreen.main.bounds.width / 128) {
            Text(message)
                .multilineTextAlignment(.leading)
                .font(.system(size: fontSize, weight: fontWeight))
                .frame(height: height - height / 16)
                .padding(.leading)
            TextField("", text: textfieldString)
                .multilineTextAlignment(.leading)
                .font(.system(size: fontSize, weight: fontWeight))
                .frame(height: height - height / 16)
                .keyboardType(.numberPad)
            Spacer()
        }
        .padding(.leading)
    }
}


struct LocationData: Codable {
    let locationSuggestions: [LocationSuggestion]
    let status: String
    let hasMore, hasTotal: Int
    let userHasAddresses: Bool

    enum CodingKeys: String, CodingKey {
        case locationSuggestions = "location_suggestions"
        case status
        case hasMore = "has_more"
        case hasTotal = "has_total"
        case userHasAddresses = "user_has_addresses"
    }
    
    init() {
        self.locationSuggestions = [LocationSuggestion]()
        self.status = ""
        self.hasMore = 0
        self.hasTotal = 0
        self.userHasAddresses = false
    }
}

struct LocationSuggestion: Codable {
    let entityType: String
    let entityID: Int
    let title: String
    let latitude, longitude: Double
    let cityID: Int
    let cityName: String
    let countryID: Int
    let countryName: String

    enum CodingKeys: String, CodingKey {
        case entityType = "entity_type"
        case entityID = "entity_id"
        case title, latitude, longitude
        case cityID = "city_id"
        case cityName = "city_name"
        case countryID = "country_id"
        case countryName = "country_name"
    }
}
    
struct FoodData: Codable {
    let resultsFound, resultsStart, resultsShown: Int?
    let restaurants: [RestaurantElement]?

    enum CodingKeys: String, CodingKey {
        case resultsFound = "results_found"
        case resultsStart = "results_start"
        case resultsShown = "results_shown"
        case restaurants
    }
    
    init() {
        self.resultsFound = 0
        self.resultsStart = 0
        self.resultsShown = 0
        self.restaurants = [RestaurantElement]()
    }
}

struct RestaurantElement: Codable {
    let restaurant: RestaurantRestaurant?
}

struct RestaurantRestaurant: Codable {
    let R: R?
    let apikey: String?
    let id, name: String?
    let url: String?
    let location: Location?
    let switch_to_order_menu: Int?
    let cuisines, timings: String?
    let average_cost_for_two, price_range: Int?
    let currency: String?
    let highlights: [String]?
    let offers: [JSONAny]?
    let opentable_support, is_zomato_book_res: Int?
    let mezzo_provider: String?
    let is_book_form_web_view: Int?
    let book_form_web_view_url, book_again_url: String?
    let thumb: String?
    let user_rating: UserRating?
    let all_reviews_count: Int?
    let photos_url: String?
    let photo_count: Int?
    let menu_url: String?
    let featured_image: String?
    let medio_provider: Bool?
    let has_online_delivery, is_delivering_now: Int?
    let store_type: String?
    let include_bogo_offers: Bool?
    let deeplink: String?
    let is_table_reservation_supported, has_table_booking: Int?
    let events_url: String?
    let phone_numbers: String?
    let all_reviews: AllReviews?
    let establishment: [String]?
    let establishment_types: [JSONAny]?
}

struct AllReviews: Codable {
    let reviews: [Review]
}

struct Review: Codable {
    let review: [JSONAny]
}

struct Location: Codable {
    let address, locality: String?
    let city: String?
    let city_id: Int?
    let latitude, longitude, zipcode: String?
    let country_id: Int?
    let locality_verbose: String?
}

struct R: Codable {
    let res_id: Int?
    let is_grocery_store: Bool?
    let has_menu_status: HasMenuStatus?
}

struct HasMenuStatus: Codable {
    let delivery, takeaway: Int?
}

struct UserRating: Codable {
    let aggregate_rating: String?
    let rating_text: String?
    let rating_color: String?
    let rating_obj: RatingObj?
    let votes: Int?
}

struct RatingObj: Codable {
    let title: Title
    let bg_color: BgColor
}

struct BgColor: Codable {
    let type: String?
    let tint: String?
}

struct Title: Codable {
    let text: String?
}

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
