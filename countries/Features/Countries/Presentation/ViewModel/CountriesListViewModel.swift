import Foundation

class CountriesListViewModel {
  weak var view: CountriesListViewModelDelegate?

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
      CountriesListState.loading()
    )
    Task {
      do {
        let countries = try await getCountriesUseCase.getCountries().value

        view?.render(
          CountriesListState.success(countries: countries)
        )
      } catch let error as AppError  {
        view?.render(
          CountriesListState.fail(error: error)
        )
      }
    }
  }
}
