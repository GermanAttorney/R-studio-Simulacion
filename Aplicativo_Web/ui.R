#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)


fluidPage(
  tags$style("h1 {color:#9A9A9A ; font-size:35px}"),
  tags$style("h2 {color:#A569BD ; font-size:20px}"),
  fluidRow(column(width=3, tags$img(src="logo-epn-vertical.png",width="150px",height="150px")),
           column(width=9, h1("Aplicativo Simulacion"))),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Numbero de barras:",
                        min = 1,
                        max = 50,
                        value = 30),
            selectInput("color", "Seleccione el color para el grafico", 
                        choices= c("rojo claro"="#c0392b","azul claro"="#a9cce3","verde claro"="#7dcea0","naranja"="#f0b27a","morado"="#c39bd3","negro"="#17202a"
                                   ,"gris"="#b2babb","violeta"="#76448a","lila"="#d2b4de","turquesa"="#58d68d")),
            selectInput("borde", "Seleccione el color para el borde", c("negro"="#17202a","azul"="#21618c","vino tinto"="#943126","gris"="#839192")),
            radioButtons("tipo","Seleccione variable a analizar",
                         choiceNames=c("Cuantitativas","Cualitativvas"),
                         choiceValues=c("numeric","character"),
                         selected="numeric"),
            selectInput("var","Variable seleccionada",choices = tvar$Variable, selected =tvar$Variable[2]),
            selectInput("Size","Tamaño de la grafica:",choices = c("Grande"="500px","Mediano"="400px","Pequeño"="300px"), selected="Grande")
            )
,

        # Show a plot of the generated distribution
        mainPanel(
            h2("Resumem:"),
            verbatimTextOutput("resumen"),
            h2("Grafico:"),
            uiOutput("grafico_ui")
        )
    )
)

