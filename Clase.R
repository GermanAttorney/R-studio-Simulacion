y<-c(1:10)
p<-c(0.11,0.12,0.09,0.08,0.12,0.10,0.09,0.09,0.10,0.10)

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

fun_ar <-function(Y,p){
  q <- 1/length(Y)
  c<- max(p/q)
  U1<- runif(1)
  Yr<-floor(length(Y)*U1)+1
  U2 <-runif(1)
  if(U2<p[Yr]/(c*q)){
    return(X,Yr)
  }
  else{
    return(X,NA_integer_)
  }
}

fun_ar(y,p) #aceptacion y rechazo

library(tidyverse)

res<-as.data.frame(t(sapply(1:10000, function(k){fun_ar(Y,q)})))
res %>% group_by(v1) %>% summarise(Conteo=n(),Rechazados= sum(is.na(v2)))%>%
  mutate(Porcentaje=Rechazados/Conteo,Teorico=1-(p/(1.2*1/10)))


table(res[!is.na(res)])/length(res[!is.na(res)])

length(res[is.na(res)])/length(res)


