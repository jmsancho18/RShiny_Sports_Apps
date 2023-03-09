library(shiny)
library(readxl)
library(reactable)
library(tidyverse)
library(htmltools)

#read data
shiny_data <- read_excel("C:/Users/josef/OneDrive/Desktop/Rshiny Paper/Data.xlsx", sheet = 1, col_names = TRUE)

html <- function(x, inline = FALSE) {
  container <- if (inline) htmltools::span else htmltools::div
  container(dangerouslySetInnerHTML = list("__html" = x))
}


ui <- fluidPage(
  
  #theming   
  theme = shinythemes::shinytheme("flatly"),
  
  tags$head(tags$style("#modal1 .modal-body {background-color: white; padding: 10px}
                       #modal1 .modal-content  {-webkit-border-radius: 6px !important;-moz-border-radius: 6px !important;border-radius: 6px !important;}
                       #modal1 .modal-dialog { width: 880px; display: inline-block; text-align: left; vertical-align: top;}
                       #modal1 .modal-header {background-color: #404764; border-top-left-radius: 6px; border-top-right-radius: 6px}
                       #modal1 .modal { text-align: center; padding-right:0px; padding-top: 24px;}
                       #moda1 .close { font-size: 16px}")),
  
  
  br(),  
  
  #sidebar
  sidebarLayout(
    fluid = T,
    
    
    
    sidebarPanel(width = 2, style = "position:fixed;width: 15%",
                 
                 #top buttons
                 actionButton("info", "Info", icon = icon("info-circle"), style = "border-color: darkgray; color: black"),
                 
                 br(),
                 br(),
                 
                 downloadButton('downloadData', 'Download', style = "border-color: darkgray; color: black")
                 
                 
    ),

  mainPanel(
    reactableOutput("shiny_table")
  )
)
)

server <- function(input, output) {
  
  #info modal
  observeEvent(input$info, {
    
    showModal(tags$div(id="modal1", modalDialog(
      inputId = 'Dialog1', 
      title = HTML('<span style="color:white; font-size: 20px; font-weight:bold; font-family:sans-serif ">About the paper....<span>
                   <button type = "button" class="close" data-dismiss="modal" ">
                   <span style="color:white; ">x <span>
                   </button> '),
      
      tags$a("link to paper and description"),
      
      easyClose = TRUE,
      footer = NULL )))
    
  })
  
  
  #Code to download button
  output$downloadData <- downloadHandler(
    
    
    filename = function() {
      paste('data-', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      write.csv(shiny_data, con)
    }
  )
  
  
  
  
  output$shiny_table <- renderReactable({
    
    reactable(shiny_data,
              
              columns = list(
                Description = colDef(
                  sticky = "left",
                  # Add a right border style to visually distinguish the sticky column
                  style = list(borderRight = "1px solid #eee"),
                  headerStyle = list(borderRight = "1px solid #eee"),
                  minWidth = 550
                )),
              
              
              defaultPageSize = 100,
              sortable = TRUE,
              highlight = TRUE,
              striped = TRUE,
              bordered = TRUE,
              compact = TRUE,
              showSortable = TRUE,
              filterable = TRUE,
              resizable = TRUE,
              wrap = FALSE,
              
              theme = reactableTheme(cellStyle = list(display = "flex", flexDirection = "column", justifyContent = "center"))
              
              
              )
    
  })
}

shinyApp(ui = ui, server = server)


