require 'net/http'
class LatestStockPrice   
  def self.hello_world
    puts "From Stock"
  end

  def self.get_latest_price
    url = "https://latest-stock-price.p.rapidapi.com/any"
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    request = Net::HTTP::Get.new(uri.path, {'Content-Type' => 'application/json','x-rapidapi-key'=>'937f804583mshb61e6a852a85160p113688jsn06e1354389ef'})

    response = http.request(request)

    @body = JSON.parse(response.body) # e.g {answer: 'because it was there'}
    # @body.map do |index|
    #   # p index
    #   # {
    #   #   :identifier=> index.identifier,
    #   #   :lastPrice=> index.lastPrice
    #   # }
    # p @body
    # end
  end 
end