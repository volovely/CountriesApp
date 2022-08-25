import Foundation

protocol GetCountriesUseCase {
  func getCountries() async throws -> FetchResult<[Country]>
}

struct GetCountriesUseCaseImpl: GetCountriesUseCase {
  private let countriesRepository: CountriesRepository

  init(countriesRepository: CountriesRepository) {
    self.countriesRepository = countriesRepository
  }

  func getCountries() async throws -> FetchResult<[Country]> {
    try await countriesRepository.getCountries()
  }
}
