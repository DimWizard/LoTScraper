ma_strings <- c("whips a", "tries a", "executes a", "headbutt", "delivers a", "throws a forearm", "hurls", "body slams", "throws a haymaker", "bites and claws")
enchant_prefixes <- c("Soothing", "Balanced", "Smoldering", "Burning", "Flaming", 
                      "Wildly Flaming", "Staticy", "Sparking", "Arcing", "Lightning Covered",
                      "Smelling", "Pulsating", "Sticky", "Covered", "Black Glowing",
                      "Blue Glowing", "Red Glowing", "Poisoned", "Poison Covered")



parse_attack <- function(text) {
  
  #parse out aim values
  if(str_detect(text, str_c(ma_strings, collapse = "|"))){
    attack_type <- "aim"
    weapon <- "bare hands"
    monster <- gsub("(.*\\bthe\\b |.*\\bat\\b | \\band hits\\b.*)", "", text)
    
    return(c(attack_type = attack_type, weapon = weapon, monster = monster))
  } else if(str_detect(text, "charges")){ #grab charges
    
    attack_type <- "charge"
    
    #martial arts charge
    if(str_detect(text, "and strikes at")){
      weapon <- "bare hands"
      monster <- gsub("(.*\\band strikes at\\b | \\band hits\\b.*)", "", text)
      return(c(attack_type = attack_type, weapon = weapon, monster = monster))
    }
    
    #weapon charge
    weapon <- gsub(".*\\b(his|her)\\b | \\bat\\b.*", "", text)
    monster <- gsub("(.*\\bat\\b | \\band hits\\b.*)", "", text)
    return(c(attack_type = attack_type, weapon = weapon, monster = monster))
  } else if(str_detect(text, "aims")){ #called shot attacks
    attack_type <- "aim"
    weapon <- gsub(".*\\baims (his|her)\\b | \\bat\\b.*", "", text)
    monster <- gsub("(.*\\bat the\\b | \\band hits\\b.*)", "", text)
    return(c(attack_type = attack_type, weapon = weapon, monster = monster))
  } else if(str_detect(text, "strikes")){#bare handed attacks
    attack_type <- "attack"
    weapon <- "bare hands"
    monster <- gsub("(.*\\bstrikes at\\b | \\band hits\\b.*)", "", text)
    return(c(attack_type = attack_type, weapon = weapon, monster = monster))
  }
  #regular attacks with weapons
  attack_type <- "attack"
  weapon <- gsub(".*\\b(his|her)\\b | \\bat\\b.*", "", text)
  monster <- gsub("(.*\\bat the\\b | \\band hits\\b.*)", "", text)
  return(c(attack_type = attack_type, weapon = weapon, monster = monster))
  
}