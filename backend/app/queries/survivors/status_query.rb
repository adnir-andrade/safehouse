module StatusQuery
  extend self
  attr_reader :query

  def filter
    get_query
    return @query
  end

  private

  def get_query()
    query = Survivor.group(:is_alive).count
    total = query.values.reduce(:+)

    @query = query.map do |is_alive, count|
      [
        is_alive ? "Not Infected" : "Infected / Dead",
        count,
        to_percent(count, total)
      ]
    end
  end

  def to_percent(num, total)
    result = num.to_f / total.to_f
    return "%.1f%%" % (result * 100)
  end
end
