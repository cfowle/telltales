library(shiny)
library(readr)
library(ggplot2)
library(dplyr)
library(magrittr)
library(stringr)
library(lubridate)
library(DT)

setwd("~/code/telltales")
data = read_csv("./source/clean_results_new.csv")
data %<>% mutate(month = str_extract(date,"[a-zA-Z]*"),
              day = str_extract(date,"\\d{1,2}"),
              year = str_extract(date,"\\d{4}")) %>%
          mutate(clean_date = mdy(paste(month, day, ",", year))) %>%
          filter(!is.na(clean_date))

classes = unique(data$class)

ui <- fluidPage(
  tags$head(
    tags$link(href="https://fonts.googleapis.com/css?family=Raleway|Staatliches", rel="stylesheet")
  ),
  titlePanel("Sailing Stats"),
  fluidRow(span(class = "element",column(3,
              dateRangeInput("period", label = h4("Period"), start= "2017-01-01", end = "2018-01-01"),
              selectInput("unit", label = h4("Unit"), choices = c("regattas", "entrants")))),
           span(class = "element", column(6,
              plotOutput("plot"))),
           span(class = "element", column(3,
              checkboxGroupInput("checkGroup", label = h4("Classes"), 
                                 choices = classes,
                                 selected = classes)))
  ),
  br(),
  fluidRow(column(6, 
                  h4("Most Active Teams"),
                  DT::dataTableOutput("active_teams")),
           column(6, 
                  h4("Best Performing Teams"),
                  DT::dataTableOutput("best_teams")))
)


server <- function(input, output) {
  data %<>%
    group_by(class, regatta, clean_date) %>%
    summarise(unit = n())
  
  grouped = reactive({
    period = input$period
    unit = input$unit
    classes = input$checkGroup
    
    updated = data
    if(unit == "regattas") {
      updated %<>%
        ungroup() %>%
        group_by(class, clean_date) %>%
        summarise(unit = n())
    }
    
    updated %>%
      filter(class %in% classes) %>%
      filter(clean_date <= period[2] & clean_date >= period[1]) %>%
      group_by(class) %>%
      summarise(unit = sum(unit))
  })
  
  output$plot = renderPlot({
    dd = grouped()
    unit = input$unit
    
    ggplot(dd, aes(x=class, y = unit)) +
      geom_bar(stat = "identity") +
      labs(y=unit)
  })
  
}

shinyApp(ui=ui, server=server)
