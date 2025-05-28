library(lubridate)
library(purrr)

datos[, fecha_corte:= ymd(fecha_corte)]
datos[, fecha_nacimiento:= ymd(fecha_nacimiento)]
datos|> map_chr(class)

tvar<- datos |> map_chr(class)
vvar_num <-names(tvar[tvar=="numeric"])
tvar <- datos |> map_chr(class)
tvar <- data.table(Variable = names(tvar) , Tipo = unname(tvar))

hist(datos$total_activo_total)

barplot(table(datos$sexo))

random_cong <- function(a,m,x0,n){
  res <- numeric(n+1)
  res[1] <- x0
  for(k in 1:(length(res)-1)){
    res[k+1]<- ((a*res[k]) %% m)
  }
  return(res[-1])
}

set.seed(12345)
runif(n=10)


g <- function(u){
  return(exp(exp(u)))
}

res <- sapply(seq(100,1000000,by=1000), function(k){
  u<-runif(n=k)
  mean(g(u))
})

plot(seq(100,1000000,by=1000), res, main ="valor de aproximacion",
     xlab="Cantidad de numeros aleatorios", 
     ylab="Aproximacion",
     type="l",
     col="red")

func <- "sqrt(1-x^2)"
x <- 0.5
mean(sapply(x,function(x){eval(parse(text=func)})))
