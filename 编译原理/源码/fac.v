fn fac(n u32) u32 {
  if dump(n <= 1) {
    return dump(1)
    }
    return dump(n*fac(n-1))
}

fn main() {
  println(fac(5))
    }