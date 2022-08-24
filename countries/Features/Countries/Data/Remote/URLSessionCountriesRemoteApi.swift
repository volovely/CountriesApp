import Foundation

struct URLSessionCountriesRemoteApi: CountriesRemoteApi {
  private let url = "https://restcountries.com/v3.1/all"

  private let errorMapper: WebErrorMapper

  init(errorMapper: WebErrorMapper) {
    self.errorMapper = errorMapper
  }

  func fetch() async throws -> [Country] {
    guard let url = URL(string: url) else {
      throw WebError()
    }

    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let countries = try Json.decoder.decode([Country].self, from: data)
      return countries
    } catch {
      throw errorMapper.map(error)
    }
  }
}
