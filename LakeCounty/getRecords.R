getBookings <- function(bookingIDs, outputFile="bookings.Rds", sleepInterval=1){
  pb <- txtProgressBar(min=0, max=length(unique(bookingIDs)), initial=0, style=3)
  bookings <- list()
  charges <- list()
  counter <- 0
  for (i in bookingIDs){    
    Sys.sleep(sleepInterval)
    tryCatch(thisBook <- downloadBooking(i), error=function(e){warning("Error downloading booking ", i)})
    bookings[[as.character(i)]] <- thisBook$data
    charges <- c(charges, thisBook$charges)
    
    if (!is.null(outputFile)){
      saveRDS(bookings, file=outputFile)
    }
    counter <- counter+1
    setTxtProgressBar(pb, counter)
  }
  close(pb)
  return(list(bookings=bookings, charges=charges))
}