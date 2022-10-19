# Load packages ----------------------------------------------------------------

library(shiny)
library(ggplot2)
library(tools)
library(shinythemes)

# Load data --------------------------------------------------------------------

load("movies.RData")

# Define UI --------------------------------------------------------------------

ui <- fluidPage(theme = shinytheme("united"),
                sidebarLayout(
                  sidebarPanel(
                    selectInput(
                      inputId = "y",
                      label = "Y-axis:",
                      choices = c(
                        "IMDB rating" = "imdb_rating",
                        "IMDB number of votes" = "imdb_num_votes",
                        "Critics Score" = "critics_score",
                        "Audience Score" = "audience_score",
                        "Runtime" = "runtime"
                      ),
                      selected = "audience_score"
                    ),
                    
                    selectInput(
                      inputId = "x",
                      label = "X-axis:",
                      choices = c(
                        "IMDB rating" = "imdb_rating",
                        "IMDB number of votes" = "imdb_num_votes",
                        "Critics Score" = "critics_score",
                        "Audience Score" = "audience_score",
                        "Runtime" = "runtime"
                      ),
                      selected = "critics_score"
                    ),
                    
                    selectInput(
                      inputId = "z",
                      label = "Color by:",
                      choices = c(
                        "Title Type" = "title_type",
                        "Genre" = "genre",
                        "MPAA Rating" = "mpaa_rating",
                        "Critics Rating" = "critics_rating",
                        "Audience Rating" = "audience_rating"
                      ),
                      selected = "mpaa_rating"
                    ),
                    
                    sliderInput(
                      inputId = "alpha",
                      label = "Alpha:",
                      min = 0, max = 1,
                      value = 0.5
                    ),
                    
                    sliderInput(
                      inputId = "size",
                      label = "Size:",
                      min = 0, max = 5,
                      value = 2
                    ),
                    
                    textInput(
                      inputId = "plot_title",
                      label = "Plot title",
                      placeholder = "Enter text to be used as plot title"
                    ),
                    
                    actionButton(
                      inputId = "update_plot_title",
                      label = "Update plot title"
                    )
                  ),
                  
                  mainPanel(
                    tags$br(),
                    tags$p(
                      "These data were obtained from",
                      tags$a("IMBD", href = "http://www.imbd.com/"), "and",
                      tags$a("Rotten Tomatoes", href = "https://www.rottentomatoes.com/"), "."
                    ),
                    tags$p("The data represent", nrow(movies), "randomly sampled movies released between 1972 to 2014 in the United States."),
                    
                    plotOutput(outputId = "scatterplot")
                  )
                )
)

# Define server ----------------------------------------------------------------

server <- function(input, output, session) {
  new_plot_title <- eventReactive(
    eventExpr = input$update_plot_title,
    valueExpr = {
      toTitleCase(input$plot_title)
    }
  )
  
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y, color = input$z)) +
      geom_point(alpha = input$alpha, size = input$size) +
      labs(title = new_plot_title())
  })
}

# Create the Shiny app object --------------------------------------------------

shinyApp(ui = ui, server = server)