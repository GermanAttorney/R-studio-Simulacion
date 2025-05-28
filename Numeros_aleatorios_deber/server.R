#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(data.table)
library(ggplot2)
library(kableExtra)

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

conv_matrix <- function(vector,cols=10){
  res<-rep(NA_real_,ceiling(length(vector)/cols)*cols)
  res[1:length(vector)]<-vector
  res <- as.data.frame(matrix(res,nrow=ceiling(length(vector)/cols),ncol=cols,byrow=TRUE))
  colnames(res) <- paste0("Col ",1:cols)
  
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
  if (is.finite(a) && is.finite(b)){
    for (i in 1:k) {
      suma <- suma + (func(a+ (b-a)*u[i])*(b-a))  
      valores[i] <- suma / i
    }
  }
  else if (is.finite(a) && !is.finite(b)){
    for (i in 1:k) {
      if(a==0){
        suma <- suma + 1/(u[i]*u[i]) * func(1/u[i] -1)
      }
      else{
        suma <- suma + (2*a/(u[i]*u[i]))*func(2*a/u[i] - a)  
      }
      
      valores[i] <- suma / i
    }
  }
  else if (!is.finite(a) && is.finite(b)){
    for (i in 1:k) {
      if(b==0){
        suma <- suma + (-1/(u[i]*u[i])) * func(1/u[i] -1)
      }
      else{
        suma <- suma + (-2*b/(u[i]*u[i]))*func(2*b/u[i] - b)  
      }
 
      valores[i] <- suma / i
    }
  }
  else{
    for (i in 1:k) {
    suma <- suma + pi/(cos(pi*(u[i]-1/2))^2) * func(tan(pi*(u[i]-1/2)))
    valores[i] <- suma / i
    }
  }

  return(valores)
}




# Define server logic required to draw a histogram
function(input, output, session) {
  
  user_func <- reactive({
    texto <- input$func_text
    # Construye una función f(x)
    tryCatch({
      eval(parse(text = paste0("function(x) { ", texto, " }")))
    }, error = function(e) {
      return(NULL)
    })
  })
  
  resultado<- eventReactive(input$calcular,{
    f <- user_func()
    if(is.null(f)){return(NULL)}
    
    valores<-integral_a_b(k=input$k,
                          func=f,
                          a=input$a,
                          b=input$b,
                          metodo=input$Modelo,
                          x0=input$semilla,
                          amod=input$constante,
                          m=input$modulo,
                          c=input$c)
    
    titul_fun<- paste("Integral ",input$func_text)
    
    valor_teorico<- paste0("El resultado teórico es: ",integrate(f,lower= input$a,upper=input$b)$value)
    
    if(input$Modelo==1){
      metodo_text<-paste0("Metodo congruencial simple: ","xi =",input$constante,"*x_(i-1) mod(",input$modulo,")" )
    }
    else if(input$Modelo==2){
      metodo_text<-paste0("Metodo congruencial mixto: ","xi =",input$constante,"*x_(i-1) +",input$c," mod(",input$modulo,")" )
    }
    
    if(input$Modelo==1){
      vector<-conv_matrix(congruencial(a=input$constante,m=input$modulo,x0=input$semilla,n=input$n-1),cols=input$columnas)
    }else if(input$Modelo==2){
      vector<-conv_matrix(congruencial_multiplicativo(a=input$constante,m=input$modulo,c=input$c,x0=input$semilla,n=input$n-1),cols=input$columnas)
    }
    
    resultado_integral<- paste0("Resultado de la integral con ",input$k," iteraciones: ",tail(valores, 1))
    resultado_error<-paste0("Error: ",abs(tail(valores, 1)-integrate(f,lower= input$a,upper=input$b)$value))
    
    x_vals<- seq(input$a,input$b,length.out=100)
    y_vals <- sapply(x_vals, f) 
    coords<-data.frame(x_vals,y_vals)
    
    grafico_area<-    ggplot(coords, aes(x = x_vals, y = y_vals)) +
      geom_line(color = input$color_func, linewidth = 2) +
      geom_area(fill = input$color_area, alpha = 0.6) +
      geom_vline(xintercept = input$a, linetype = "dashed", color = input$color_limites) +
      geom_vline(xintercept = input$b, linetype = "dashed", color = input$color_limites) +
      labs(title = paste("Área bajo la curva de la función f(x) =", input$func_text),
           subtitle = paste("Intervalo:", input$a, "a", input$b),
           x = "x", y = "f(x)")
    df <- data.frame(
      Iteracion = 1:input$k,
      Estimacion = valores
    )
    grafico_convergencia<-ggplot(df, aes(x = Iteracion, y = Estimacion)) +
      geom_line(color = input$color) +
      geom_hline(yintercept = integrate(f,lower= input$a,upper=input$b)$value,linetype="dashed",color = input$color2) + ##Linea valor teorico: Aproximacion de R
      labs(title = paste0("Estimación de ∫",input$func_text,  "dx en [",input$a,",", input$b,"]"),
           x = "Iteraciones",
           y = "Estimación") +
      theme_minimal()
    
    return(list(
      titul_fun = titul_fun,
      valor_teorico = valor_teorico,
      metodo_text = metodo_text,
      resultado_integral = resultado_integral,
      resultado_error = resultado_error,
      valores = valores,
      f = f,
      vector=vector,
      grafico_area=grafico_area,
      grafico_convergencia=grafico_convergencia
    ))
  })
  
  output$titul_fun <- renderText({
    req(resultado())
    resultado()$titul_fun
  })
  
  output$Valor_teorico <- renderText({
    req(resultado())
    resultado()$valor_teorico
  })
  
  output$metodo_text<- renderText({
    req(resultado())
    resultado()$metodo_text
  })
  
  output$resultado_integral <- renderText({
    req(resultado())
    resultado()$resultado_integral
  })
  
  output$resultado_error <-renderText({
    req(resultado())
    resultado()$resultado_error
  })
  
  output$grafico_convergencia <- renderPlot({
    req(resultado())
    resultado()$grafico_convergencia
  })
  
  output$grafico_area <- renderPlot({
    req(resultado())
    resultado()$grafico_area
  })
  
  output$tabla_aleatorio<- renderUI({
    req(resultado())
    HTML(
      kbl(resultado()$vector, booktabs=TRUE, escape=FALSE) %>% 
        kable_styling(full_width = FALSE, bootstrap_options = c("bordered"),font_size = 12) %>%
        row_spec(0,background = "#1D3889",color="#FFFFFF") %>%
        scroll_box(height = "100%",width="800px")
    )
  })

  output$histograma_numeros <- renderPlot({
    req(resultado())  # Asegura que haya un resultado disponible
    numeros <- unlist(resultado()$vector)
    hist(numeros,
         breaks = 30,
         col = input$color_areahist,
         border = input$color_barhist,
         main = "Histograma de los Números Aleatorios",
         xlab = "Valores",
         ylab = "Frecuencia")
  })
  
  }
