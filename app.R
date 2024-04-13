library(shiny)

# Specify the path to the directory containing the Shiny app files
ui_source <- source("C:/Users/ranas/Downloads/app/sustainable_shiny/ui.R")
server_source <- source("C:/Users/ranas/Downloads/app/sustainable_shiny/server.R")

# Extract UI and server from the sourced files
ui <- ui_source$value
server <- server_source$value

# Run the Shiny application
shinyApp(ui, server)

