require 'test/unit'
require 'route_planner'

class TestRoutePlanner < Test::Unit::TestCase
	MainGraph = 'AB5, BC4, CD8, DC8, DE6, AD5, CE2, EB3, AE7'
	Graph = RoutePlanner.new MainGraph

	def test_ab
		assert_equal 5, Graph.distance_for_path('A-B')
	end

	def test_bc
		assert_equal 4, Graph.distance_for_path('B-C')
	end

	def test_abc
		assert_equal 9, Graph.distance_for_path('A-B-C')
	end

	def test_ad
	        assert_equal 5, Graph.distance_for_path('A-D')
	end

	def test_adc
		assert_equal 13, Graph.distance_for_path('A-D-C')
	end

	def test_aebcd
		assert_equal 22, Graph.distance_for_path('A-E-B-C-D')
	end

	def test_aed
		assert_raise RuntimeError do
			Graph.distance_for_path('A-E-D')
		end
	end

	def test_trips_cc
		assert_equal 2, Graph.trips_for(:start => 'C',
						:finish => 'C',
						:max_stops => 3).size
	end

	def test_trips_ac
		assert_equal 3, Graph.trips_for(:start => 'A', 
						:finish => 'C', 
						:min_stops => 4,
						:max_stops => 4).size
	end

	def test_shortest_ac
		assert_equal 9, Graph.shortest(:start => 'A',
					       :finish => 'C')
	end

	def test_shortest_bb
		assert_equal 9, Graph.shortest(:start => 'B',
					       :finish => 'B')
	end

	def test_nshortest_cc
		assert_equal 7, Graph.num_shortest(:start => 'C',
						   :finish => 'C',
						   :max_distance => 30)
	end
end


