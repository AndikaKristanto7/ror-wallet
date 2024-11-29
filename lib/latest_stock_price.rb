require 'net/http'
class LatestStockPrice   
  def self.get_latest_price
    url = "https://latest-stock-price.p.rapidapi.com/any"
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true    
    request = Net::HTTP::Get.new(uri.path, {'Content-Type' => 'application/json','x-rapidapi-key'=>ENV['RAPIDAPI_KEY']})
    response = http.request(request)
    @body = JSON.parse(response.body)
  end 
end