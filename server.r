library(shiny)
library(tidyverse)
library(DT)
source("extra stuff.R")

options(shiny.maxRequestSize = 300*1024^2)


# Define server logic 

server <- function(input, output) {
  
  damageTable <- reactive({
    
    req(input$file, input$charName)
    
    inFile <- input$file
    
    dat <- read_lines(inFile$datapath) 
    
    dat <- data.frame(text = dat) %>%
      mutate(text = str_replace_all(.data$text, "(\\[|&lsb)[:digit:]{2}\\:[:digit:]{2}\\:[:digit:]{2}(\\]|&rsb)", "")) %>%    
      mutate(text = str_replace_all(.data$text, "\\^[:alpha:]", "")) %>%
      filter(.data$text != "") %>%
      filter(str_detect(.data$text, str_glue("You hit for|You critically hit for|", "^", input$charName)))%>%
      filter(str_detect(.data$text, "You hit for|You critically hit for|and hits for")) %>%
      filter(!str_detect(.data$text, "instantly killing|instantly kills|lopped off in one shot|killing it quite effectively|one direction and the body in a different direction|body go flying as it collapses")) %>%
      mutate(variable = rep(c("attack_text", "damage"), n()/2),
             instance = rep(1:(n()/2), each = 2)) %>%
      pivot_wider(names_from = .data$variable, values_from = .data$text)
    
    parsed_attacks <- map_dfr(dat$attack_text, parse_attack)
    
    dat <- bind_cols(dat, parsed_attacks)
    
    dat <- dat %>%
      select(-.data$instance) %>%
      separate(.data$damage, "damage.", into = c("gross", "absorbed"), fill = "right", remove = FALSE) %>%
      mutate(gross = as.numeric(str_replace_all(.data$gross, "[:alpha:]|[:punct:]", "")),
             absorbed = as.numeric(ifelse(.data$absorbed == "", "0", str_replace_all(.data$absorbed, "[:alpha:]|[:punct:]", ""))),
             net = .data$gross - .data$absorbed,
             fatal = str_detect(.data$attack_text, "fatal"),
             critical = str_detect(.data$damage, "critically"),
             weapon = str_trim(str_replace_all(.data$weapon, str_c(str_c(".*\\b",enchant_prefixes), collapse = "|"), "")),
             monster = str_trim(str_replace(.data$monster, str_glue(input$charName, ".*\\bat\\b"), ""))) %>%
      select(-.data$attack_text, -.data$damage)
    
    return(dat)
    
  })
  
  charText <- reactive({
    req(input$charName)
    
    str_glue("Displaying damage parse for character named: ", input$charName)
  })
  
  sumtext <- reactive({
    req(input$charName)
    
    str_glue("Displaying summary parse for character named: ", input$charName)
  })
  output$chartext <- renderText(charText())
  
  output$damageTab <- DT::renderDataTable({
    if(is.null(damageTable())){
      return(NULL)}else{
        damageTable()}
  })
  
  output$downloadFull <- downloadHandler(
    filename = function(){paste0(input$charName," raw parse.csv")},
    content = function(file) {
      write_csv(damageTable(), file)
    }
  )
  
  output$downloadSummary <- downloadHandler(
    filename = function(){paste0(input$charName, " summary parse.csv")},
    content = function(file) {
      write_csv(damageSum(), file)
    }
  )
  
  damageSum <- reactive({
    
    req(damageTable())
    
    useAggs <- any(!is.null(input$aggGroup))
    
    if(useAggs){
      damsum <- damageTable() %>%
        group_by(!!!rlang::syms(input$aggGroup)) %>%
        mutate(hits = n()) %>%
        group_by(hits, .add = TRUE) %>%
        summarize_at(.vars = vars(gross, net, absorbed), .funs = c(average = mean, median =  median, min = min, max = max)) %>%
        select(!!!rlang::syms(input$aggGroup), starts_with("gross"), starts_with("net"), starts_with("absorbed")) %>%
        ungroup()
      
      return(damsum)
    }
    
    damageTable() %>%
      mutate(hits = n()) %>%
      group_by(hits) %>%
      summarize_at(.vars = vars(gross, net, absorbed), .funs = c(average = mean, median = median, min = min, max = max)) %>%
      select(hits, starts_with("gross"), starts_with("net"), starts_with("absorbed")) %>%
      ungroup()
  })
  
  output$sumTab <- DT::renderDataTable({
    datatable(damageSum(), options = list(autoWidth = FALSE)) %>%
      formatRound(columns = apply(expand.grid(c("gross", "net", "absorbed"), 
                                              c("average", "min", "max")), 1, paste, collapse = "_"), 
                  digits = 2)})
}


