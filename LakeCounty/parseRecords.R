library(XML)
library(httr)
library(lubridate)

#' Download the bookings for a particular day.
downloadDate <- function(month, day, year){  
  dat <- GET("http://acm.co.lake.ca.us/sheriff/arrests.asp", query=list(ArrestDate=paste(month, day, year, sep="/")))
  if (dat$headers$status != "200"){
    stop ("Non-200 status returned from GET request to server.")
  }  
  con <- content(dat, as="text")  
  html <- htmlParse(con, asText=TRUE)
  tab <- readHTMLTable(html)
  if (length(tab) == 2){
    tab <- tab[[1]]
  }
  legit <- which(grepl("^[[:digit:]]+$", as.character(tab[,1])))
  colnames(tab) <- as.character(unlist((tab[min(legit)-1,])))
  tab <- tab[legit,]
  tab
}

#' Download the details of the particular booking ID provided.
downloadBooking <- function(bookingID){
  dat <- GET("http://acm.co.lake.ca.us/sheriff/bookingdetail.asp", query=list(booknum=bookingID))
  if (dat$headers$status != "200"){
    stop ("Non-200 status returned from GET request to server: ", dat$headers)
  }
  
  con <- content(dat, as="text")
  html <- htmlParse(con, asText=TRUE)
  
  tabs <- readHTMLTable(html)
  
  info <- list()
  charges <- list()
  #Parse the individual tables in this document. They typically have the first row as
  # a section heder, then have alternating rows of titles and content which we'll want
  # to pair up in a list. The first one is usually empty, so start with the second.
  for (t in 2:(length(tabs))){
    thisTab <- processTable(bookingID, tabs[[t]], firstTable=(t==2), lastTable=(t==length(tabs)))
    info <- c(info, thisTab$data)
    charges <- c(charges, thisTab$charges)
  }  
  return(list(data=info, charges=charges))
}

#' Parse a table having a content header row then alternating rows of 
#' titles and content which we'll want to pair up in a list.
#' @param lastTable Whether or not this is the last table in the document. Currently, the
#' last table requires extra formatting as it's actually two separate tables and some
#' additional content at the end.
processTable <- function(bookingID, table, firstTable=FALSE, lastTable=FALSE){
  if (!lastTable){
    if (firstTable){
      #trim to only second and third rows.
      table <- table[2:3,]
    } else{    
      table <- table[-1,]
    }
    
    results <- list()
    for (i in 1:(nrow(table)/2)){
      labels <- as.character(unlist(table[(i*2-1),]))
      #remove trailing colons
      labels <- sub("(.*):", "\\1", labels)
      
      values <- as.character(unlist(table[(i*2),]))
      #Sometimes included in extraneous spacing
      values <- gsub("Â", "", values)
      
      theseResults <- as.list(values)
      names(theseResults) <- labels
      
      #Null holder in these tables is this character. If you see, ignore field.
      theseResults <- theseResults[names(theseResults) != "Â"]
      theseResults <- theseResults[!is.na(names(theseResults))]
      
      results <- c(results, theseResults)
    }
    return(list(data=results))
  }
  if (lastTable){
    table <- table[-nrow(table),]
    table <- table[table[,2] != "Â",]
    
    #Process first row (Court Information)
    results <- list()
    
    labels <- as.character(unlist(table[1,]))
    #remove trailing colons
    labels <- sub("(.*):", "\\1", labels)
    
    values <- as.character(unlist(table[2,]))
    #Sometimes included in extraneous spacing
    values <- gsub("Â", "", values)
      
    theseResults <- as.list(values)
    names(theseResults) <- labels
      
    #Null holder in these tables is this character. If you see, ignore field.
    theseResults <- theseResults[names(theseResults) != "Â"]
    theseResults <- theseResults[!is.na(names(theseResults))]
      
    results <- theseResults
    
    #Process all charges
    labels <- as.character(unlist(table[3,]))
    #remove trailing colons
    labels <- sub("(.*):", "\\1", labels)
    
    charges <- list()
    
    for (i in 4:nrow(table)){
      values <- as.character(unlist(table[i,]))
      #Sometimes included in extraneous spacing
      values <- gsub("Â", "", values)
      
      theseResults <- as.list(c(bookingID, values))
      names(theseResults) <- c("BookingID", labels)
            
      #Null holder in these tables is this character. If you see, ignore field.
      theseResults <- theseResults[!is.na(names(theseResults))]
      theseResults <- theseResults[names(theseResults) != "Â"]      
      
      charges[[length(charges)+1]] <- theseResults
    
    }
    return(list(data=results, charges=charges))
  }
  
}


