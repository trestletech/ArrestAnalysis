getBookings <- function(bookingIDs, outputFile="bookings.Rds", sleepInterval=1){
  pb <- txtProgressBar(min=0, max=length(unique(bookingIDs)), initial=0, style=3)
  bookings <- list()
  counter <- 0
  for (i in bookingIDs){    
    Sys.sleep(sleepInterval)
    bookings[[as.character(i)]] <- downloadBooking(i)
    saveRDS(bookings, file=outputFile)
    counter <- counter+1
    setTxtProgressBar(pb, counter)
  }
  close(pb)
  bookings
}