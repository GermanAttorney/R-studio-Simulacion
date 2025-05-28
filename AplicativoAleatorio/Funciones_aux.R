congruencial <- function(x0, a, m, n) {
  res <- c(rep(0,n))
  for (i in 1:n) {
    x0 <- (a * x0) %% m
    res[i] <- x0 / m
  }
  return(res)
}


congruencial_multiplicativo <- function(x0, a, m, c, n) {
  res <- c(rep(0,n))
  for (i in 1:n) {
    x0 <- (a * x0 + c) %% m
    res[i] <- x0 / m
  }
  return(res)
}


integral_a_b <- function(k, func,a,b, metodo = 1, x0, amod, m, c = 0) {
  valores <- c(rep(0,k))
  suma <- 0
  if (metodo == 1) {
    u <- congruencial(x0, amod, m, k)
  } else if (metodo == 2) {
    u <- congruencial_multiplicativo(x0, amod, m, c, k)
  }
  for (i in 1:k) {
    suma <- suma + (func(a+ (b-a)*u[i])*(b-a))  
    valores[i] <- suma / i
  }
  return(valores)
}
