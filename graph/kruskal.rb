#!/usr/bin/ruby
load "graph.rb"

class Graph
  def minimum_spanning_tree
    res = Graph.new(@vertex)
    el = @edges.clone.sort_by! { |e| e[2] }
    components = @vertex.map { |v| [v] } # set of disjointed graph components
    def find(comp, u)
      comp.map { |c| c.include?(u) }.find_index(true)
    end
    el.each { |e|
      if el.include?([e[1],e[0],e[2]])
        el.delete([e[1],e[0],e[2]]) # same path, reverse direction, delete it
      else
        throw "called on directed graph, only undirected graph supported"
      end
      if find(components,e[0]) != (b = find(components,e[1]))
        res.new_edge(e[0],e[1],e[2])
        # bit messy: take components of e[0] and e[1], substitute for
        # component(e[0]) union component(e[1])
        b_c = components.delete_at(b)
        a = find(components,e[0])
        components[a] = components[a] + b_c
      end
    }
    res
  end
end

g = Graph.new([:a,:b,:c,:d,:e])
g.new_edge(:a, :b, 1)
g.new_edge(:a, :c, 4)
g.new_edge(:b, :c, 3)

p g
p g.minimum_spanning_tree
