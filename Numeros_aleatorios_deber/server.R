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

fun<-function(x){
  return(x*x)
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
  
  output$metodo_text<- renderText({
    if(input$Modelo==1){
      paste0("Metodo congruencial simple: ","xi =",input$constante,"*x_(i-1) mod(",input$modulo,")" )
    }
    else if(input$Modelo==2){
      paste0("Metodo congruencial mixto: ","xi =",input$constante,"*x_(i-1) +",input$c," mod(",input$modulo,")" )
    }
    
  })
  
  output$resultado_integral <- renderText({
    f <- user_func()
    if (is.null(f)){return("Función inválida")}
    
    valores<-integral_a_b(k=input$k,
                      func=f,
                      a=input$a,
                      b=input$b,
                      metodo=input$Modelo,
                      x0=input$semilla,
                      amod=input$constante,
                      m=input$modulo,
                      c=input$c)
    paste0("Resultado de la integral con ",input$k," iteraciones: ",tail(valores, 1))
    
  })
  
  output$resultado_error <-renderText({
    f <- user_func()
    if (is.null(f)){return("Función inválida")}
    
    valores<-integral_a_b(k=input$k,
                          func=f,
                          a=input$a,
                          b=input$b,
                          metodo=input$Modelo,
                          x0=input$semilla,
                          amod=input$constante,
                          m=input$modulo,
                          c=input$c)
    paste0("Error: ",abs(tail(valores, 1)-integrate(f,lower= input$a,upper=input$b)$value))
  })
  
  
  output$grafico_convergencia <- renderPlot({
    f <- user_func()
    if(is.null(f)){return(NULL)}
    
    valores <- integral_a_b(k=input$k,
                            func=f,
                            a=input$a,
                            b=input$b,
                            metodo=input$Modelo,
                            x0=input$semilla,
                            amod=input$constante,
                            m=input$modulo,
                            c=input$c)
    
    df <- data.frame(
      Iteracion = 1:input$k,
      Estimacion = valores
    )
    
    ggplot(df, aes(x = Iteracion, y = Estimacion)) +
      geom_line(color = input$color) +
      geom_hline(yintercept = integrate(f,lower= input$a,upper=input$b)$value,linetype="dashed",color = input$color2) + ##Linea valor teorico: Aproximacion de R
      labs(title = paste0("Estimación de ∫",input$func_text,  "dx en [",input$a,",", input$b,"]"),
           x = "Iteraciones",
           y = "Estimacion") +
      theme_minimal()
  })
  
  output$Valor_teorico <- renderText({
    f <- user_func()
    if(is.null(f)){return(NULL)}
    a<- paste0("El resultado teorico es: ",integrate(f,lower= input$a,upper=input$b)$value)
  })
  

  
  }
