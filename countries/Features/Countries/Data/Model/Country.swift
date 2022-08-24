import Foundation

struct Country: Codable {
  let name: CountryName
  let capital: [String]?
  let population: Int64
  let flags: CountryFlags
}

struct CountryName: Codable {
  let official: String
}

struct CountryFlags: Codable {
  let png: String
}
