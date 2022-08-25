import XCTest

class GetCountriesUseCaseTests: XCTestCase {
  private var listOfCountries: [Country]!

  override func setUp() {
    super.setUp()

    listOfCountries = [
      Country(
        name: CountryName(official: "Official name1"),
        capital: [
          "One capital",
          "Second capital"
        ],
        population: 4_000_000_000,
        flags: CountryFlags(png: "https://utl.to.flag")
      ),
      Country(
        name: CountryName(official: "Official name2"),
        capital: [
          "One capital2",
          "Second capital2"
        ],
        population: 4_000_000_000,
        flags: CountryFlags(png: "https://utl.to.flag")
      )
    ]
  }

  func testSuccesResult() async {
    // Given
    let repositoryMock = CountriesRepositoryMock(getCountriesResult: listOfCountries)
    let useCase = GetCountriesUseCaseImpl(countriesRepository: repositoryMock)

    // When
    let actual = try! await useCase.getCountries().value

    // Then
    XCTAssertEqual(actual, listOfCountries)
  }

  func testError() async {
    // Given
    let repositoryMock = CountriesRepositoryMock(error: AppError())
    let useCase = GetCountriesUseCaseImpl(countriesRepository: repositoryMock)

    // When
    do {
      _ = try await useCase.getCountries().value
      XCTFail()
    } catch {
      XCTAssert((error as Any) is AppError)
    }
  }
}

private class CountriesRepositoryMock: CountriesRepository {
  let getCountriesResult: [Country]?
  let error: Error?

  init(
    getCountriesResult: [Country]? = nil,
    error: Error? = nil
  ) {
    self.getCountriesResult = getCountriesResult
    self.error = error
  }

  func getCountries() async throws -> FetchResult<[Country]> {
    if let getCountriesResult = getCountriesResult {
      return FetchResult.actual(getCountriesResult)
    } else {
      throw error!
    }
  }
}
