#generar distribuciones de variables discretas.

fun_poisson<- function(lambda){
  U<-runif(1)
  pk<- exp(-lambda)
  k<-0
  Fk<-0
  repeat{
    Fk<-Fk+pk
    if(U<Fk){
      return(k)
    }
    k<-k+1
    pk<- (lambda/k)*pk
  }
}


fun_binomial<- function(n,p){
  U<-runif(1)
  pk<- (1-p)^n
  k<-0
  Fk<-0
  repeat{
    Fk<-Fk+pk
    if(U<Fk){
      return(k)
    }
    pk<- pk*((n-k)*p)/((1-p)*(k+1))   
    k<-k+1
  }
}



fun_binomial_neg<- function(r,p){
  U<-runif(1)
  pk<- (p)^r
  k<-0
  Fk<-0
  repeat{
    Fk<-Fk+pk
    if(U<Fk){
      return(k)
    }
    pk<- pk*((k+r)*(1-p))/(k+1)
    k<-k+1
  }
}

fun_dist_custom<- function(p,x){
  u<-runif(1)
  if(sum(p)!=1){
    return(NA)
  }
  for(i in 1:(length(p))){
    if(u<cumsum(p)[i]){
      return(x[i])
    }
  }
}

p<-c(0.15,0.25,0.20,0.40)
x<-c(0,1,2,3)

fun_dist_custom(p,x)

table(sapply(1:100000, function(k){fun_dist_custom(p,x)}))/100000

plot(x,p)

#Y. v.a discreta unif
py<-(rep(1/length(x),length(x)))
y<-x

c<- max(p/py)


#V.A continuas

#1. F(x)=lambda*exp(-lambda *x)=u, F-1(u)=-1/lambda * ln(U/lambda)
fun_exp<- function(lambda){
  U<-runif(1)
  return((-1/lambda)*log(U))
}
options(scipen=999)
res <- sapply(1:10000,function(k){fun_exp(5)})
hist(res,col="#389dff",freq=FALSE,)

#Funcion de densidad exp
f<- function(x){
  lambda<-5
  return(lambda*exp(-lambda*x))  
}

curve(f,lwd=2,add=TRUE)

#Distr Laplace
fun_lap<- function(lambda){
  U<-runif(1)
  if(U<1/2){
    return((1/lambda)*log(2*U))
  }
  else{
    return((-1/lambda)*log(2-2*U))
  }
}

sapply(1:120,function(k){fun_lap(3)})

#Funcion exponencial con media 22.
res <- sapply(1:10000,function(k){fun_exp(1/22)})
#P(x<10)
length(res[res<10])/length(res)

#b)El costo de reparacion es de 2000 dolares por cada media hora o fraccion.
#P(30<x<60) 
library(data.table)
T1<-data.table(N=1:10000,X=sapply(1:10000,function(k){fun_exp(1/22)}))
T1[,CostoReparacion:=2000*cealing(x/30)]



