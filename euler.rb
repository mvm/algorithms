#!/usr/bin/ruby

def euler_iteration(df, x, dt)
  x + df.call(x)*dt
end

def euler(df, dt, from, to, at0)
  result = at0
  t = from
  while t < to do
    t += dt
    result = euler_iteration(df, result, dt)
  end
  return result
end

dx = ->(x){-x}
x_real = Math.exp(-1)

print "\tEuler's method:\n"
5.times do |i|
  dt = 10**(-i).to_f
  print "Result (dt = %f): " % [dt]
  x_int = euler(dx, dt, 0, 1, 1)
  p x_int
  print "Error: "
  p (x_int - x_real).abs
end


