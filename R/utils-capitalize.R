capitalize <- function(x) {

  var <- paste0(
    toupper(substr(x, 1, 1)),
    substr(x, 2, nchar(x))
  )

  return(var)

}
