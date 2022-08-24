import Foundation

protocol CountriesListViewModelDelegate: AnyObject {
  func render(_ state: CountriesListState)
}
