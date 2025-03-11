library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinythemes)

img.dir = '/srv/shiny-server/images'

# for testing locally, use this:
# img.dir = 'images'

ui <- fluidPage(
	theme = shinytheme('cyborg'),
	navbarPage(
		title = 'Shiny Dashboard App',
		windowTitle = 'Shiny Dashboard App',
		id = 'tabactive',
		tabPanel(
			'Tab1', 
			icon = icon('table'),
			tags$body(
				dashboardPage(
					dashboardHeader(title = 'Tab1', disable = T),
					dashboardSidebar(
						width = '250',
						sidebarMenu(id = 'sidebarmenu', menuItem('Menu1', tabName = 'menu1', icon = icon('chart-line'))),
						minified = F
					),
					dashboardBody(
						tabItems(
							tabItem(tabName = 'menu1', fluidRow(box('Image 1', imageOutput('img_1', height = 'auto'))))
						)
					)
				)
			)
		)
	)
)

server <- shinyServer(function(input, output, session) {
	output$img_1 <- renderImage({
		list(
			src = paste(img.dir, 'img_1.jpg', sep = '/'),
			contentType = 'image/jpg',
			width = '100%',
			height = 'auto',
			alt = 'img_1_err'
		)
	}, deleteFile = F)
})

shinyApp(ui = ui, server = server)
