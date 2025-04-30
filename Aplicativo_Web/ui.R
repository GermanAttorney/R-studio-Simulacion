#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  tags$style("h1 {color:#9A9A9A ; font-size:35px}"),
  tags$style("h2 {color:#A569BD ; font-size:20px}"),
  fluidRow(column(width=3, tags$img(src="images.jpg",width="200px",height="150")),
           column(width=9, h1("Aplicativo Simulacion"))),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Numbero de barras:",
                        min = 1,
                        max = 50,
                        value = 30),
            selectInput("color", "Seleccione el color para el grafico", c("red","blue","green","orange","brown","black","white","gray")),
            selectInput("borde", "Seleccione el color para el borde", c("red","blue","green","orange","brown","black","white","gray","purple")),
            radioButtons("tipo","Seleccione variable a analizar",
                         choiceNames=c("Cuantitativas","Cualitativvas"),
                         choiceValues=c("numeric","character"),
                         selected="numeric"),
            selectInput("var","Variable seleccionada",choices = tvar$Variable, selected =tvar$Variable[2])
            
            )
,

        # Show a plot of the generated distribution
        mainPanel(
            h2("Resumem:"),
            verbatimTextOutput("resumen"),
            h2("Grafico:"),
            plotOutput("grafico")
        )
    )
)

