class RoutePlanner
	def initialize(graph)
		@graph = graph
	end

	def distance_for_path(route)
		stops = route.split "-"
		stretchs = stops.zip(stops.drop(1)).map { |s| s.join }.select { |s| s.size == 2 }
		raise "NO SUCH ROUTE" if stretchs.find { |s| not @graph.include? s }
		stretchs.map { |s| distance_for_stretch(s) }.inject(0, :+)
	end

	def trips_for(params)
		raise("start parameter required") if params[:start].nil?
		raise("finish parameter required") if params[:finish].nil?
		raise("max_stops parameter required") if params[:max_stops].nil?
		params[:min_stops] = 1 if params[:min_stops].nil?

		trips = all_trips([[params[:start]]]) do |routes|
			routes.detect { |route| route.size - 1 > params[:max_stops] }
		end
		trips = trips.select { |route| route.last == params[:finish] }
		trips = trips.select { |route| route.size - 1 >= params[:min_stops] }
		trips = trips.select { |route| route.size - 1 <= params[:max_stops] }
		trips
	end

	def shortest(params)
		raise("start parameter required") if params[:start].nil?
		raise("finish parameter required") if params[:finish].nil?

		trips = all_trips([[params[:start]]]) do |routes|
			routes.detect { |route| route.size > 1 && route.last == params[:finish] }
		end
		trips = trips.select { |route| route.last == params[:finish] }
		trips = trips.map { |t| t.join('-') }
		trips = trips.map { |t| distance_for_path(t) }
		trips.min
	end

	def num_shortest(params)
		raise("start parameter required") if params[:start].nil?
		raise("finish parameter required") if params[:finish].nil?
		raise("distance parameter required") if params[:max_distance].nil?

		trips = all_trips([[params[:start]]]) do |routes|
				routes = routes.map { |t| t.join('-') }
				routes = routes.map { |t| distance_for_path(t) }
				!routes.detect { |t| t < params[:max_distance] }
		end
		trips = trips.select { |route| route.last == params[:finish] }
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

	def all_trips(current)
		result = []
		until yield(current)
			current = current.map do |route|
				visiting = route.last
				@graph.scan(/\b#{visiting}(\w)/).map { |c| route + [c.join] }
			end
			current = current.inject(:+)
			result = result + current
		end

		result
	end
end
