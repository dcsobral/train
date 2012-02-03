class RoutePlanner
	def initialize(graph)
		@graph = graph
	end

	def distance_for_path(route)
		stops = route.split "-"
		stretchs = stops.zip(stops.drop(1)).map { |s| s.join }.select { |s| s.size == 2 }
		raise "NO SUCH ROUTE" if stretchs.find { |s| not @graph.include? s }
		stretchs.map { |s| distance_for_stretch(s) }.inject(:+)
	end

	def trips_for(params)
		raise("start parameter required") if params[:start].nil?
		raise("finish parameter required") if params[:finish].nil?
		params[:max_stops] = 10 if params[:max_stops].nil?
		params[:min_stops] = 1 if params[:min_stops].nil?

		all_trips(params, [params[:start]])
	end

	def shortest(params)
		raise("start parameter required") if params[:start].nil?
		raise("finish parameter required") if params[:finish].nil?
		trips = trips_for(params)
		trips = trips.map { |t| t.join('-') }
		trips = trips.map { |t| distance_for_path(t) }
		trips.min
	end

	def num_shortest(params)
		raise("start parameter required") if params[:start].nil?
		raise("finish parameter required") if params[:finish].nil?
		raise("distance parameter required") if params[:max_distance].nil?
		trips = trips_for(params)
		trips = trips.map { |t| t.join('-') }
		trips = trips.map { |t| distance_for_path(t) }
		trips = trips.select { |t| t < params[:max_distance] }
		trips.size
	end

	private
	def distance_for_stretch(stretch)
		@graph =~ /\b(#{stretch}(\d+))/
		$2.to_i
	end

	def all_trips(params, current)
		visiting = current.last

		if current.size - 1 >= params[:min_stops] and current.size - 1 <= params[:max_stops] and visiting == params[:finish]
			result = [Array.new(current)]
		else
			result = []
		end

		unless current.size - 1 > params[:max_stops]
			to_visit = @graph.scan(/\b#{visiting}(\w)/).map { |c| c.join }
			to_visit.each do |n|
				current.push(n)
				result.concat(all_trips(params, current))
				current.pop
			end
		end
		result
	end
end
