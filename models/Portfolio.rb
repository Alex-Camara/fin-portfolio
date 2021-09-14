class Portfolio
  attr_accessor :stocks
  DAYS_IN_A_YEAR = 365

  def initialize(stocks)
    @stocks = stocks
  end

  # Returns the profit value between two dates and its annualized return.
  #
  # start_date - the start date represented as a String with format 'YYYY-MM-DD'
  # end_date - The end date represented as a String with format 'YYYY-MM-DD'
  def profit(start_date, end_date)
    profit = value_at(end_date) - value_at(start_date)

    annualized_return = annualized_return(profit, start_date, end_date)

    profit_response = Hash['profit' => profit, 'annualized_return' => annualized_return]

    return profit_response
  end

  # Returns the profit value at a given date.
  #
  # date - the date represented as a String with format 'YYYY-MM-DD'
  def value_at(date)
    total_stock_value = 0

    @stocks.each do |stock|
      # We check if the value is 0 or more, if it isn't, it means the date has not a related value
      # and we set the value to 0.
      total_stock_value += stock.price_at(date) > 0 ? stock.price_at(date) : 0
    end

    return total_stock_value
  end

  # Returns the number of days between the dates.
  #
  # start_date - the start date represented as a String with format 'YYYY-MM-DD'
  # end_date - The String end date represented as as a String with format 'YYYY-MM-DD'
  def days_between(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    return (end_date - start_date).to_i
  end

  # Returns the portfolio's annualized return between two dates.
  #
  # profit - portfolio profit value between the given dates
  # start_date - the start date represented as a String with format 'YYYY-MM-DD'
  # end_date - The String end date represented as as a String with format 'YYYY-MM-DD'
  def annualized_return(profit, start_date, end_date)
    annualized_return = 0

    portfolio_start_value = value_at(start_date)

    # Check if the profit and the portfolio value at start date are bigger than 0 
    # if not, they formula can't be applied.
    if (profit > 0 && portfolio_start_value > 0)

      # Obtain the cumulative return with the formula
      # cumulative_return = profit / original price of security
      cumulative_return = profit / portfolio_start_value

      # Get the power period which is obtained using the formula:
      # days in year / the number of days the stock has been in the portfolio
      power_period = DAYS_IN_A_YEAR / days_between(start_date, end_date).to_f

      annualized_return = (cumulative_return + 1) ** power_period - 1
    end

    return annualized_return.round(2)
  end
end
