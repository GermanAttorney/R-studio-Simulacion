#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(tidyverse)
#Carga de datos
load("./data/Info.RData")

datos[, fecha_corte:= ymd(fecha_corte)]
datos[, fecha_nacimiento:= ymd(fecha_nacimiento)]

function(input, output, session) {
  tvar <- datos |> map_chr(class)
  tvar <- data.table(Variable = names(tvar) , Tipo = unname(tvar))
  observe({
    updateSelectInput(session,"var",choice=tvar[Tipo ==input$tipo])
  })
  
  
  output$resumen <- renderPrint({
    datos %>% dplyr::select(input$var) %>% summary(.)
  })
  
  output$grafico <- renderPlot({
    if(input$tipo =="numeric"){
      datos %>% dplyr::select(input$var) %>% pull(.) %>% hist(.,breaks = input$bins,
                                                              col = input$color, 
                                                              border = input$borde, 
                                                              main = paste("Histograma de ", input$var))
    } else{
      
      datos %>% dplyr::select(input$var) %>% table(.) %>% barplot(., col = input$color, 
                                                                  border = input$borde, 
                                                                  main = paste("Histograma de ", input$var))
    }
  })
  output$grafico_ui <- renderUI({
    plotOutput("grafico", width = "100%", height = input$Size)
  })
}
