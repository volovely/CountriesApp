import Foundation

enum FetchResult<ResultType> {
  case actual(ResultType)
  case cached(ResultType)
}

extension FetchResult {
  var value: ResultType {
    var res: ResultType
    switch self {
    case .actual(let result):
      res = result
    case .cached(let result):
      res = result
    }

    return res
  }
}
