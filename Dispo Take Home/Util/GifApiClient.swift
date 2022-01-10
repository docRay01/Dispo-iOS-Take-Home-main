import UIKit

class GifAPIClient {
  // TODO: Implement
    private let apiKey: String
    private let baseGiphyUrl = "https://api.giphy.com/v1/gifs"
    
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
        guard let url = URL(string: baseGiphyUrl + "/trending" + "?api_key=" + apiKey + "&limit=" + String(count) + "&offset=" + String(offset) + "&rating=pg") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            //guard let self = self else {
            //    return
            //}
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
        
    }
    
    // api.giphy.com/v1/gifs/{gif_id}
    func getGifDetails(gifID: String,
                       completionHandler: @escaping(GifInfo) -> Void) {
        
    }
}
