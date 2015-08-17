#ui.R for NLP app

shinyUI(navbarPage("NLP App",
                   tabPanel("Prediction",
                            sidebarPanel(
                                h3("Instructions"),
                                p("Type in a word or phrase, hit submit, and the app predicts the next word.",
                                  style = "font-family: 'baskerville'; font-si16pt"),
                                textInput("Input", "Input", value="Enter text..."),
                                submitButton("Submit")
                                ),
                            mainPanel(
                                verbatimTextOutput("result")
                                )
                    ),
                   tabPanel("Documentation",
                            mainPanel(
                                h3('Explanation'),
                                p("blah blah blah", 
                                  style = "font-family: 'baskerville'; font-si16pt"),
                                p("more info", 
                                  style = "font-family: 'baskerville'; font-si16pt")
                            )
                       
                    )
                 
        )
)
