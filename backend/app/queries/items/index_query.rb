module IndexQuery
  extend self
  attr_reader :query

  def sort_data(sorter)
    filters = {
      "name-asc" => -> { get_query("name ASC") },
      "name-desc" => -> { get_query("name DESC") },
      "value-asc" => -> { get_query("value ASC") },
      "value-desc" => -> { get_query("value DESC") },
      "description" => -> { get_query("description") },
    }

    filters.fetch(sorter, -> {
      get_query
      return @query
    }).call
  end

  private

  def get_query(sorter = "id ASC")
    @query = Item.select(
      "name", 
      "value", 
      "description"
      ).order(sorter)
      
    @query = @query.map do |entry|
      {
        name: entry.name,
        value: entry.value,
        description: entry.description
      }.values
    end
  end
end
