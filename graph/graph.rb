#!/usr/bin/ruby

class Graph
  @edges = []
  @vertex = []
  def initialize(v)
    @vertex = v
    @edges = []
  end
  def new_edge(a, b, directed = false)
    throw "vertex not found" unless @vertex.include?(a) and @vertex.include?(b)
    @edges.push([a,b])
    if not directed
      @edges.push([b,a])
    end
  end
  def to_s
    edge_s = []
    edge_l = @edges.clone
    edge_l.each { |e| 
      if edge_l.include?([e.last,e.first])
        edge_l.delete([e.last,e.first])
        edge_s.push(e.first.to_s + " <-> " + e.last.to_s)
      else
        edge_s.push(e.first.to_s + " -> " + e.last.to_s)
      end
    }
    return "Graph(" + @vertex.to_s + ", [" + edge_s.join(", ") + "])"
  end
end


