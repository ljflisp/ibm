struct Vlang {
  mut:
    a  int = 2 
    s  int = 1
  pub mut:
    pi f64 = 3.0
}

fn (mut this Vlang) iterate() f64 {
  s := f64(this.s)
  a := f64(this.a)

  this.pi += s*(4.0/(a*(a*(a+3.0)+2.0)))
  this.a += 2
  this.s = -this.s

  return this.pi
}

fn main() {
  mut pillar := Vlang{}
  for _ in 2 .. 150000 {
    pillar.iterate()
  }
    println("pi = ${pillar.pi:.3f}")
}    