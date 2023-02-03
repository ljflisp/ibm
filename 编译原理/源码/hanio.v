const (
  num = 3
)

fn main() {
  hanio(num,'A','B','C')
}

fn move(n int, a string, b string) int {
  println('Disc $n from $a to ${b}...')
  return 0
}

fn hanio(n int, a string, b string, c string) int {
  if n== 1 {
    move(1,a,c)
  }else{
    hanio(n-1,a,c,b)
    move(n,a,c)
    hanio(n-1,b,a,c)
  }
    return 0
}
   // 2^n-1