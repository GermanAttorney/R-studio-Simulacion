#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(kableExtra)
# Define UI for application that draws a histogram
fluidPage(
  tags$style("h1 {color:#000000 ; font-size:35px}"),
  tags$style("h2 {color:#A569BD ; font-size:20px}"),
  fluidRow(column(width=3, tags$img(src="EPN.png",width="150px",height="180px")),
           column(width=9, h1("Aplicativo: Integrales con numeros aleatorios"))
           ),
  actionButton("calcular","Calcular", style="color:#000000 ; background-color: #f0ac7e"),
  
    tabsetPanel(
      tabPanel("Configuraciones graficos",
               sidebarPanel(
                 selectInput("color", "Seleccione el color para la linea de aproximacion:", 
                             choices= c("rojo claro"="#c0392b","azul claro"="#a9cce3","verde claro"="#7dcea0","naranja"="#f0b27a","morado"="#c39bd3","negro"="#17202a"
                                        ,"gris"="#b2babb","violeta"="#76448a","lila"="#d2b4de","turquesa"="#58d68d")),
               selectInput("color2", "Seleccione el color para la linea de valor teorico:", 
                           choices= c("rojo claro"="#c0392b","azul claro"="#a9cce3","verde claro"="#7dcea0","naranja"="#f0b27a","morado"="#c39bd3","negro"="#17202a"
                                      ,"gris"="#b2babb","violeta"="#76448a","lila"="#d2b4de","turquesa"="#58d68d"),
                           selected="#17202a"),
               selectInput("color_area", "Seleccione el color para el area:", 
                           choices= c("rojo claro"="#c0392b","azul claro"="#a9cce3","verde claro"="#7dcea0","naranja"="#f0b27a","morado"="#c39bd3","negro"="#17202a"
                                      ,"gris"="#b2babb","violeta"="#76448a","lila"="#d2b4de","turquesa"="#58d68d"),
                           selected="#a9cce3"),
               selectInput("color_limites", "Seleccione el color para limites de area:", 
                           choices= c("rojo claro"="#c0392b","azul claro"="#a9cce3","verde claro"="#7dcea0","naranja"="#f0b27a","morado"="#c39bd3","negro"="#17202a"
                                      ,"gris"="#b2babb","violeta"="#76448a","lila"="#d2b4de","turquesa"="#58d68d"),
                           selected="#f0b27a"
                           ),
               selectInput("color_func", "Seleccione el color para la funcion:", 
                           choices= c("rojo claro"="#c0392b","azul claro"="#a9cce3","verde claro"="#7dcea0","naranja"="#f0b27a","morado"="#c39bd3","negro"="#17202a"
                                      ,"gris"="#b2babb","violeta"="#76448a","lila"="#d2b4de","turquesa"="#58d68d"),
                           selected="#17202a"
                             )
               )
      ),
      tabPanel("Ajustes de funcion e integral",
               sidebarPanel(
                 numericInput("k",
                              "Aproximacion:",
                              min = 1,
                              max = 1000000,
                              value = 1000),
                 numericInput("a",
                              "Valor inferior de la integral:",
                              min = -10000,
                              max = 10000,
                              value = 0),
                 numericInput("b",
                              "Valor superior de la integral:",
                              min = -10000,
                              max = 10000,
                              value = 1),
                 textInput("func_text", "Ingresa la función f(x):", "sqrt(1-x^2)")
                 
               )
      ),
      tabPanel("Ajustes numeros aleatorios:",
               
        sidebarPanel(
        numericInput("n",
                       "Cantidad de numeros aleatorios:",
                       min = 1,
                       max = 1000000,
                       value = 1000),
        numericInput("semilla",
                     "Semilla:",
                     min = 1,
                     max = 10000,
                     value = 20),
        numericInput("modulo",
                     "Valor de m",
                     min = 1,
                     max = 1000000,
                     value = 18234),
        numericInput("constante",
                     "Valor de a",
                     min = 1,
                     max = 10000,
                     value = 5245 ),
        numericInput("c",
                     "Valor de c",
                     min = 1,
                     max = 10000000,
                     value = 12345
                     ),
        numericInput("columnas",
                     "Columnas:",
                     min = 1,
                     max = 10000,
                     value = 100),
        selectInput("Modelo",
                    "Modelo congruencial",
                    choices = c("Simple"=1,"Mixto"=2),
                    selected = "Simple")
        )
      )
      ),
      mainPanel("Informe de resultados",
                tabsetPanel(
                  tabPanel("Generacion numeros aleatorios:",
                           "Generacion de numeros aleatorios: ",
                           textOutput("metodo_text"),
                           uiOutput("tabla_aleatorio")
                           #Tabla de numeros aleatorios:
                           ),
                  tabPanel(textOutput("titul_fun"),
                           plotOutput("grafico_area"),
                           textOutput("Valor_teorico"),
                           textOutput("resultado_integral"),
                           textOutput("resultado_error"),
                           "Grafico de la aproximacion de la integral de la funcion por numero de iteraciones:",
                           plotOutput("grafico_convergencia")                               
                           )
                  
                )


            
        )
      )
               

    
