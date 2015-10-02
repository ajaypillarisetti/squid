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
                box(width=12,status="info", solidHeader=TRUE, title="Welcome to ARMS",
                    fileInput('files', 'Select an ARMS csv file', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv'), multiple=F)
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
                    status = "info", solidHeader = TRUE,
                    dygraphOutput('zeroPlot1', height='175px')
                ),           
                box(
                    title = "Select Zero 2",
                    width = 6, height='225px',
                    status = "info", solidHeader = TRUE,
                    dygraphOutput('zeroPlot2', height='175px')
                )
            ),
            fluidRow(
                box(
                    title = "Select Sampling",
                    width = 12, height="450px",
                    status="info", solidHeader = TRUE,
                    dygraphOutput('samplePlot', height='400px')
                )
      	    ),
            fluidRow(
                box(
                    title = 'ACHs',
                    width=12,
                    status='info',
                    solidHeader=TRUE,
                    tableOutput('achTable')
                )
            )
        )
	)
)