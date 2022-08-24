import Foundation

enum FetchResult<Result> {
  case actual(Result)
  case cached(Result)
}
