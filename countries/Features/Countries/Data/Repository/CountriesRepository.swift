import Foundation

struct CountriesRepository {
  private let remoteApi: CountriesRemoteApi
  private let storageApi: CountriesStorageApi

  init(
    remoteApi: CountriesRemoteApi,
    storageApi: CountriesStorageApi
  ) {
    self.remoteApi = remoteApi
    self.storageApi = storageApi
  }

  func getCountries() async throws -> FetchResult<[Country]> {
    do {
      let countries = try await remoteApi.fetch()
      storageApi.write(countries)

      return .actual(countries)
    } catch {
      return try fetchCountriesFromStorageIfPossible()
    }
  }

  private func fetchCountriesFromStorageIfPossible() throws -> FetchResult<[Country]> {
    if let countries = storageApi.read() {
      return .cached(countries)
    } else {
      throw AppError() // Simplified for now
    }
  }
}

protocol CountriesRemoteApi {
  func fetch() async throws -> [Country]
}

protocol CountriesStorageApi {
  func read() -> [Country]?
  func write(_ countries: [Country])
}
