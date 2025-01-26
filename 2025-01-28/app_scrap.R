## app scrap code

# # Define UI for miles per gallon app ----
# ui <- fluidPage(
#   
#   # App title ----
#   titlePanel("Water Security"),
#   
#   # Sidebar layout with input and output definitions --- 
#   
#   sidebarLayout(
#     # Sidebar panel for inputs ----
#     sidebarPanel(
#       
#       # Input: Selector for states ----
#       selectInput("state","State",
#                   c(unique(water_insecurity_2022$state))),
#       
#       # Input: Check box for whether outliers should be included ----
#       checkboxInput("outliers", "Show outliers", TRUE),
#       
#       # Input: Slider for number of bins ---
#       sliderInput(inputId = "bins",
#                   label = "Number of bins:",
#                   min = 1,
#                   max = 50,
#                   value = 30)
#       
#     ),
#     
#     # Main panel for displaying outputs ----
#     mainPanel(
#       # Output: Formatted text for caption ----
#       h3(textOutput("caption")),
#       
#       # Output: Histogram ----
#       plotOutput(outputId = "waterPlot")
#       
#     )
#   )
#  
# )
# 
# 
# # Define server logic to plot ----
# server <- function(input, output, session) {
#   
#   # Compute the formula text ----
#   # This is in a reactive expression since it is shared by the
#   # output$caption and output$water_insecurity_2022 functions
#   formulaText <- reactive({
#     paste(input$variable)
#   })
#   
#   # Return the formula text for printing as a caption ----
#   output$caption <- renderText({
#     formulaText()
#   })
#   
#   # Histogram ----
#   # with requested number of bins
#   # This expression that generates a histogram is wrapped in a call
#   # to renderPlot to indicate that:
#   #
#   # 1. It is "reactive" and therefore should be automatically
#   #    re-executed when inputs (input$bins) change
#   # 2. Its output type is a plot
#   output$waterPlot <- renderPlot({
#     
#     updateSelectInput(session, "variable",
#                       choices = (water_insecurity_2022$state),
#                       selected = input$variable) 
#     
#     ggplot(water_insecurity_2022, aes(percent_lacking_plumbing)) + 
#       geom_bar(fill = "yellow", color = "black") +
#       labs(
#         x = "Percent Lacking Plumbing (%)",
#         y = "frequency"
#       )
#     
#   })
#   
# }
# 
# shinyApp(ui, server)