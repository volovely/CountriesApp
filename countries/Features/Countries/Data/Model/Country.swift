import Foundation

struct Country: Codable, Equatable {
  let name: CountryName
  let capital: [String]?
  let population: Int64
  let flags: CountryFlags
}

struct CountryName: Codable, Equatable {
  let official: String
}

struct CountryFlags: Codable, Equatable {
  let png: String
}
