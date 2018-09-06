library(shiny)

ui <- fluidPage(
    
    # App title ----
    titlePanel("AssessSmart(Beta)"),
    
    tabsetPanel(
        #tabPanel("School Performance"),
        #tabPanel("Class Performance"),
        #tabPanel("Section Performance"),
        tabPanel("Subject Analysis",
                 fluidRow(h3()),
                 fluidRow(
                     column(3,
                            fluidRow(column(1),
                                     column(10,
                                            fluidRow(selectInput("school",
                                                                 "School",
                                                                 c('Anjali EMS')
                                                                 )
                                                     ),
                                            fluidRow(selectInput("class",
                                                                 "Class",
                                                                 c('9')
                                                                 )
                                                     ),
                                            fluidRow(selectInput("section",
                                                                 "Section",
                                                                 c('A', 'B', 'C')
                                                                 )
                                                     ),
                                            fluidRow(selectInput("subject",
                                                                 "Subject",
                                                                 c('Algebra', 'Geometry')
                                                                 )
                                                     )
                                            ),
                                     column(1))),
                     column(9, fluidRow(
                         column(6, plotOutput(outputId = "evolMarks")),
                         column(5, tags$div(class="header", checked=NA,
                                            tags$p("How to use the chart on the left: 
                                                   The chart shows the evolution of class 
                                                   average over last 5 weeks. This can help 
                                                   you understand whether the class is 
                                                   improving or not. Also if post an intervention 
                                                   perforance has increased steadily, it mean that 
                                                   intevention is working."),
                                            tags$a(href="shiny.rstudio.com/tutorial", "Know more")
                         )),
                         column(1)),
                         fluidRow(h1()),
                         fluidRow(
                             column(6, plotOutput(outputId = "chapMastery")),
                             column(5),
                             column(1))
                     )
                 )),
        tabPanel("Chapter Analysis",
                 fluidRow(h3()),
                 fluidRow(
                     column(3,
                            fluidRow(column(1),
                                     column(10,
                                            fluidRow(selectInput("school2",
                                                                 "School",
                                                                 c('Anjali EMS')
                                            )
                                            ),
                                            fluidRow(selectInput("class2",
                                                                 "Class",
                                                                 c('9')
                                            )
                                            ),
                                            fluidRow(selectInput("section2",
                                                                 "Section",
                                                                 c('A', 'B', 'C')
                                            )
                                            ),
                                            fluidRow(selectInput("subject2",
                                                                 "Subject",
                                                                 c('Algebra', 'Geometry')
                                            )
                                            ),
                                            fluidRow(uiOutput("chapControl2")
                                            )
                                            
                                     ),
                                     column(1))),
                     column(9, fluidRow(
                         column(5, plotOutput(outputId = "testChapMastery")),
                         column(6),
                         column(1)),
                         fluidRow(h1()),
                         fluidRow()
                     )
                 )
                 ),
        tabPanel("Test Analysis",
                 fluidRow(h3()),
                 fluidRow(
                     column(3,
                            fluidRow(column(1),
                                     column(10,
                                            fluidRow(selectInput("school1",
                                                                 "School",
                                                                 c('Anjali EMS')
                                            )
                                            ),
                                            fluidRow(selectInput("class1",
                                                                 "Class",
                                                                 c('9')
                                            )
                                            ),
                                            fluidRow(selectInput("section1",
                                                                 "Section",
                                                                 c('A', 'B', 'C')
                                            )
                                            ),
                                            fluidRow(selectInput("subject1",
                                                                 "Subject",
                                                                 c('Algebra', 'Geometry')
                                            )
                                            ),
                                            fluidRow(selectInput("theme",
                                                                 "Chapter/Theme",
                                                                 c('Sets', 'Real Numbers', 'Parallel Lines',
                                                                   'Basic concepts in geometry')
                                            )
                                            ),
                                            fluidRow(selectInput("tests",
                                                                 "Test Name",
                                                                 c('Sets 2','Sets 1', 'Real Numbers 1',
                                                                   'Real Numbers 2', 'Real Numbers 3', 'Real Numbers 4',
                                                                   'Geom 1', 'Geom 2',
                                                                   'Parallel Lines 1', 'Parallel Lines 2')
                                            )
                                            )
                                     ),
                                     column(1))),
                     column(9, fluidRow(
                         column(5, plotOutput(outputId = "distTestMarks")),
                         column(6, plotOutput("topBottom")),
                         column(1)),
                         fluidRow(h1()),
                         fluidRow(plotOutput("jumperSlipper"))
                     )
                     
                 ))
        
        #tabPanel("Fellow Performance"),
        #tabPanel("Student Performance")
    )
)