#ui.R for NLP app

shinyUI(navbarPage("Next Word Predictor",
                   
                   tabPanel("Prediction",
                            sidebarPanel(
                            
                                h3("Instructions"),
                                p("Type in a word or phrase in the text box and then push 
                                  THE BUTTON to start the app.  The results will automatically 
                                  keep updating as you type or delete words.  No need to push the
                                  button more than once",
                                  style = "font-family: 'baskerville'; font-si16pt"),
                                textInput("Input", "Input", value="Enter Text..."),
                                actionButton("save", "THE BUTTON")
                                ),
                            mainPanel("Your next word most likely is",
                                verbatimTextOutput("result")
                                )
                    )
#                    tabPanel("Documentation",
#                             mainPanel(
#                                 h3('Explanation'),
#                                 p("blah blah blah", 
#                                   style = "font-family: 'baskerville'; font-si16pt"),
#                                 p("more info", 
#                                   style = "font-family: 'baskerville'; font-si16pt")
#                             )
#                        
#                     )
                 
        )
)
