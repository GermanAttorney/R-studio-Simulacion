#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(kableExtra)
library(data.table)


random_cong <- function(a,m,x0,n,decimales=6){
  res <- numeric(n+1)
  res[1] <- x0
  for(k in 1:(length(res)-1)){
    res[k+1]<- ((a*res[k]) %% m)
  }
  return(round(res/m,decimales))
}

conv_matrix <- function(vector,cols=10){
  res<-rep(NA_real_,ceiling(length(vector)/cols)*cols)
  res[1:length(vector)]<-vector
  res <- as.data.frame(matrix(res,nrow=ceiling(length(vector)/cols),ncol=cols,byrow=TRUE))
  colnames(res) <- paste0("Col ",1:cols)
    
  return(res)
}

conv_matrix(c(1,2,3,4,5,6,7,8,9,10),cols=4)

# Define server logic required to draw a histogram
function(input, output, session) {

  output$tabla1 <- function(){
    vector <- conv_matrix(random_cong(a=input$constante,m=input$modulo,x0=input$semilla,n=input$num-1),cols=input$columnas)
    
    kbl(vector, booktabs=TRUE, escape=FALSE) %>% 
      kable_styling(full_width = FALSE, bootstrap_options = c("bordered"),font_size = 12) %>%
      row_spec(0,background = "#1D3889",color="#FFFFFF") %>%
      scroll_box(height = "100%",width="800px")
  }
}
