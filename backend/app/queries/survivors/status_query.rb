# module IndexQuery
#   extend self
#   attr_reader :query

#   def sort_data(sorter)
#     filters = {
#       "name-asc" => -> { get_query("name ASC") },
#       "name-desc" => -> { get_query("name DESC") },
#       "gender" => -> { get_query("gender") },
#       "age-asc" => -> { get_query("age ASC") },
#       "age-desc" => -> { get_query("age DESC") },
#     }

#     filters.fetch(sorter, -> {
#       get_query
#       return @query
#     }).call
#   end

#   private

#   def get_query(sorter = "id ASC")
#     @query = Survivor.select(
#       "name", 
#       "gender", 
#       "age"
#       ).where(is_alive: true).order(sorter)
      
#     @query = @query.map do |entry|
#       {
#         name: entry.name,
#         gender: entry.gender,
#         age: entry.age
#       }.values
#     end
#   end
# end
