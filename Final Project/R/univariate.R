#------------------------------------------------------------------------------#
#                              qualStats                                       #
#------------------------------------------------------------------------------#
#' qualStats
#'
#' \code{qualStats} Creates a dataframe containing the contingency matrix
#' for a categorical variable.
#' 
#' @param x Categorical variable with no more than 20 distinct levels 
#'
#' @return A dataframe of descriptive statistics
#' @author John James, \email{jjames@@datasciencesalon.org}
#' @family Summarize Functions
#' @export
qualStats <- function(x) {
  
  # Obtain the contingency data from Hmisc describe class
  desc <- Hmisc::describe(x)
  
  # Extract the values and frequencies and compute the total frequencies
  value <- as.data.frame(desc[[1]]$values$value, stringsAsFactors = FALSE)
  freq <- as.data.frame(desc[[1]]$values$frequency)
  freq <- rbind(freq, sum(desc[[1]]$values$frequency))
  
  # Compute the proportions and convert the frequencies to characters
  # This conversion is performed in order to avoid converting the 
  # precision of the frequencies to that of the proportions.
  prop <- freq / nrow(x)
  freq <- apply(freq, 1, as.character)
  
  # Combine the frequencies and proportions, and provide row and column names
  tbl <- cbind(freq, prop)
  ttl <- c(sum(desc[[1]]$values$frequency), sum(prop))
  colnames(tbl) <- c('Frequency', 'Proportion')
  rownames(tbl)  <- c(desc[[1]]$values$value, "Total")
  
  # Transpose, and name the  and voila
  tbl <- t(tbl)
  return(tbl)
}
  
#------------------------------------------------------------------------------#
#                              quantStats                                      #
#------------------------------------------------------------------------------#
#' quantStats
#'
#' \code{quantStats} Creates a dataframe containing the descriptive 
#' statistics for a quantitative variable.
#' 
#' @param x Quantitative variable
#'
#' @return A dataframe of descriptive statistics
#' @author John James, \email{jjames@@datasciencesalon.org}
#' @family Summarize Functions
#' @export
quantStats <- function(x) {
  
  options(scipen=100)
  options(digits=3)
  
  desc <- Hmisc::describe(x)
  desc <- t(as.data.frame(desc$counts))
  rownames(desc) <- NULL
  desc <- as.data.frame(desc)
  return(desc)
}

#------------------------------------------------------------------------------#
#                               univariate                                     #
#------------------------------------------------------------------------------#
#' univariate
#'
#' \code{univariate} Creates tabular and graphical summaries of dataframes
#' 
#' @param x Dataframe to be summarized
#'
#' @return A list containing summary dataframes and plots
#' @author John James, \email{jjames@@datasciencesalon.org}
#' @family Summarize Functions
#' @export
univariate <- function(x) {
  
  # Obtain column names
  cnames <- names(x)
  
  # Obtain summaries for each column in the dataframe
  analysis <- lapply(cnames, function(cname) {
    
    a <- list()
    
    if (is.numeric(x[[cname]]) | is.integer(x[[cname]])) {
      a$tbl <- quantStats(x[[cname]])
      a$plot <- plotHist(x[cname], yLab = 'Frequency', xLab = cname)
    } else {
      a$tbl <- qualStats(x[cname])
      a$plot <- plotBar(x[cname], yLab = 'Frequency', xLab = cname, legend = FALSE)
    }
    a 
  })
  names(analysis) <- cnames
  return(analysis)
}