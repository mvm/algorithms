#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# An Un is an unitary expression. It has only one label.
class Un
  def initialize(l,v=nil)
    @label = l
    @value = v
  end
  def label
    @label
  end
  def to_s
    if @value != nil
      "{%s=%s}" % [@label, @value]
    else
      @label.to_s
    end
  end
  def value
    @value
  end
  def set!(v)
    @value = v
  end
end

class Not < Un
  def to_s
    if @value != nil
      "{¬%s=%s}" % [@label, @value]
    else
      "¬%s" % @label.to_s
    end
  end
  def value
    if @value == nil
      @value
    else
      not @value
    end
  end
  def set!(v)
    @value = not(v)
  end
end

class Li
  def initialize(*exprs)
    @exprs = exprs
  end
  # Eventually we need to find all the labels of an expression. This method
  # does so.
  def label
    @exprs.map{|e| e.label}.flatten.uniq
  end
  # CAREFUL: a sustitution x => bool sets ¬x to its opposite
  def apply(sust)
    # Sustitute on unitary expressions.
    sust.each do |k,v|
      @exprs.select{|e| e.is_a? Un and e.label == k}.map{|e| e.set!(v)}
    end
    # Now onto list expressions. We filter them out, then call their apply
    # with our sustitution.
    @exprs.select{|e| e.is_a? Li}.map{|e| e.apply(sust)}    
  end
  # We need to check if a list expression is compatible, that is, if
  # there's no contradiction. Typically, this will be done after apply'ing
  # a sustitution, since by default everything is nil (undefined).
  # Value will return true if the expression is compatible
  def value
    throw "not implemented"
  end
end

class Or < Li
  def to_s
    "(%s)" % @exprs.map{|e| e.to_s}.join("\u2228")
  end
  # To check for the validity of an OR expression, find if every element is
  # false. If so, it's not valid. Only way to do this, since nil is falsy.
  def value
    not @exprs.map{|e| e.value === false}.inject(:&)
  end
end

class And < Li
  def to_s
    "(%s)" % @exprs.map{|e| e.to_s}.join("\u2227")
  end
  # An AND expression can be checked for validity by checking if there's a
  # false value. If there is, it's not valid.
  def value
    not @exprs.map{|e| e.value === false}.inject(:|)
  end
end

def solve(expr, sust={})
  my_expr = expr.clone
  my_expr.apply(sust)
  remaining = my_expr.label - sust.keys
  if my_expr.value == false
    return {}
    # If it checks, and we've substituted every variable, return the
    # sustitution.
  elsif my_expr.value == true and remaining == []
    return sust
  else
    # It's still compatible, but we have work to do. Get a new variable,
    # then try with it being both possibilities.
    new_var = remaining.pop
    s_true, s_false = sust.clone, sust.clone
    s_true[new_var] = true
    s_false[new_var] = false
    r1 = solve(expr, s_true)
    r2 = solve(expr, s_false)
    # If we solve with both true and false, then set x to nil (undefined, any
    # value).
    if r1 != {} and r2 != {}
      sust[new_var] = nil
      return sust
    elsif r1 != {}
      return r1
    elsif r2 != {}
      return r2
    end
    return {}
  end
end

expr = And.new(Or.new(Un.new(:x), Not.new(:z)),Or.new(Not.new(:x), Un.new(:y)), Or.new(Un.new(:y)))
p expr.to_s
p solve(expr)

