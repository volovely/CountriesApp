import Foundation

struct UserDefaultsCountriesStorage: CountriesStorageApi {
  let key = "cached_countries"

  let userDefaults = UserDefaults.standard

  func read() -> [Country]? {
    guard
      let jsonCountries = userDefaults.string(forKey: key),
      let countriesData = jsonCountries.data(using: .utf8),
      let decodedCountries = try? Json.decoder.decode([Country].self, from: countriesData) else {
      return nil
    }

    return decodedCountries
  }

  func write(_ countries: [Country]) {
    if let serialisedData = try? Json.encoder.encode(countries) {
      userDefaults.set(serialisedData, forKey: key)
    }
  }
}
