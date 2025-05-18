#Ejercicio 12

Variable_N<- function(){
  suma<-0
  n<-0
  while(suma<=1){
    suma<-suma+runif(1)
    n<-n+1
  }
  return(n)
}

item<-c(100,1000,10000)
text<-c("a)","b)","c)")
for(i in 1:3){
  valores_N<-replicate(item[i],Variable_N())
  print(paste0(text[i]," Estimacion de E[N] con ",item[i]," es: ",mean(valores_N)))
}
print(paste0("d) El valor esperado E[N] es: e=",exp(1)))
