class Portfolio
  attr_accessor :stocks
  DAYS_IN_A_YEAR = 365

  def initialize(stocks)
    @stocks = stocks
  end

  # Returns the profit value between two dates.
  #
  # start_date - the start date represented as a String with format "YYYY-MM-DD"
  # end_date - The end date represented as a String with format "YYYY-MM-DD"
  def profit(start_date, end_date)
    total_stock_start_value = 0
    total_stock_end_value = 0

    @stocks.each do |stock|
      # We look if the value is 0 or more, if it isn't, it means the date has not a related value
      # so we set the value to 0.
      total_stock_start_value += stock.price_at(start_date) > 0 ? stock.price_at(start_date) : 0
      total_stock_end_value += stock.price_at(end_date) > 0 ? stock.price_at(end_date) : 0
    end

    return total_stock_end_value - total_stock_start_value
  end

  # Returns the profit value at a given date.
  #
  # date - the date represented as a String with format "YYYY-MM-DD"
  def value_at(date)
    total_stock_value = 0

    @stocks.each do |stock|
      # We look if the value is 0 or more, if it isn't, it means the date has not a related value
      # and we set the value to 0.
      total_stock_value += stock.price_at(date) > 0 ? stock.price_at(date) : 0
    end

    return total_stock_value
  end

  # Returns the number of days between the dates.
  #
  # start_date - the start date represented as a String with format "YYYY-MM-DD"
  # end_date - The String end date represented as as a String with format "YYYY-MM-DD"
  def days_between(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    return (end_date - start_date).to_i
  end

  # Returns the portfolio's annualized return between two dates.
  #
  # start_date - the start date represented as a String with format "YYYY-MM-DD"
  # end_date - The String end date represented as as a String with format "YYYY-MM-DD"
  def annualized_return(start_date, end_date)
    profit = profit(start_date, end_date)

    # Obtain the cumulative return with the formula
    # cumulative_return = profit / original price of security
    cumulative_return = profit / value_at(start_date)

    # We get the power period which is obtained using the formula:
    # days in year / the number of days the stock has been in the portfolio
    power_period = DAYS_IN_A_YEAR / days_between(start_date, end_date).to_f

    annualized_return = (cumulative_return + 1) ** power_period - 1

    return annualized_return.round(2)
  end
end
