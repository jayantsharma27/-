library(shiny)
library(randomForest)
library(DT)
library(plotly)
library(httr)
library(shinyjs)

# Replace these with your actual credentials
google_client_id <- "40167441734-1tv6m3k00r1htgj157gafp68dduv0flu.apps.googleusercontent.com"
google_client_secret <- "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"

# Define the OAuth scopes
scopes <- c("https://www.googleapis.com/auth/userinfo.profile",
            "https://www.googleapis.com/auth/userinfo.email")

ui <- fluidPage(
  useShinyjs(),  # Enable shinyjs
  uiOutput("ui_main")  # Dynamically generate UI content based on login status
)

server <- function(input, output, session) {
  
  # Reactive value to track login status
  user_logged_in <- reactiveVal(FALSE)
  user_info_data <- reactiveVal(NULL)
  
  # Handle login button click
  observeEvent(input$login_btn, {
    req(input$login_btn)
    
    # Initiate OAuth 2.0 authentication
    oauth_endpoints("google")
    myapp <- oauth_app("google", key = google_client_id, secret = google_client_secret)
    goog_auth <- oauth2.0_token(oauth_endpoints("google"), myapp, scope = scopes, cache = FALSE)
    
    # Get user information after successful login
    user_info <- GET("https://www.googleapis.com/oauth2/v2/userinfo", config(token = goog_auth))
    user_info_data <- content(user_info)
    
    # Set login status to TRUE
    user_logged_in(TRUE)
    user_info_data(user_info_data)
    
    # Update UI with the user's information after login
    output$user_info <- renderText({
      paste("Hello,", user_info_data()$name)
    })
    
    # Update login status message
    output$login_status <- renderText({
      "You are logged in successfully!"
    })
    
    # Switch to main app UI after login
    updateNavbarPage(session, "Patient Sentiment Analysis", selected = "Home")
  })
  # Handle logout button click
  observeEvent(input$logout_btn, {
    # Reset login status and user information
    user_logged_in(FALSE)
    user_info_data(NULL)
    
    # Display a message to confirm logout
    showModal(modalDialog(
      title = "Logout Successful",
      "You have been logged out successfully!",
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Dynamically generate UI based on login status
  output$ui_main <- renderUI({
    if (!user_logged_in()) {
      # Display login page if not logged in
      return(
        fluidPage(
          tags$head(
            tags$link(rel = "icon", type = "image/x-icon", href = "https://cdn-icons-png.flaticon.com/128/12251/12251801.png")
          ),
          navbarPage(
            title = "Patient Sentiment Analysis",
            
            # Home tab
            tabPanel("Home",
                     div(class = "home-content",
                         h2(style = "text-align: center;","Welcome to आशयः"),
                         div(class = "hero-image",
                             img(src = "https://www.qminder.com/resources/img/generated/resources/img/blog/importance-patient-satisfaction-1024-de5f604b2.webp", height = "550px", width = "100%")
                         ),
                         div(class = "hero-text",
                             h2(style = "text-align: center;","आरोग्यं परमं भाग्यं स्वास्थ्यं सर्वार्थसाधनम्।"),
                             br(),
                             p("आशयः allows you to upload a dataset, train a predictive model, make predictions, and visualize the data in a variety of formats."),
                             p("आशयः  app is designed to provide an intuitive interface for data scientists, researchers, or anyone interested in machine learning models and data analysis in the healthcare sector."),
                             br()
                         )
                     )
            ),
            
            # Upload Dataset tab
            tabPanel("Upload Dataset",
                     tags$div(
                       style = "
                       position: relative;
                       background-image: url('https://www.qminder.com/resources/img/generated/resources/img/blog/importance-patient-satisfaction-1024-de5f604b2.webp');
                       background-size: cover;
                       background-position: center;
                       height: 100vh;
                       ",
                       
                       # Add black tint using inline CSS with an additional div
                       tags$div(
                         style = "
                         position: absolute;
                         top: 0;
                         left: 0;
                         right: 0;
                         bottom: 0;
                         background-color: rgba(0, 0, 0, 0.5); /* Black tint with 50% opacity */
                         "
                       ),
                       # Content inside the background image
                       tags$div(
                         style = "
        position: relative;
        text-align: center;
        color: white;
        padding-top: 20%;
      ",
                         
                         h2("Login to Access the App"),
                         img(src = "https://img.icons8.com/?size=80&id=112160&format=png", height = "40px", width = "40px", style = "margin-right: 10px;"),
                         actionButton("login_btn", " Login with Google ", icon = icon("google")),
                         br()
                       )
                     )
            ),
            
            # Prediction tab
            tabPanel("Prediction",
                     tags$div(
                       style = "
      position: relative;
      background-image: url('https://www.qminder.com/resources/img/generated/resources/img/blog/importance-patient-satisfaction-1024-de5f604b2.webp');
      background-size: cover;
      background-position: center;
      height: 100vh;
    ",
                       # Add black tint using inline CSS with an additional div
                       tags$div(
                         style = "
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: rgba(0, 0, 0, 0.5); /* Black tint with 50% opacity */
      "
                       ),
                       # Content inside the background image
                       tags$div(
                         style = "
        position: relative;
        text-align: center;
        color: white;
        padding-top: 20%;
      ",
                         
                         h2("Login to Access the App"),
                         img(src = "https://img.icons8.com/?size=80&id=112160&format=png", height = "40px", width = "40px", style = "margin-right: 10px;"),
                         actionButton("login_btn", " Login with Google ", icon = icon("google")),
                         br(),
                       )
                     )
            ),
            
            # 3D Visualization tab
            tabPanel("3D Visualization",
                     tags$div(
                       style = "
      position: relative;
      background-image: url('https://www.qminder.com/resources/img/generated/resources/img/blog/importance-patient-satisfaction-1024-de5f604b2.webp');
      background-size: cover;
      background-position: center;
      height: 100vh;
    ",
                       # Add black tint using inline CSS with an additional div
                       tags$div(
                         style = "
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: rgba(0, 0, 0, 0.5); /* Black tint with 50% opacity */
      "
                       ),
                       # Content inside the background image
                       tags$div(
                         style = "
        position: relative;
        text-align: center;
        color: white;
        padding-top: 20%;
      ",
                         
                         h2("Login to Access the App"),
                         img(src = "https://img.icons8.com/?size=80&id=112160&format=png", height = "40px", width = "40px", style = "margin-right: 10px;"),
                         actionButton("login_btn", " Login with Google ", icon = icon("google")),
                         br(),
                       )
                     )
            ),
            
            # Contact Us tab
            tabPanel("Contact Us & About Us",
                     p("For inquiries or support, please reach us at :"),
                     fluidRow(
                       # Developer 1 Card
                       column(6, 
                              div(class = "card",
                                  style = "width: 18rem; margin: 10px; border-radius: 10px;",
                                  img(src = "https://media.licdn.com/dms/image/v2/D4D03AQGzBFWoNeQJjA/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1721924531609?e=2147483647&v=beta&t=Vt1XEytNNia-Lgq4dW_uKAu1SrQvdrQp8XWWE0Gq2Lo", class = "card-img-top", height = "200px", width = "100%", style = "border-radius: 10px 10px 0 0;"),
                                  div(class = "card-body",
                                      h5(class = "card-title", "Jayant Sharma"),
                                      p(class = "card-text", "Developer"),
                                      p(class = "card-text", "Email: jayantsharma2703@gmail.com"),
                                      a(href = "mailto:jayantsharma2703@gmail.com", class = "btn btn-primary", "Contact Jayant")
                                  )
                              )
                       ),
                       
                       # Developer 2 Card
                       column(6, 
                              div(class = "card",
                                  style = "width: 18rem; margin: 10px; border-radius: 10px;",
                                  img(src = "https://media.licdn.com/dms/image/v2/D5603AQFLRPJSSgJ4NQ/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1715968437855?e=1741219200&v=beta&t=SoucwAjzozkz19jt7I2g93AiLcuDvPOFC9VEc2FPtkI", class = "card-img-top", height = "200px", width = "100%", style = "border-radius: 10px 10px 0 0;"),
                                  div(class = "card-body",
                                      h5(class = "card-title", "Harshita Ahuja"),
                                      p(class = "card-text", "Co-Developer"),
                                      p(class = "card-text", "Email: harshiahuja075@gmail.com"),
                                      a(href = "maito:harshiahuja075@gmail.com", class = "btn btn-primary", "Contact Harshita")
                                  )
                              )
                       )
                     )
                     
            )
          ),
          
          
          # Wrapper div for the entire page to add bottom padding
          tags$div(
            style = "padding-bottom: 70px;",  # Adjust the padding to match the footer height
            
            # Your main content goes here
            
            tags$footer(
              style = "
      background-color: black; 
      color: white; 
      padding: 20px 0; 
      text-align: center;
      position: fixed;
      bottom: 0;
      width: 100%;
      height: 60px;
      font-size: 14px;",
              
              tags$div(
                style = "display: flex; justify-content: center; align-items: center;",
                
                tags$div(
                  style = "margin-right: 15px;",
                  tags$img(src = "https://cdn-icons-png.flaticon.com/128/12251/12251801.png", 
                           width = "25px", height = "25px")
                ),
                tags$div(a(href = "https://www.linkedin.com/in/jayant-sharma-0536b0318?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app", target = "_blank",  img(src = "https://img.icons8.com/?size=48&id=xuvGCOXi8Wyg&format=png", height = "50px", width = "auto")), "आशयः  | © 2025 All Rights Reserved"
                )
              )
            )
          )
          
          
          )
      )
    } else {
      # Once logged in, show the full app UI with other tabs
      return(
        navbarPage(
          title = "Patient Sentiment Analysis",
          # Home tab
          tabPanel("Home",
                   div(class = "home-content",
                       h2(style = "text-align: center;","Welcome to आशयः"),
                       div(class = "hero-image",
                           img(src = "https://www.qminder.com/resources/img/generated/resources/img/blog/importance-patient-satisfaction-1024-de5f604b2.webp", height = "550px", width = "100%")
                       ),
                       div(class = "hero-text",
                           h2(style = "text-align: center;","आरोग्यं परमं भाग्यं स्वास्थ्यं सर्वार्थसाधनम्।"),
                           br(),
                           p("आशयः allows you to upload a dataset, train a predictive model, make predictions, and visualize the data in a variety of formats."),
                           p("आशयः  app is designed to provide an intuitive interface for data scientists, researchers, or anyone interested in machine learning models and data analysis in the healthcare sector."),
                           br()
                       )
                   )
                   
          ),
          
          # Upload Dataset tab
          tabPanel("Upload Dataset",
                   h3("Upload Dataset"),
                   fileInput("datafile", "Choose CSV File", accept = ".csv"),
                   hr(),
                   h4("Dataset Preview"),
                   DTOutput("dataPreview"),
                   hr(),
                   h4("Dataset Columns Overview"),
                   verbatimTextOutput("dataset_overview")
          ),
          
          # Prediction tab
          tabPanel("Prediction",
                   h3("Train Model and Make Predictions"),
                   uiOutput("targetvar_ui"),  # Dropdown for target variable
                   uiOutput("feature_inputs_ui"),  # Dynamic UI for feature inputs
                   actionButton("trainBtn", "Train Model and Predict"),
                   hr(),
                   h4("Prediction Output"),
                   verbatimTextOutput("prediction_output"),
                   hr(),
                   textInput("row_num", "Enter Row Number for Prediction", value = "1")
          ),
          
          # 3D Visualization tab
          tabPanel("3D Visualization",
                   h3("3D Visualization of Dataset"),
                   uiOutput("xaxis_ui"),  # Dynamic UI for X-axis
                   uiOutput("yaxis_ui"),  # Dynamic UI for Y-axis
                   uiOutput("zaxis_ui"),  # Dynamic UI for Z-axis
                   selectInput("vizType", "Select Visualization Type", 
                               choices = c("Scatter Plot" = "scatter3d", 
                                           "Mesh Plot" = "mesh3d")),
                   plotlyOutput("threeDplot")
          ),
          
          # Contact Us tab
          tabPanel("Contact Us & About Us",
                   p("For inquiries or support, please reach us at :"),
                   fluidRow(
                     # Developer 1 Card
                     column(6, 
                            div(class = "card",
                                style = "width: 18rem; margin: 10px; border-radius: 10px;",
                                img(src = "https://media.licdn.com/dms/image/v2/D4D03AQGzBFWoNeQJjA/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1721924531609?e=2147483647&v=beta&t=Vt1XEytNNia-Lgq4dW_uKAu1SrQvdrQp8XWWE0Gq2Lo", class = "card-img-top", height = "200px", width = "100%", style = "border-radius: 10px 10px 0 0;"),
                                div(class = "card-body",
                                    h5(class = "card-title", "Jayant Sharma"),
                                    p(class = "card-text", "Developer"),
                                    p(class = "card-text", "Email: jayantsharma2703@gmail.com"),
                                    a(href = "mailto:jayantsharma2703@gmail.com", class = "btn btn-primary", "Contact Jayant")
                                )
                            )
                     ),
                     
                     # Developer 2 Card
                     column(6, 
                            div(class = "card",
                                style = "width: 18rem; margin: 10px; border-radius: 10px;",
                                img(src = "https://media.licdn.com/dms/image/v2/D5603AQFLRPJSSgJ4NQ/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1715968437855?e=1741219200&v=beta&t=SoucwAjzozkz19jt7I2g93AiLcuDvPOFC9VEc2FPtkI", class = "card-img-top", height = "200px", width = "100%", style = "border-radius: 10px 10px 0 0;"),
                                div(class = "card-body",
                                    h5(class = "card-title", "Harshita Ahuja"),
                                    p(class = "card-text", "Co-Developer"),
                                    p(class = "card-text", "Email: harshiahuja075@gmail.com"),
                                    a(href = "maito:harshiahuja075@gmail.com", class = "btn btn-primary", "Contact Harshita")
                                )
                            )
                     )
                   )
                   
          
                  
          ),header = tagList(
            actionButton("logout_btn", "Logout", class = "btn btn-danger", style = "float:right; margin-right: 20px;")
          ),
          tags$div(
            style = "padding-bottom: 70px;",  # Adjust the padding to match the footer height
            
            # Your main content goes here
            
            tags$footer(
              style = "
      background-color: black; 
      color: white; 
      padding: 20px 0; 
      text-align: center;
      position: fixed;
      bottom: 0;
      width: 100%;
      height: 60px;
      font-size: 14px;",
              
              tags$div(
                style = "display: flex; justify-content: center; align-items: center;",
                
                tags$div(
                  style = "margin-right: 15px;",
                  tags$img(src = "https://cdn-icons-png.flaticon.com/128/12251/12251801.png", 
                           width = "25px", height = "25px")
                ),
                tags$div(a(href = "https://www.linkedin.com/in/jayant-sharma-0536b0318?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app", target = "_blank",  img(src = "https://img.icons8.com/?size=48&id=xuvGCOXi8Wyg&format=png", height = "50px", width = "auto")), "आशयः  | © 2025 All Rights Reserved"
                )
              )
            )
          )
        )
      )
    }
  })
  
  # Reactive value to store the uploaded data
  dataset <- reactiveVal()
  
  # Watch for file upload and load the data
  observeEvent(input$datafile, {
    req(input$datafile)
    data <- read.csv(input$datafile$datapath)
    
    # Convert categorical variables to factors (if applicable)
    data$Gender <- as.factor(data$Gender)
    data$Emotion <- as.factor(data$Emotion)
    
    # Optionally, extract features from the Visit_Date
    data$Visit_Date <- as.Date(data$Visit_Date, format = "%d-%m-%Y")
    data$Year <- format(data$Visit_Date, "%Y")
    data$Month <- format(data$Visit_Date, "%m")
    
    # Remove 'Patient_ID' and 'Name' columns if present
    data <- data[, !(names(data) %in% c("Patient_ID", "Name"))]
    
    dataset(data)
    
    # Show the dataset preview using DT for interactivity
    output$dataPreview <- renderDT({
      req(dataset())
      datatable(dataset(), options = list(pageLength = 10))  # Paginated with 10 rows per page
    })
    
    # Dataset overview (summary)
    output$dataset_overview <- renderPrint({
      summary(dataset())
    })
    
    # Dynamically generate the target variable selection
    output$targetvar_ui <- renderUI({
      req(dataset())
      
      target_choices <- setdiff(names(dataset()), "Visit_Date")
      selectInput("targetVar", "Select Target Variable", choices = target_choices)
    })
    
    # Dynamically create feature inputs for prediction
    output$feature_inputs_ui <- renderUI({
      req(dataset(), input$targetVar)
      features <- setdiff(names(dataset()), c(input$targetVar, "Visit_Date"))
      feature_inputs <- lapply(features, function(feature) {
        if (is.numeric(dataset()[[feature]])) {
          numericInput(inputId = feature, 
                       label = paste("Set value for", feature),
                       value = 0)
        } else {
          selectInput(inputId = feature, 
                      label = paste("Set value for", feature),
                      choices = levels(dataset()[[feature]]),
                      selected = levels(dataset()[[feature]])[1])
        }
      })
      do.call(tagList, feature_inputs)
    })
    
    # Dynamically create UI for X, Y, and Z axes for 3D plot
    output$xaxis_ui <- renderUI({
      req(dataset())
      numeric_features <- names(dataset())[sapply(dataset(), is.numeric)]
      selectInput("xaxis", "Select X-Axis", choices = numeric_features)
    })
    
    output$yaxis_ui <- renderUI({
      req(dataset())
      numeric_features <- names(dataset())[sapply(dataset(), is.numeric)]
      selectInput("yaxis", "Select Y-Axis", choices = numeric_features)
    })
    
    output$zaxis_ui <- renderUI({
      req(dataset())
      numeric_features <- names(dataset())[sapply(dataset(), is.numeric)]
      selectInput("zaxis", "Select Z-Axis", choices = numeric_features)
    })
  })
  
  # Train model and make predictions
  observeEvent(input$trainBtn, {
    req(dataset(), input$targetVar)
    
    data <- dataset()
    target <- input$targetVar
    
    numeric_data <- data[, sapply(data, is.numeric)]
    
    if (!(target %in% names(numeric_data))) {
      showModal(modalDialog(
        title = "Error",
        "Target variable must be numeric for prediction!",
        easyClose = TRUE,
        footer = NULL
      ))
      return()
    }
    
    rf_model <- randomForest(as.formula(paste(target, "~ .")), data = data)
    
    output$prediction_output <- renderPrint({
      pred <- predict(rf_model, newdata = data[as.numeric(input$row_num), , drop = FALSE])
      print(pred)
    })
  })
  
  # Render 3D Plot using Plotly
  output$threeDplot <- renderPlotly({
    req(dataset(), input$xaxis, input$yaxis, input$zaxis)
    
    plot_data <- dataset()[, c(input$xaxis, input$yaxis, input$zaxis)]
    plot_ly(data = plot_data, x = ~get(input$xaxis), y = ~get(input$yaxis), z = ~get(input$zaxis),
            type = input$vizType) %>%
      layout(scene = list(xaxis = list(title = input$xaxis),
                          yaxis = list(title = input$yaxis),
                          zaxis = list(title = input$zaxis)))
  })
}

# Run the application
shinyApp(ui = ui, server = server)
