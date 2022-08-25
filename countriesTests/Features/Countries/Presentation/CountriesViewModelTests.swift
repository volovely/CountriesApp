import XCTest

class CountriesViewModelTests: XCTestCase {
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

  func testInit() {
    // Given
    let useCaseMock = GetCountriesUseCaseMock(getCountriesResult: listOfCountries)

    // When
    let viewModel = CountriesViewModel(getCountriesUseCase: useCaseMock)

    // Then
    XCTAssertNil(viewModel.state)
    XCTAssertNil(viewModel.view)
  }

  func testEnterScreen_CountriesLoaded() {
    // Given
    let viewMock = CountiesViewMock()
    let useCaseMock = GetCountriesUseCaseMock(getCountriesResult: listOfCountries)
    let viewModel = CountriesViewModel(getCountriesUseCase: useCaseMock)
    viewModel.view = viewMock

    // When
    viewModel.enterScreen()

    // Then
    XCTAssertNil(viewModel.state!.countries)
    XCTAssertNil(viewModel.state!.error)
    XCTAssert(viewModel.state!.isLoading)
    XCTAssertEqual(viewMock.notifyWasCalled, 1)

    // Then
    _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 0.6)

    XCTAssertEqual(viewModel.state!.countries, listOfCountries)
    XCTAssertNil(viewModel.state!.error)
    XCTAssertFalse(viewModel.state!.isLoading)
    XCTAssertEqual(viewMock.notifyWasCalled, 2)
  }

  func testEnterScreen_CountriesFailedToLoad() {
    // Given
    let expectedError = WebError()
    let viewMock = CountiesViewMock()
    let useCaseMock = GetCountriesUseCaseMock(error: expectedError)
    let viewModel = CountriesViewModel(getCountriesUseCase: useCaseMock)
    viewModel.view = viewMock

    // When
    viewModel.enterScreen()

    // Then
    XCTAssertNil(viewModel.state!.countries)
    XCTAssertNil(viewModel.state!.error)
    XCTAssert(viewModel.state!.isLoading)

    // Then
    _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 0.6)

    XCTAssertNil(viewModel.state!.countries)
    XCTAssert(viewModel.state!.error === expectedError)
    XCTAssertFalse(viewModel.state!.isLoading)
  }

  func testTryAgain_CountriesLoaded() {
    // Given
    let viewMock = CountiesViewMock()
    let useCaseMock = GetCountriesUseCaseMock(getCountriesResult: listOfCountries)
    let viewModel = CountriesViewModel(getCountriesUseCase: useCaseMock)
    viewModel.view = viewMock

    // When
    viewModel.tryAagain()

    // Then
    XCTAssertNil(viewModel.state!.countries)
    XCTAssertNil(viewModel.state!.error)
    XCTAssert(viewModel.state!.isLoading)
    XCTAssertEqual(viewMock.notifyWasCalled, 1)

    // Then
    _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 0.6)

    XCTAssertEqual(viewModel.state!.countries, listOfCountries)
    XCTAssertNil(viewModel.state!.error)
    XCTAssertFalse(viewModel.state!.isLoading)
    XCTAssertEqual(viewMock.notifyWasCalled, 2)
  }

  func testTryAgain_CountriesFailedToLoad() {
    // Given
    let expectedError = WebError()
    let viewMock = CountiesViewMock()
    let useCaseMock = GetCountriesUseCaseMock(error: expectedError)
    let viewModel = CountriesViewModel(getCountriesUseCase: useCaseMock)
    viewModel.view = viewMock

    // When
    viewModel.tryAagain()

    // Then
    XCTAssertNil(viewModel.state!.countries)
    XCTAssertNil(viewModel.state!.error)
    XCTAssert(viewModel.state!.isLoading)

    // Then
    _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 0.6)

    XCTAssertNil(viewModel.state!.countries)
    XCTAssert(viewModel.state!.error === expectedError)
    XCTAssertFalse(viewModel.state!.isLoading)
  }
}

private class CountiesViewMock: CountriesView {
  var notifyWasCalled = 0

  func notifyUpdateRequired() {
    notifyWasCalled += 1
  }
}

private class GetCountriesUseCaseMock: GetCountriesUseCase {
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
    try await Task.sleep(nanoseconds: 500_000_000) // This solution needs to be improved :)
    if let getCountriesResult = getCountriesResult {
      return FetchResult.actual(getCountriesResult)
    } else {
      throw error!
    }
  }
}
