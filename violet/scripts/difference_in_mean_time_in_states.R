#' Calculate difference in mean time in states given two SOP matrices
#' @param matrix_1 First SOP matrix
#' @param matrix_2 Second SOP matrix
#' @param states Integer vector specifying the states to be considered
difference_in_mean_time_in_states_one_draw <- function(matrix_1, matrix_2, states){
  
  # Assert that the SOP matrices have the same dimensions
  stopifnot(dim(matrix_1) == dim(matrix_2))
  
  # Step 1: Select rows from the SOP matrix that are included in `states`
  # Step 2: Mean time in states is the sum of the elements of the matrix
  mean_time_in_states_1 <- matrix_1[states, ] |> sum()
  mean_time_in_states_2 <- matrix_2[states, ] |> sum()
  
  difference <- mean_time_in_states_1 - mean_time_in_states_2
  return(difference)
}

#' Calculate posterior difference in mean time in states given two SOP objects
#' @param sop1 First SOP object
#' @param sop2 Second SOP object
#' @param states Integer vector specifying the states to be considered
calculate_difference_in_mean_time_in_states <- function(sop1, sop2, states){
  
  # Convert rmsb output from a 3D matrix to a list of matrices
  # where each element of this list is an SOP matrix corresponding
  # to one posterior draw
  sop1 <- map(1:nrow(sop1), ~ t(sop1[.x, ,]))
  sop2 <- map(1:nrow(sop2), ~ t(sop2[.x, ,]))
  
  # Compute the difference in mean time in states for each posterior draw
  posterior_difference_in_mean_time_in_states <- 
    purrr::map2_dbl(
      sop1,
      sop2,
      \(x,y) difference_in_mean_time_in_states_one_draw(x,y, states=states)
    )
  
  return(posterior_difference_in_mean_time_in_states)
}

