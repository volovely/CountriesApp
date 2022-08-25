import Foundation

struct CountriesModule {
  let viewModel: CountriesViewModel

  init() {
    let errorMapper = WebErrorMapper()
    let remoteApi = URLSessionCountriesRemoteApi(errorMapper: errorMapper)
    let storageApi = UserDefaultsCountriesStorage()
    let repository = CountriesRepository(remoteApi: remoteApi, storageApi: storageApi)
    let getUseCase = GetCountriesUseCase(countriesRepository: repository)
    viewModel = CountriesViewModel(getCountriesUseCase: getUseCase)
  }
}
