require '../models/Stock.rb'
require 'csv'

describe Stock do

  def stock_test_prices(csv_file)
    test_stock_data = CSV.read(csv_file, headers: true, converters: :numeric)
    prices_by_date = Hash.new
  
    test_stock_data.each do |row|
      prices = Hash.new
      prices['open'] = row[1]
      prices['high'] = row[2]
      prices['low'] = row[3]
      prices['close'] = row[4]
      prices['adjusted-close'] = row[5]
      prices['volume'] = row[5]
      prices_by_date[row[0]] = prices
    end
  
    return prices_by_date
  end
  
  # Before the tests run, it initialices the @prices_by_date variable
  # @prices_by_date contains Apple stock historical data
  before(:all) do
    @test_apple_stock_prices = stock_test_prices('./test_data/AAPL.csv')
  end

  it 'is a stock object' do
    stock = Stock.new('Apple', 'AAPL', @test_apple_stock_prices)
    expect(stock).to be_kind_of(Stock)
  end

  describe '#price_at' do
    context 'when given a date' do
      it 'returns the price of the stock at the given date' do
        stock = Stock.new('Apple', 'AAPL', @test_apple_stock_prices)
        price = stock.price_at('2021-09-10')
        expect(price).to eq(148.970001)
      end
    end

    context 'when given a date and the stock has more than one share' do
      it 'returns the price of the stock multiplied by shares at the given date ' do
        stock = Stock.new('Apple', 'AAPL', @test_apple_stock_prices, 4)
        price = stock.price_at('2021-09-10')
        expect(price).to eq(595.880004)
      end
    end

    context 'when given a date not present in the stock data' do
      it 'returns -1' do
        stock = Stock.new('Apple', 'AAPL', @test_apple_stock_prices)
        price = stock.price_at('2019-09-10')
        expect(price).to eq(-1)
      end
    end
  end
end
