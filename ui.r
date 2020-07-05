#Defines the UI
ui <- navbarPage(title = "Terris Combat Log Scraper",
                 tabPanel("About",
                          navlistPanel(widths = c(3,9),
                                       tabPanel("About", includeMarkdown("intro.md")),
                                       tabPanel("Changes", includeMarkdown("changes.md")))),
                 tabPanel("Parse",sidebarLayout(sidebarPanel("Data and Details",
                                                             fileInput('file', 'Upload a .txt log file from the Wizard', accept=c('.txt')),
                                                             textInput('charName', "Provide a character name. This is case sensitive (e.g. Dimly and dimly are treated differently)"),
                                                             downloadButton("downloadFull", label = "Download Raw Parse")),
                                                mainPanel(textOutput("chartext"),DT::dataTableOutput("damageTab")))),
                 tabPanel("Summary", fluidPage(sidebarLayout(sidebarPanel("Summary Tuning",
                                                                          checkboxGroupInput(inputId = "aggGroup", label = "Summarize separately by...",
                                                                                             choices = c("weapon" = "weapon", "monster" = "monster","attack type" = "attack_type", "fatal blows .vs non-fatal blows" = "fatal", "critical hits" = "critical")),
                                                                          downloadButton("downloadSummary", label = "Download Summary")),
                                                             mainPanel(textOutput("sumtext"), DT::dataTableOutput("sumTab")))))
)
