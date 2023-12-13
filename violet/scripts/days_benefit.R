#' Calculate days benefit given two SOP matrices
#' @param matrix_1 First SOP matrix
#' @param matrix_2 Second SOP matrix
days_benefit_one_draw <- function(matrix_1, matrix_2){
  
  # Assert that the SOP matrices have the same dimensions
  stopifnot(dim(matrix_1) == dim(matrix_2))
  
  # Number of states
  l <- nrow(matrix_1)
  
  # Number of timepoints
  tmax <- ncol(matrix_1)
  
  total <- 0
  for (t in 1:tmax) {
    for (i in 1:l) {
      for (j in 1:l) {
        score <- NULL
        
        if (i == j){
          score <- 0
        } else if (i > j){
          score <- -1
        } else if (i < j){
          score <- 1
        } else{
          stop("Logical Error")
        }
        
        joint_prob <- matrix_1[[i, t]] * matrix_2[[j, t]]
        
        total <- total + (score * joint_prob)
      }
    }
  }
  return(total)
}

#' Calculate posterior days benefit given two SOP objects
#' @param sop1 First SOP object
#' @param sop2 Second SOP object
calculate_days_benefit <- function(sop1, sop2){
  
  # Convert rmsb output from a 3D matrix to a list of matrices
  # where each element of this list is an SOP matrix corresponding
  # to one posterior draw
  sop1 <- map(1:nrow(sop1), ~ t(sop1[.x, ,]))
  sop2 <- map(1:nrow(sop2), ~ t(sop2[.x, ,]))
  
  out <- purrr::map2_dbl(
    sop1,
    sop2,
    \(x,y) days_benefit_one_draw(x,y)
  )

  return(out)
}
