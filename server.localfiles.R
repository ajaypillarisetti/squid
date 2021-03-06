### Ajay Pillarisetti, University of California, Berkeley, 2015
### V1.0N


shinyServer(function(input, output) {

Sys.setenv(TZ="Asia/Kathmandu")

	output$fileList <- renderUI(function(){
		files<-list.files('~/Desktop/KAPS Air Pollution Data', recursive=T, include.dirs=T, full.names=T, pattern='SQD')
		hhids <- as.data.table(sapply(strsplit(files, "/"),'[[',6))
		multi.hhids <- as.data.table(hhids[,table(hhids)])[N>=6][,hhids]
		set.seed(12171980)
		multi_hhids_sample <- sample(multi.hhids,50)
		multi_hhids_sample <- grep(paste(multi_hhids_sample, collapse="|"), multi.hhids, value=T, invert=T)
		files <- grep(paste(multi_hhids_sample, collapse="|"),files,value=T)
		# files <- sapply(strsplit(files, '/'),'[[',7)
		selectInput("dataset", "Choose a File:", choices = files)
	})

	datasetInput <- reactive({
		if (is.null(input$dataset)) return(NULL)
		dta <- read.squid(input$dataset)
	})

	#read in data - for uploads
	# datasetInput <- reactive({
	#   inFile <- input$files
 	#	if (is.null(inFile)){return(NULL)} 
	# 	dta<- read.squid(inFile$datapath[1])
	# })

	datasetName <- reactive({
		# inFile <- input$files
		# inFile$name
		if (is.null(datasetInput())) return(NULL)
		dta <- basename(input$dataset)
		dta <- gsub(".csv", "", dta)
		dta <- gsub(".CSV", "", dta)
		dta
	})

	data_cleaned <- reactive({
		if (is.null(datasetInput())) return(NULL)
		data_d <- datasetInput()[,with=F]
	})

	####################
	##### datasets ##### 
	####################
	dataXTS.plainplot <- reactive({
		dta<-data_cleaned()
	})

	####################
	##### dygraphs ##### interactivity - to subset data to user-selected range
	####################
	#timezone support is broken for these selections, so manually input the offset. 
	from_z1 <- reactive({
		if (!is.null(input$zeroPlot1_date_window))
		ymd_hms(strftime(gsub(".000Z","",gsub("T"," ",input$zeroPlot1_date_window[[1]])), "%Y-%m-%d %H:%M:%S"), tz='Asia/Kathmandu')+(5.75*60*60)
	})
  
	to_z1 <- reactive({
		if (!is.null(input$zeroPlot1_date_window))
		ymd_hms(strftime(gsub(".000Z","",gsub("T"," ",input$zeroPlot1_date_window[[2]])), "%Y-%m-%d %H:%M:%S"), tz='Asia/Kathmandu')+(5.75*60*60)
	})  

	output$zero1Title <- renderText({paste("Zero 1:", paste(from_z1(), to_z1(), sep=" to ")," ")}) 

	from_z2 <- reactive({
		if (!is.null(input$zeroPlot2_date_window))
		ymd_hms(strftime(gsub(".000Z","",gsub("T"," ",input$zeroPlot2_date_window[[1]])), "%Y-%m-%d %H:%M:%S"), tz='Asia/Kathmandu')+(5.75*60*60)
	})
  
	to_z2 <- reactive({
		if (!is.null(input$zeroPlot2_date_window))
		ymd_hms(strftime(gsub(".000Z","",gsub("T"," ",input$zeroPlot2_date_window[[2]])), "%Y-%m-%d %H:%M:%S"), tz='Asia/Kathmandu')+(5.75*60*60)
	})  

	output$zero2Title <- renderText({paste("Zero 2:", paste(from_z2(), to_z2(), sep=" to ")," ")}) 

	from_sample <- reactive({
		if (!is.null(input$samplePlot_date_window))
		ymd_hms(strftime(gsub(".000Z","",gsub("T"," ",input$samplePlot_date_window[[1]])), "%Y-%m-%d %H:%M:%S"), tz='Asia/Kathmandu')+(5.75*60*60)
	})
  
	to_sample <- reactive({
		if (!is.null(input$samplePlot_date_window))
		ymd_hms(strftime(gsub(".000Z","",gsub("T"," ",input$samplePlot_date_window[[2]])), "%Y-%m-%d %H:%M:%S"), tz='Asia/Kathmandu')+(5.75*60*60)
	})  

	output$sampleTitle <- renderText({paste("Tracer Decay:", paste(from_sample(), to_sample(), sep=" to ")," ")}) 


	####################
	####### Boxes ###### 
	####################
	output$background1 <- renderValueBox({
		datum <- as.data.table(data_cleaned())
		datum[,index:=ymd_hms(index,tz='Asia/Kathmandu')]
		mean_ppm1 <- round(datum[index>=from_z1() & index<=to_z1(), mean(ppm1, na.rm=T)],1)
		mean_ppm2 <- round(datum[index>=from_z1() & index<=to_z1(), mean(ppm2, na.rm=T)],1)
		mean_ppm3 <- round(datum[index>=from_z1() & index<=to_z1(), mean(ppm3, na.rm=T)],1)
		mean_ppm4 <- round(datum[index>=from_z1() & index<=to_z1(), mean(ppm4, na.rm=T)],1)
		infoBox(
			value = paste(mean_ppm1, mean_ppm2, mean_ppm3, mean_ppm4, sep="\n"),
			title = "Background (Zero 1)",
			icon = icon("time", lib='glyphicon'),
			color = "aqua"
		)
	})

	bg1 <- reactive({
		datum <- as.data.table(data_cleaned())
		datum[,index:=ymd_hms(index,tz='Asia/Kathmandu')]
		data.table(
			mean_ppm1_1 <- round(datum[index>=from_z1() & index<=to_z1(), mean(ppm1, na.rm=T)],1),
			mean_ppm2_1 <- round(datum[index>=from_z1() & index<=to_z1(), mean(ppm2, na.rm=T)],1),
			mean_ppm3_1 <- round(datum[index>=from_z1() & index<=to_z1(), mean(ppm3, na.rm=T)],1),
			mean_ppm4_1 <- round(datum[index>=from_z1() & index<=to_z1(), mean(ppm4, na.rm=T)],1)
		)
	})

	output$background2 <- renderValueBox({
		datum <- as.data.table(data_cleaned())
		datum[,index:=ymd_hms(index,tz='Asia/Kathmandu')]
		mean_ppm1 <- round(datum[index>=from_z2() & index<=to_z2(), mean(ppm1, na.rm=T)],1)
		mean_ppm2 <- round(datum[index>=from_z2() & index<=to_z2(), mean(ppm2, na.rm=T)],1)
		mean_ppm3 <- round(datum[index>=from_z2() & index<=to_z2(), mean(ppm3, na.rm=T)],1)
		mean_ppm4 <- round(datum[index>=from_z2() & index<=to_z2(), mean(ppm4, na.rm=T)],1)
		infoBox(
			value = paste(mean_ppm1, mean_ppm2, mean_ppm3, mean_ppm4, sep="\n"),
			title = "Background (Zero 2)",
			icon = icon("time", lib='glyphicon'),
			color = "aqua"
		)
	})

	bg2 <- reactive({
		datum <- as.data.table(data_cleaned())
		datum[,index:=ymd_hms(index,tz='Asia/Kathmandu')]
			data.table(
			mean_ppm1_2 <- round(datum[index>=from_z2() & index<=to_z2(), mean(ppm1, na.rm=T)],1),
			mean_ppm2_2 <- round(datum[index>=from_z2() & index<=to_z2(), mean(ppm2, na.rm=T)],1),
			mean_ppm3_2 <- round(datum[index>=from_z2() & index<=to_z2(), mean(ppm3, na.rm=T)],1),
			mean_ppm4_2 <- round(datum[index>=from_z2() & index<=to_z2(), mean(ppm4, na.rm=T)],1)
		)
	})

	bg_mean <- reactive({
		datum <- rbind(bg1(), bg2())
		setnames(datum, c("ppm1", 'ppm2', 'ppm3', 'ppm4'))
		datum <- datum[,list(
			ppm1=mean(ppm1, na.rm=T),
			ppm2=mean(ppm2, na.rm=T),
			ppm3=mean(ppm3, na.rm=T),
			ppm4=mean(ppm4, na.rm=T)
		)]
	})

	output$background_mean <- renderValueBox({
		infoBox(
			value = bg_mean(),
			title = "Background (Mean)",
			icon = icon("time", lib='glyphicon'),
			color = "aqua"
		)
	})

	####################
	##### Analysis ##### 
	####################

	correctedData <- reactive({
		datum <- as.data.table(data_cleaned())
		datum[,index:=ymd_hms(index,tz='Asia/Kathmandu')]
		datum[,ppm1:=ppm1-bg_mean()[,ppm1]]
		datum[,ppm2:=ppm2-bg_mean()[,ppm2]]
		datum[,ppm3:=ppm3-bg_mean()[,ppm3]]
		datum[,ppm4:=ppm4-bg_mean()[,ppm4]]
		as.xts.data.table(datum)
	})

	correctedData_lm <- reactive({
		datum <- as.data.table(correctedData())
		datum[,index:=ymd_hms(index,tz='Asia/Kathmandu')]
		constrained <- melt(datum, id.var='index')
		constrained <- constrained[index>=from_sample() & index<=to_sample()]
		constrained[,timeproxy:=1:length(value),by='variable']
		fits <- lmList(log(value) ~ timeproxy | variable, data=as.data.frame(constrained))
		ach <- as.data.table(t(abs(coef(fits)[2]*3600)))
		ach <- ach[,`:=`(
			hhid=strsplit(datasetName(), "-")[[1]][1],
			location=strsplit(datasetName(), "-")[[1]][3],
			sqd=strsplit(datasetName(), "-")[[1]][2],
			date=as.character(constrained[,unique(ymd(substring(index,1,10)),tz='Asia/Kathmandu')]),
			file=datasetName(),
			zero1_start=	as.character(from_z1()),
			zero1_stop=		as.character(to_z1()),
			sample_start=	as.character(from_sample()),
			sample_stop=	as.character(to_sample()),
			zero2_start=	as.character(from_z2()),
			zero2_stop=		as.character(to_z2())
		)]
		# not all the same width, so we have an is.unsorted
		ach <- melt(ach, id.var=c("hhid","location","date", 'zero1_start', 'zero1_stop', 'sample_start', 'sample_stop', 'zero2_start', 'zero2_stop'), measure.var=grep("ppm",names(ach)))
		ach.all <- ach[,with=F]
		ach.all
	})


	####################
	###### Tables ###### 
	####################
	output$achTable <- renderTable({
		correctedData_lm()
	}, include.rownames=FALSE)


	####################
	####### PLOTS ###### 
	####################
	output$plainPlot<- 
	renderDygraph({
		dygraph(dataXTS.plainplot()) %>% 
	    dyOptions(axisLineWidth = 1.5, fillGraph = F, drawGrid = FALSE, useDataTimezone=T, colors = RColorBrewer::brewer.pal(4, "Set2"))
	})

	output$zeroPlot1<- 
	renderDygraph({
		dygraph(dataXTS.plainplot()) %>% 
	    dyOptions(axisLineWidth = 1.5, fillGraph = F, drawGrid = FALSE, useDataTimezone=T, colors = RColorBrewer::brewer.pal(4, "Set2"))
	})

	output$zeroPlot2<- 
	renderDygraph({
		dygraph(dataXTS.plainplot()) %>% 
	    dyOptions(axisLineWidth = 1.5, fillGraph = F, drawGrid = FALSE, useDataTimezone=T, colors = RColorBrewer::brewer.pal(4, "Set2"))
	})

	output$samplePlot<- 
	renderDygraph({
		dygraph(log(correctedData()), group = 'SamplePlots') %>% 
	    dyOptions(axisLineWidth = 1.5, fillGraph = F, drawGrid = FALSE, useDataTimezone=T, colors = RColorBrewer::brewer.pal(4, "Set2"))
	})

	output$samplePlotnolog<- 
	renderDygraph({
		dygraph(correctedData(), group = 'SamplePlots') %>% 
	    dyOptions(axisLineWidth = 1.5, fillGraph = F, drawGrid = FALSE, useDataTimezone=T, colors = RColorBrewer::brewer.pal(4, "Set2"))
	})	

	##########################
	####### DL HANDLERS ###### 
	##########################
	output$downloadCSV <- downloadHandler(
		filename = function() {paste(datasetName(), '.cleaned.csv', sep='') },
		content = function(file) {
			write.csv(correctedData_lm(), file, row.names=F)
		} 
	)

})