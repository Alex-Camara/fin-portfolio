class Stock
    attr_accessor :company, :symbol, :prices, :shares

    def initialize(company, symbol, prices, shares = 1)
        @company = company
        @symbol = symbol
        @shares = shares
        @prices = prices
    end

    # Returns the price of the stock at a given date if available, returns -1 otherwise. 
    # date - The date represented as as a String with format "YYYY-MM-DD"
    def price_at(date)
        price = @prices[date]
        if(!price.nil?)
            price = price['adjusted-close']
            return price * @shares
        else
            return -1
        end
    end
end