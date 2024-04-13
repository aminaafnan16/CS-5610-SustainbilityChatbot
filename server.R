library(shiny)
library(shinyjs)
library(shinydashboard)
library(shinyWidgets)
con <- dbConnect(RSQLite::SQLite(), "C:/Users/ranas/Downloads/sustainable_shiny/shiny_data")
# Define server logic
server <- function(input, output, session) {
  observeEvent(input$signInBtn, {
    showModal(modalDialog(
      id = "signInModal", title = "Sign In",
      textInput("email", "Email:"),
      passwordInput("password", "Password:"),
      actionButton("loginBtn", "Log In")
    ))
  })
  
  observeEvent(input$submitBtn, {
    # Get the input values
    fullname <- input$fullname
    email <- input$email_signup
    phone_number <-input$phone
    password <- input$password_signup
    postalcode <- input$postalcode
    
    # Insert the input values into the database
    dbExecute(con, 
              "INSERT INTO shiny (fullname, email_signup, password_signup, postalcode,phone_number) VALUES (?, ?, ?, ?, ?)",
              params = list(fullname, email, password, postalcode,phone_number))
    
    # Show a message confirming sign-up
    showModal(modalDialog(
      title = "Sign Up Successful",
      "Congratulations! You have successfully signed up.",
      footer = tagList(
        actionButton("closeBtn", "Close", icon("times-circle"), class = "btn-danger")
      )
    ))
    
    
    # Clear the sign-up form inputs
    updateTextInput(session, "fullname", value = "")
    updateTextInput(session, "email_signup", value = "")
    updateTextInput(session,"phone",value="")
    updateTextInput(session, "password_signup", value = "")
    updateTextInput(session, "postalcode", value = "")
  })
  observeEvent(input$closeBtn, {
    removeModal()
  })
  
  observeEvent(input$loginBtn, {
    # Get the entered email and password
    entered_email <- input$email
    entered_password <- input$password
    
    # Query the database to check if the user exists
    result <- dbGetQuery(con, paste0("SELECT COUNT(*) FROM shiny WHERE email_signup = '", entered_email, "' AND password_signup = '", entered_password, "'"))
    
    # Check if the result indicates a match
    if (result == 1) {
      # Redirect the user using JavaScript
      showModal(
        tags$script(
          HTML(
            paste0(
              "window.location.href = 'http://localhost:8501';"
            )
          )
        )
      )
    } else {
      # Show a message indicating the need to sign up
      showModal(modalDialog(
        title = "Sign In Failed",
        "Incorrect email or password. Please sign up or try again.",
        footer = tagList(
          actionButton("closeBtn", "Close", icon("times-circle"), class = "btn-danger")
        )
      ))
    }
  })
  
  
  
  observeEvent(input$signUpBtn, {
    showModal(modalDialog(
      id = "signUpModal", title = "Sign Up",
      textInput("fullname", "Full Name:",placeholder = "Write full Name"),
      textInput("email_signup", "Email:",placeholder = "Write Valid Email"),
      textInput("phone", "Phone Number:",placeholder = "Phone number should be of 10 Characters"),
      passwordInput("password_signup", "Password:",placeholder = "Choose Strong Password"),
      textInput("postalcode", "Postal Code:",placeholder = "Write Your Postal Code (e.g. 49009)"),
      actionButton("submitBtn", "Submit")
    ))
  })
  
}