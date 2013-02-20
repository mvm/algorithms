package main
import (
	"math"
)

/* A Restricted Boltzmann machine is a network of "neurons", each of
 which is in one of two states S ∊ {0,1}. This system has a global
 energy, which is defined by
 
 E = - ∑ w_ij s_i s_j - ∑ θ_i s_i
 
 Here w_ij means the strength of the connection between i and j, s_i means
 the state of the neuron i, and θ_i is the bias, or threshold, of the
 neuron.
 
 If the network is updated constantly, it will reach an equilibrium state
 that minimizes (not necessarily globally, but pretty well) the energy
 of the network. In mathematical terms, the probability of a final state
 v of the network will depend on the energy of the state, relative to
 all the energies of all states:

 P(v) = exp(-E(v))/ ∑_w exp(-E(w))

 In this case, the greater E(v) is, the lesser the probability of ending
 in that state will be.

 */

/* A neuron, or RBM, has the following attributes:

 A bias, θ_i, which determines the propensity of the neuron to fire. If
 θ_i is positive, it fires more easily.

 A state, s_i. Any neuron can be in one of two possible states: either on
 or off (true or false).

 */
type Neuron struct {
	Bias float32
	State bool
}

/* What remains is w_ij, the strength of the connection between neurons i
 and j. It can be positive or negative. It's sort of a correlation between
 neurons. If that correlation is positive, all related neurons will fire
 more often. If it's negative, a fired neuron will turn off nearby neurons.

 What makes Restricted Boltzmann Machines restricted is that we don't allow
 arbitrary connections. Units are divided in layers, and we only allow
 connections between those layers, not within.

 A network could be described so:
*/
type Network struct {
	Conn [][]float32
	Units []Neuron
}

/* Pr is the probability that a RBM will be on in the next cycle.
 It depends on the difference in global energy that would result
 in unit i changing state (positive if it will go on, negative otherwise).
 The expression for this probability is derived somewhat like this:

 Differentiating the global energy equation for each particle i gives us a
 "neuron energy", which is equal to E_i = ∑ w_ij s_j + θ_i . This is equal
 to E_i=off - E_i=on, that is, the amount of energy required to put this
 neuron in the on-state if it was previously off.

 For instance, if there are lots of neurons s_j to which we are positively
 connected (w_ij > 0), E_i will increase, making the probability of our
 neuron E_i to be "on" increase too.

 TODO: Include simmulated annealing (T as factor).
*/
func Pr(E_i float64) float64 {
	return 1/(1 + math.Exp(-E_i))
}

func main() {
	panic("to be continued")
}