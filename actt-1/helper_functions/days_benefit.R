#' Calculate days benefit
#'
#' @param sop1 First SOP
#' @param sop2 Second SOP
calculate_days_benefit <- function(sop1, sop2){
  
  # Convert rmsb output to a list of matrices
  sop1 <- map(1:nrow(sop1), ~ t(sop1[.x, ,]))
  sop2 <- map(1:nrow(sop2), ~ t(sop2[.x, ,]))

  days_benefit_one_draw <- function(matrix_1, matrix_2){
    l <- nrow(matrix_1)
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
          } else{
            score <- 1
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
    \(x,y) days_benefit_one_draw(x,y)
  )

  return(out)
}
