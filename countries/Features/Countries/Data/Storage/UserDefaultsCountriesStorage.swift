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
    guard
      let serialisedData = try? Json.encoder.encode(countries),
      let stringToWrite = String(data: serialisedData, encoding: .utf8) else {
      return
    }

    userDefaults.set(stringToWrite, forKey: key)
  }
}
