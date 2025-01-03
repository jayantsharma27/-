# -आशयः (Patient Sentiment Analysis)
आशयः is a Shiny-based web application for patient sentiment analysis. It provides tools for dataset upload, machine learning model training, prediction, and data visualization. The app features Google OAuth for user authentication, ensuring secure access.

Features
Google Login Integration: Secure user authentication via Google OAuth.
Dataset Upload: Upload and preview datasets in CSV format.
Data Visualization: Interactive data exploration and 3D visualization using plotly.
Model Training: Train predictive models using randomForest.
Prediction: Make predictions based on user input or existing data.
Interactive UI: Built with Shiny and shinyjs for a dynamic and user-friendly interface.
Mobile-Friendly Design: Optimized for accessibility on both desktop and mobile devices.
Getting Started
Prerequisites
R version 4.0 or later
The following R libraries:
shiny
randomForest
DT
plotly
httr
shinyjs
Installation
Clone this repository:

bash
Copy code
git clone https://github.com/your-repo/patient-sentiment-analysis.git
cd patient-sentiment-analysis
Install required R packages:

R
Copy code
install.packages(c("shiny", "randomForest", "DT", "plotly", "httr", "shinyjs"))
Configuration
Update Google OAuth credentials in server.R:

R
Copy code
google_client_id <- "YOUR_GOOGLE_CLIENT_ID"
google_client_secret <- "YOUR_GOOGLE_CLIENT_SECRET"
Define the required scopes:

R
Copy code
scopes <- c(
  "https://www.googleapis.com/auth/userinfo.profile",
  "https://www.googleapis.com/auth/userinfo.email"
)
Running the App
Run the app locally using the following R command:

R
Copy code
shiny::runApp()
Visit http://localhost:PORT in your web browser (the port number is displayed in the console).

Usage
Login: Use the "Login with Google" button on the homepage to access the app.
Upload Dataset: Navigate to the "Upload Dataset" tab and upload a CSV file.
Train Model: Choose the target variable and features, then train the model in the "Prediction" tab.
Visualize Data: Use the "3D Visualization" tab for exploring relationships in the data.
Contact: Reach out to the developers via the "Contact Us" section.
Developers
Jayant Sharma

Role: Developer
Email: jayantsharma2703@gmail.com
LinkedIn: Jayant Sharma
Harshita Ahuja

Role: Co-Developer
Email: harshiahuja075@gmail.com
License
This project is licensed under the MIT License.
आशयः app allows you to upload a dataset, train a predictive model, make predictions, and visualize the data .
