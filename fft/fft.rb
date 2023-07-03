#!/usr/bin/ruby

# [0, 1, 2... 15]
coeff = (0..15).to_a

class Array
  def odd_values
    self.values_at(* self.each_index.select {|i| i.odd?})
  end
  def even_values
    self.values_at(* self.each_index.select {|i| i.even?})
  end
end

# complex exponentiation
def exp(z)
  Complex( Math.exp(z.real)*Math.cos(z.imag),
           Math.exp(z.real)*Math.sin(z.imag))
end

# Tukey-Cooley classic FFT
def fft(a)
  r = []
  if a.length == 1
    return a
  else
    # does not yet support arrays of arbitrary dimension
    raise "dimensions of argument should be a power of 2" unless a.length % 2 == 0
    even = fft(a.even_values)
    odd = fft(a.odd_values)
    w = exp(Complex(0, 2*Math::PI/a.length))
    even.length.times do |j|
      r[j] = even[j] + odd[j]*(w**j)
      r[j+(a.length)/2] = even[j] - odd[j]*(w**j)
    end
    return r
  end
end

print "Coefficients: "
p coeff

print "FFT: "
p fft(coeff)

print "Reverse FFT: "
p fft(fft(coeff)).map { |i| (i.real/coeff.length).round(5) }
