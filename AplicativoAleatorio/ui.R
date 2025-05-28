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

    # Application title
    titlePanel("Generacion de numeros aleatorios - Metodo congruencial (xk= xk-1 * a mod(m))"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            numericInput("semilla",
                        "Valor inicial:",
                        min = 1,
                        max = 10000,
                        value = 20),
            numericInput("num",
                        "Valor de n:",
                        min = 1,
                        max = 200,
                        value = 30),
            numericInput("modulo",
                        "Valor de m",
                        min = 1,
                        max = 100,
                        value = 21),
            numericInput("constante",
                        "Valor de a",
                        min = 1,
                        max = 100,
                        value = 13),
            numericInput("columnas",
                         "Columnas:",
                         min = 1,
                         max = 100,
                         value = 10),
        ),

        # Show a plot of the generated distribution
        mainPanel(
          
            tableOutput("tabla1")
        )
        
        )
    )


