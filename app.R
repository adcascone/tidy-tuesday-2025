# install.packages("shiny")
library(shiny)
library(ggplot2)
library(dplyr)

tuesdata <- tidytuesdayR::tt_load('2025-01-28')
water_insecurity_2022 <- tuesdata$water_insecurity_2022
water_insecurity_2023 <- tuesdata$water_insecurity_2023

water <- rbind(water_insecurity_2022, water_insecurity_2023)

water$state <- 
  (do.call('rbind', 
          strsplit(as.character(water$name),', ',
                   fixed=TRUE))[,2])
water$county <- 
  (do.call('rbind', 
           strsplit(as.character(water$name),', ',
                    fixed=TRUE))[,1])

ui <- fluidPage(
  
  titlePanel("Water Insecurity 2022-2023"),
  # 
  # textInput( 
  #   "text", 
  #   "Text input", 
  #   placeholder = "Enter text..."
  # ),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "state",
                  label = "Select state:",
                  choices = c(sort(unique(water$state)))),
      
      selectInput(inputId = "year", 
                  label = "Select year of interest:", 
                  choices = c("2022", "2023", "Both")),
      
      submitButton(text = "Create Plot")),
    
    mainPanel(plotOutput(outputId = "plot"))))

server <- function(input, output) {
  
  selectData = reactive({
    # 
    # if (input$year == "" || input$state == "") {
    #   return(NULL)
    # }
    # 
    water_subset <- water %>% filter(state == input$state)
    
    if (input$year == "2022") {water_subset <- water_subset %>% filter(year == "2022")}
    if (input$year == "2023") {water_subset <- water_subset %>% filter(year == "2023")}
    if (input$year == "Both") {water_subset <- water_subset}
    water_subset
  })
  
  
  output$plot <- renderPlot({
    
    print(ggplot(selectData(), aes(x=total_pop, 
                                   y=percent_lacking_plumbing))+
            #geom_bar(stat = "identity", position = position_dodge())+
            geom_point(size = 4, alpha = 0.8)+
            facet_grid(~as.character(year))+
            #facet_grid(~county)+
            ylab ("% Lacking Plumbing")+
            xlab ("Total Population"))+
      theme_classic(base_size = 22) +
      scale_x_continuous(
        labels = scales::comma
      )
    
    })
  
}

shinyApp(ui = ui, server = server)

