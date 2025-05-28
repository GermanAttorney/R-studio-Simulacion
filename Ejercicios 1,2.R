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

x<-c(1,2,3,4,5,6)
p<-c(rep(1/6,length(x)))


##Ejercicio 1
##A
juego1_1paso<-function(s,eleccion){ #eleccion (3-18); s dinero actual>8
  x<-c(1,2,3,4,5,6) #dado
  p<-c(rep(1/6,length(x))) #prob dado
  d<-c(0,0,0) #3 dados
  #eleccion<-sample(x=3:18,size=1,replace=TRUE) #eleccion   
  for(i in 1:3){d[i]<-fun_dist_custom(p,x)}
  if(sum(d)==eleccion){
    s<- s+100
  }else{
    s<- s-8
  }
  return(s)
}

mean(sapply(1:100000,function(x){juego1_1paso(0,10)}))

##B
juego2_1paso<-function(s,eleccion){ #eleccion (1-6); s dinero actual>25
  x<-c(1,2,3,4,5,6) #dado
  p<-c(rep(1/6,length(x))) #prob dado
  d<-c(0,0,0,0) #3 dados
  #eleccion<-sample(x=1:6,size=1,replace=TRUE) #eleccion   
  for(i in 1:4){d[i]<-fun_dist_custom(p,x)}
  if(length(d[d==eleccion])>0){
    s<- s+length(d[d==eleccion])*10
  }else{
    s<- s-25
  }
  return(s)
}

mean(sapply(1:100000,function(x){juego2_1paso(0,4)})) #

##Ejercicio 2
Asignacion_tabla<-function(){
  p<-c(0.24,0.17,0.29,0.12,0.09,0.05,0.04)
  x<-c(2,3,4,5,6,7,8)
  mesas_max<-28
  ppm<-6
  max_reserva<-35
  p_noasist<-0.2
  y<-sample(x=c(0,1),size=35,replace=TRUE,prob=c(0.2,0.8))
  reservas<-sapply(1:35,function(y){fun_dist_custom(p,x)})
  mesas<-c(rep(0,length(reservas)))
  for(i in 1:length(reservas)){if(reservas[i]>=7){mesas[i]<-2}else{mesas[i]<-1}}
  lista_de_reservas<-data.table(
    "Viene"= y, 
    "asisten"=reservas,
    "mesas"=mesas
    ) 
  return(lista_de_reservas)
}
Asignacion_tabla()
##A
prob_a<-function(){
  p<-c(0.24,0.17,0.29,0.12,0.09,0.05,0.04)
  x<-c(2,3,4,5,6,7,8)
  mesas_max<-28
  ppm<-6
  max_reserva<-35
  p_noasist<-0.2
  asiste<-sample(x=c(0,1),size=max_reserva,replace=TRUE,prob=c(0.2,0.8))
  reservas<-sapply(1:max_reserva,function(y){fun_dist_custom(p,x)})
  mesas<-c(rep(0,length(reservas)))
  for(i in 1:length(reservas)){
    if(asiste[i]==1){
      if(reservas[i]>=7){
        mesas[i]<-2
      }else{
        mesas[i]<-1
      }
    }
    else{mesas[i]<-0}
    }
  cond<-sum(mesas)
  if(cond<=mesas_max){
    return(1)
  }
  else{
    return(0)
  }
}
mean(sapply(1:1000000, function(a){prob_a()}))



