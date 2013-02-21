package main
import (
	"fmt"
)

type tile int
const (
	GREEN = iota
	RED
)

type field [][]tile
type prField [][]float32

type gField struct {
	Fd field
	PrFd prField
	PrRead float32
}

/* What our sensors detect. We use this information
 to infer the path we have taken through the field.
 */
var measures []tile = []tile{
	GREEN, GREEN, GREEN, GREEN, GREEN, GREEN }

/* Set our probability field to the default value: uniform
 distribution. */
func New(f field) prField {
	this := make([][]float32, len(f))
	for i := 0; i < len(this); i++ {
		this[i] = make([]float32, len(f[0]))
		for j := 0; j < len(this[i]); j++ {
			this[i][j] = 1;
		}
	}
	return this
}

/* m : the tile read.
 pr : the probability that this measure is correct.

 If m == this.Fd[i][j], then the probability that we're at (i,j) is
 equal to pr*this.PrFd[i][j], that is, the probability that we've
 read it correctly and we are in that point.

 If m != this.Fd[i][j], then it's the inverse: (1-pr)*this.PrFd[i][j].

 Do we need to normalize this.PrFd? Yes. Suppose PrRead = 100%, f. i.
 Then it's obvious we need to normalize, since there will be less
 "probabilistic area" after Update.
 */
func (this *gField) Update(m tile) {
	for i := 0 ; i < len(this.Fd) ; i++ {
		for j := 0 ; j < len(this.Fd[i]) ; j++ {
			if m == this.Fd[i][j] {
				this.PrFd[i][j] *= this.PrRead
			} else {
				this.PrFd[i][j] *= 1 - this.PrRead
			}
		}
	}
	this.Normalize()
}

func (this *gField) Normalize() {
	n := float32(0)
	for i := 0; i < len(this.PrFd) ; i++ {
		for j := 0; j < len(this.PrFd[i]) ; j++ {
			n += this.PrFd[i][j]
		}
	}
	for i := 0; i < len(this.PrFd) ; i++ {
		for j := 0; j < len(this.PrFd[i]) ; j++ {
			this.PrFd[i][j] /= n
		}
	}
}

func (this gField) String() string {
	return fmt.Sprintf("FIELD:\n%v\nPROBABILITY FIELD:\n%v",
		this.Fd, this.PrFd)
}

func main() {
	fld := gField{
		field{  {RED, RED,  RED, RED, GREEN, RED},
			{RED, GREEN, GREEN, GREEN, RED, RED},
			{RED, RED, RED, GREEN, RED, GREEN},
			{RED, GREEN, RED, GREEN, GREEN, RED},
			{RED, RED, GREEN, RED, RED, RED}},
		nil,
		0.9,
	}
	fld.PrFd = New(fld.Fd)
	fld.Normalize()
	fmt.Printf("%v\n", fld)
	fmt.Printf("MEASURES:\n%v\n", measures)
	fld.Update(measures[0])
	fmt.Printf("%v\n", fld)
}