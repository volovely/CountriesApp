import Foundation

class CountriesViewModel {
  weak var view: CountriesView?

  private let getCountriesUseCase: GetCountriesUseCase

  init(getCountriesUseCase: GetCountriesUseCase) {
    self.getCountriesUseCase = getCountriesUseCase
  }

  func enterScreen() {
    fetchCountries()
  }

  func tryAagain() {
    fetchCountries()
  }

  private func fetchCountries() {
    view?.render(
      CountriesState.loading()
    )
    Task {
      do {
        let countries = try await getCountriesUseCase.getCountries().value

        view?.render(
          CountriesState.success(countries: countries)
        )
      } catch let error as AppError  {
        view?.render(
          CountriesState.fail(error: error)
        )
      }
    }
  }
}
