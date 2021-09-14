require '../models/Portfolio.rb'
require '../models/Stock.rb'
require 'csv'

describe Portfolio do

  def stock_test_prices(csv_file)
    test_stock_data = CSV.read(csv_file, headers: true, converters: :numeric)
    stock_prices = Hash.new
  
    test_stock_data.each do |row|
      prices = Hash.new
      prices['open'] = row[1]
      prices['high'] = row[2]
      prices['low'] = row[3]
      prices['close'] = row[4]
      prices['adjusted-close'] = row[5]
      prices['volume'] = row[5]
      stock_prices[row[0]] = prices
    end
  
    return stock_prices
  end

  # Before the tests run, it initialices the @google_stocks and @amazon_stocks variables
  # loading data from the test_data directory.
  before(:all) do
    @google_stocks = Stock.new('Google', 'GOOG', stock_test_prices('./test_data/GOOG.csv'))
    @amazon_stocks = Stock.new('Amazon', 'AAPL', stock_test_prices('./test_data/AMZN.csv'))
  end

  it 'is a portfolio object' do
    portfolio = Portfolio.new([])
    expect(portfolio).to be_kind_of(Portfolio)
  end

  describe '#profit' do
    context 'when given a date' do
      it 'returns the price at the given date' do
        portfolio = Portfolio.new([@amazon_stocks, @google_stocks])
        expect(portfolio.profit('2020-09-21', '2021-09-02')).to eq(1955.869995)
      end
    end

    context 'when the given dates are not present in the stock data' do
      it 'returns 0' do
        portfolio = Portfolio.new([@amazon_stocks, @google_stocks])
        expect(portfolio.profit('2019-08-26', '2018-09-10')).to eq(0)
      end
    end
  end

  describe '#value_at' do
    context 'when given a date' do
      it 'returns the portfolio value at the given date' do
        portfolio = Portfolio.new([@amazon_stocks, @google_stocks])
        expect(portfolio.value_at('2020-09-21')).to eq(4391.630005)
      end
    end

    context 'when given a date that is not present in the stock data' do
      it 'returns 0' do
        portfolio = Portfolio.new([@amazon_stocks, @google_stocks])
        expect(portfolio.value_at('2020-09-09')).to eq(0)
      end
    end
  end

  describe '#annualized_return' do
    context 'when given a set of two dates' do
      it 'returns the annualized return of the portfolio between the two dates' do
        portfolio = Portfolio.new([@amazon_stocks, @google_stocks])
        annualized_return = portfolio.annualized_return('2020-09-21', '2021-09-02')
        expect(annualized_return).to eq(0.47)
      end
    end

    context 'when given a set of two dates that is not present in the stock data' do
      it 'returns the annualized return of the portfolio between the two dates' do
        portfolio = Portfolio.new([@amazon_stocks, @google_stocks])
        annualized_return = portfolio.annualized_return('2019-09-21', '2019-09-02')
        expect(annualized_return).to eq(0)
      end
    end
  end
end
