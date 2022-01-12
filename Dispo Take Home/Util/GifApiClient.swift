import UIKit

class GifAPIClient {
  // TODO: Implement
    private let apiKey: String
    private let baseGiphyUrl = "https://api.giphy.com/v1/gifs"
    
    public weak var view: MainViewModel?
    
    let maximumLength = 5000
    
    init() {
        guard let fileUrl = Bundle(for: type(of: self)).url(forResource: "AppSecret", withExtension: "json"),
              let data = try? Data.init(contentsOf: fileUrl),
              let secretsDict = try? JSONDecoder().decode([String: String].self, from: data),
              let apiKey = secretsDict["apiKey"] else {
            self.apiKey = "error"
            return
        }
        
        self.apiKey = apiKey
    }
    
    // api.giphy.com/v1/gifs/trending
    func getTrending(count: Int,
                     offset: Int,
                     completionHandler: @escaping(APIListResponse) -> Void) {
        
        guard let url = URL(string: baseGiphyUrl + "/trending"
                            + "?api_key=" + apiKey
                            + "&limit=" + String(count)
                            + "&offset=" + String(offset)
                            + "&rating=pg") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                  let apiList: APIListResponse = try? JSONDecoder().decode(APIListResponse.self, from: data) else {
                      return
                  }
            completionHandler(apiList)
        }
        
        task.resume()
    }
    
    // api.giphy.com/v1/gifs/search
    func getSearch(query: String,
                   count: Int,
                   offset: Int,
                   completionHandler: @escaping(APIListResponse) -> Void) {
        guard let safeQuery: String = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: baseGiphyUrl + "/search"
                            + "?api_key=" + apiKey
                            + "&q=" + safeQuery
                            + "&limit=" + String(count)
                            + "&offset=" + String(offset)
                            + "&rating=pg") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                  let apiList: APIListResponse = try? JSONDecoder().decode(APIListResponse.self, from: data) else {
                      return
                  }
            completionHandler(apiList)
        }
        
        task.resume()
    }
    
    // api.giphy.com/v1/gifs/{gif_id}
    func getGifDetails(gifID: String,
                       completionHandler: @escaping(APIGifInfoResponse) -> Void) {
        guard let url = URL(string: baseGiphyUrl + "/" + gifID
                            + "?api_key=" + apiKey) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                  let gifInfo: APIGifInfoResponse = try? JSONDecoder().decode(APIGifInfoResponse.self, from: data) else {
                      return
                  }
            completionHandler(gifInfo)
        }
        
        task.resume()
    }
}
