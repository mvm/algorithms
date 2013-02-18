#!/usr/bin/env ruby

# [weight, value]
problem = [
           [6,30], [3,14], [4, 16], [2, 9]
]

# rep : true if repetitions allowed
def knapsack(prob, max_weight, rep=false, result=[])
  avail = prob.select{|x| x[0] <= max_weight}
  if prob == [] or avail == []
    return result
  end
  item = avail.max_by{|item| item[1]}
  if rep
    knapsack(prob, max_weight - item[0], true, result + [item])
  else
    knapsack(prob - [item], max_weight - item[0], false, result + [item])
  end
end

def total_weight(solution)
  if solution == []
    return 0
  end
  solution.collect{|i| i[0]}.inject(:+)
end

print "Problem: "
p problem
print "Without repetitions, w=10: "
p knapsack(problem, 10, rep=false)
print "With repetition, w=13: "
p knapsack(problem, 13, rep=true)
