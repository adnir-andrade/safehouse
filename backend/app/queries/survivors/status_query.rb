module StatusQuery
  extend self
  attr_reader :query

  def filter
    get_query
  end

  private

  def get_query()
    # TODO: NOT working as intended. gotta make a subquery, possibly, and use "count"
    @query = Survivor.select(
      "SUM(CASE WHEN is_alive = true THEN 1 ELSE 0 END) AS not_infected",
      "SUM(CASE WHEN is_alive = false THEN 1 ELSE 0 END) AS infected",
      "COUNT(*) AS total"
    ).group(:is_alive)

    binding.pry
      
    @query = @query.map do |entry|
      {
        not_infected: entry.not_infected / entry.total,
        infected: entry.infected / entry.total,
      }.values
    end
  end
end
