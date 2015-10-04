dashboardPage(
  dashboardHeader(title = "ARMS"),
  dashboardSidebar(disable=TRUE),
	dashboardBody(
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
            tags$script(type='text/javascript', src='dygraph-extra.js'),
            tags$script(type='text/javascript', src='scripties.js')
            ),
		tabItem("analysis",
            fluidRow(
                box(width=12,status="info", solidHeader=TRUE,
                    # fileInput('files', 'Select an ARMS csv file', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv'), multiple=F)
                    uiOutput("fileList")
                )
            ),
            fluidRow(
                infoBoxOutput('background1'),                    
                infoBoxOutput('background2'),                    
                infoBoxOutput('background_mean'),                    
                valueBoxOutput('meanZero2'),
                valueBoxOutput('meanSamplePeriod')
            ),
	        fluidRow(                    
                box(
                    title = "Select Zero 1",
                    width = 6, height='225px',
                    status = "info",
                    dygraphOutput('zeroPlot1', height='165px')
                ),           
                box(
                    title = "Select Zero 2",
                    width = 6, height='225px',
                    status = "info",
                    dygraphOutput('zeroPlot2', height='165px')
                )
            ),
            fluidRow(
                box(
                    title = "Select Sampling",
                    width = 8, height="450px",
                    status="info", solidHeader = TRUE,
                    dygraphOutput('samplePlot', height='375px')
                ),
                box(
                    title = "Sampling (non-transformed)",
                    width = 4, height="450px",
                    status="info", solidHeader = TRUE,
                    dygraphOutput('samplePlotnolog', height='375px')
                )
      	    ),
            fluidRow(
                box(
                    title = 'ACHs',
                    width=12,
                    status='info',
                    solidHeader=TRUE,
                    downloadButton("downloadCSV", "Download as CSV"),
                    HTML("<BR><BR>"),
                    tableOutput('achTable')
                )
            )
        )
	)
)