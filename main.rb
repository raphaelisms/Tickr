require "http"
require 'uri'
require 'colorize'

puts "Enter your stock label:"
CODE = gets.chomp.upcase
KEY = "LQ2GT61T164NJZD5"

class Ticker
    data = ""
    # CODE = CODE
    KEY = "LQ2GT61T164NJZD5"
    def getdata
        uri = URI.parse("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=MSFT&interval=5min&apikey=demo")
        params = URI.decode_www_form(uri.query)
        params << ['symbol', CODE]
        params << ['apikey', KEY]
        uri.query = URI.encode_www_form(params)
        response = HTTP.get(uri.to_s)
    end
end


response = Ticker.new.getdata
rawdata = JSON.parse(response)
daily_prices = rawdata["Time Series (5min)"]
prices_by_day = []
daily_prices.each do |date_string, values|
    prices_by_day << (values["1. open"] * 100).to_i
end
product = prices_by_day.reverse.join(" ")
a = prices_by_day.reverse.last(2).first
b = prices_by_day.reverse.last()
b = b.to_s 
# system "spark #{product}"
#system "printf #{b} && spark #{product}"
graff = `spark #{product}`
graff = graff[70...-1]
output = CODE + '  ' + '$' + b.to_s + '  ' + graff
puts output 