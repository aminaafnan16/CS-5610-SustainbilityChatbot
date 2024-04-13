library(shiny)
library(shinyjs)
library(shinydashboard)
library(shinyWidgets)


# Define UI
ui <- fluidPage(
  
  tags$head(
    # Import Google Fonts
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap"),
    # Custom CSS
    tags$style(HTML("
          body {
        font-family: 'Roboto', sans-serif;
        background-color: #2f583c;
        padding: 20px;
      }
    

      .container {
        max-width: 800px;
        margin: 0 auto;
      }
      .card {
        background-color: #ffffff;
        border-radius: 20px;
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        padding: 40px;
        margin: 20px 0;
        transition: transform 0.3s;
      }
      .card:hover {
        transform: translateY(-10px);
      }
      .card h3 {
        margin-top: 0;
        font-weight: bold;
        color: #333333;
      }
      .action-btn {
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 20px;
        padding: 10px 20px;
        font-size: 18px;
        cursor: pointer;
        transition: background-color 0.3s;
      }
      .action-btn:hover {
        background-color: #45a049;
      }
      .title-panel {
        text-align: center;
        margin-bottom: 20px;
        font-size: 48px;
        font-weight: bold;
        color: white;
        text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3);
        font-family: 'Dancing Script', cursive;
        
      }
      .header-img {
        width: 100%;
        margin-bottom: 20px;
      }
    "))
  ),

  div(class = "title-panel",
      h1("Welcome to Your Dream House"),# Added class attribute
      h2("Your Dream House is in Your Hands")
  ),
  
  # Sign-in and sign-up cards
  div(class = "container",
      div(class = "card",
          h3("Sign In"),
          p("Already have an account? Log in to access your dream house!"),
          actionButton("signInBtn", "Sign In", class = "action-btn")
      ),
      div(class = "card",
          h3("Sign Up"),
          p("Don't have an account yet? Sign up now and start your journey!"),
          actionButton("signUpBtn", "Sign Up", class = "action-btn")
      )
  ),
  
  # Include shinyjs library
  useShinyjs()
)