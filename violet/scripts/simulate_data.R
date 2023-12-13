# Simulate longitudinal ordinal data from a fitted blrm model
generate_record <- function(x,
                            baseline_y,
                            model,
                            y_levels,
                            times,
                            absorb,
                            id){
  
  # Store the simulated y values
  y_stored <- integer()
  yprev_stored <- integer()
  
  # Counter for the number of iterations
  i <- 1
  
  # Set day to the first time
  day <- times[[i]]
  
  # Baseline state
  yprev <- baseline_y
  
  while (TRUE) {
    
    # Add the current day to the covariate data frame
    x$day <- day
    
    # Add the previous state to the covariate data frame
    x$yprev <- yprev
    
    # Calculate the transition probabilities from the fitted model
    # Use the posterior median (but this can be changed)
    transition_probabilities <- 
      predict(model,
              x,
              type = "fitted.ind",
              posterior.summary = "median",
              cint = FALSE)$Median
    
    # Move to the next state according to the transition probabilities
    y <- sample(x = y_levels,
                size = 1,
                prob = transition_probabilities)
    
    # Save the value of y
    y_stored <- c(y_stored, y)
    yprev_stored <- c(yprev_stored, yprev)
    
    # Increment counter
    i <- i + 1
    
    # Break condition
    if ((i > length(times)) | (y == absorb)) {
      break
    }
    
    # Set next day
    day <- times[[i]]
    yprev <- y
  }
  
  out <- data.frame(times = times[1:length(y_stored)],
                    y = y_stored,
                    yprev = yprev_stored)
  
  # Remove row names from the data frames for merging
  rownames(out) <- NULL
  rownames(x) <- NULL
  
  # We don't want to merge in these variables
  x$yprev <- NULL
  x$day <- NULL
  
  # Merge in covariate values
  out <- cbind(out, x)
  
  # Add back in the ID variable
  out$id <- id
  
  return(out)
}