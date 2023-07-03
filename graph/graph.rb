#!/usr/bin/ruby

class Graph
  @edges = []
  @vertex = []
  def initialize(v)
    @vertex = v
    @edges = []
  end
  def new_edge(a, b, cost, directed = false)
    throw "vertex not found" unless @vertex.include?(a) and @vertex.include?(b)
    @edges.push([a,b,cost])
    if not directed
      @edges.push([b,a,cost])
    end
  end
  def to_s
    edge_s = []
    edge_l = @edges.clone
    edge_l.each { |e| 
      if edge_l.include?([e[1],e[0],e[2]])
        edge_l.delete([e[1],e[0],e[2]])
        edge_s.push(e[0].to_s + " <-> " + e[1].to_s + " (" + e[2].to_s + ")")
      else
        edge_s.push(e[0].to_s + " -> " + e[1].to_s + " (" + e[2].to_s + ")")
      end
    }
    return "Graph(" + @vertex.to_s + ", [" + edge_s.join(", ") + "])"
  end
end
