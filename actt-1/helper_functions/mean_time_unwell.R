#' Calculate mean time unwell
#'
#' @param sop1 First SOP
#' @param sop2 Second SOP
#' @param threshold States equal to or above the threshold are considered "unwell"
calculate_mean_time_unwell <- function(sop1, sop2, threshold){
  
  # Convert rmsb output to a list of matrices
  sop1 <- map(1:nrow(sop1), ~ t(sop1[.x, ,]))
  sop2 <- map(1:nrow(sop2), ~ t(sop2[.x, ,]))
  
  mean_time_unwell_one_draw <- function(matrix_1, matrix_2){
    l <- nrow(matrix_1)
    tmax <- ncol(matrix_1)
    
    total <- 0
    for (t in 1:tmax) {
      for (i in 1:l) {
        for (j in 1:l) {
          score <- NULL
          
          if ((i >= threshold) & (j < threshold)){
            score <- -1
          } else if ((j >= threshold) & (i < threshold)){
            score <- 1
          } else{
            score <- 0
          }
          
          joint_prob <- matrix_1[[i, t]] * matrix_2[[j, t]]
          
          total <- total + (score * joint_prob)
        }
      }
    }
    return(total)
  }
  
  out <- purrr::map2_dbl(
    sop1,
    sop2,
    \(x,y) mean_time_unwell_one_draw(x,y)
  )
  
  return(out)
}
