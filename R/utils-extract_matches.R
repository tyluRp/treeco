#-------------------------------------------------------------------------------
# Extract matches function
#-------------------------------------------------------------------------------
extract_matches <- function(tree_data, species_data) {

  message("Gathering species matches...")

  trees <- tree_data
  species <- species_data

  '%nin%' <- Negate('%in%')

  # Extract unique common names, convert to lower case, remove punctuation
  unique_commons <- unique(trees[, "common_name"])
  unique_commons <- stats::na.omit(unique_commons)
  unique_commons$common_name <- tolower(unique_commons$common_name)
  unique_commons$common_name <- gsub('[[:punct:]]+', '', unique_commons$common_name)
  unique_commons$common_name <- trimws(unique_commons$common_name, "both") # Save for end?

  # Extract unique botanical names, conver to lower case, remove punctuation
  unique_botanicals <- unique(trees[, "botanical_name"])
  unique_botanicals <- stats::na.omit(unique_botanicals)
  unique_botanicals$botanical_name <- tolower(unique_botanicals$botanical_name)
  unique_botanicals$botanical_name <- gsub('[[:punct:]]+', '', unique_botanicals$botanical_name)
  unique_botanicals$botanical_name <- trimws(unique_botanicals$botanical_name, "both") # Save for end?

  species$common_name_m <- tolower(species$common_name)
  species$common_name_m <- gsub('[[:punct:]]+', '', species$common_name_m)
  species$common_name_m <- trimws(species$common_name_m, "both") # Save for end?

  species$botanical_name_m <- tolower(species$scientific_name)
  species$botanical_name_m <- gsub('[[:punct:]]+', '', species$botanical_name_m)
  species$botanical_name_m <- trimws(species$botanical_name_m, "both") # Save for end?

  vec <- unlist(lapply(unique_commons$common_name, function(x) which.max(string_dist(x, species$common_name_m))))

  unique_commons$common_name_m <- species[vec,][["common_name_m"]]
  unique_commons$botanical_name_m <- species[vec,][["botanical_name_m"]]
  unique_commons$spp_value_assignment <- species[vec,][["spp_value_assignment"]]
  unique_commons[, "sim" := string_dist(common_name[1], common_name_m[1]), by = common_name]
  unique_commons_1 <- unique_commons[sim >= 0.80]

  species <- species[species$common_name_m %nin% unique_commons_1$common_name_m, ]

  vec <- unlist(lapply(unique_botanicals$botanical_name, function(x) which.max(string_dist(x, species$botanical_name_m))))

  unique_botanicals$botanical_name_m <- species[vec,][["botanical_name_m"]]
  unique_botanicals$common_name_m <- species[vec,][["common_name_m"]]
  unique_botanicals$spp_value_assignment <- species[vec,][["spp_value_assignment"]]
  unique_botanicals[, "sim" := string_dist(botanical_name[1], botanical_name_m[1]), by = botanical_name]
  unique_botanicals_1 <- unique_botanicals[sim >= 0.80]

  trees$common_name <- tolower(trees$common_name)
  trees$common_name <- gsub('[[:punct:]]+', '', trees$common_name)
  trees$common_name <- trimws(trees$common_name, "both") # Save for end?

  trees$botanical_name <- tolower(trees$botanical_name)
  trees$botanical_name <- gsub('[[:punct:]]+', '', trees$botanical_name)
  trees$botanical_name <- trimws(trees$botanical_name, "both") # Save for end?

  trees_common <- trees[unique_commons_1, on = "common_name"]
  trees_botanical <- trees[unique_botanicals_1, on = "botanical_name"]

  trees <- rbind(trees_common, trees_botanical)

  tree_vars <- c("common_name_m", "botanical_name_m", "dbh_val", "spp_value_assignment")
  trees <- trees[, .SD, .SDcols = tree_vars]
  trees <- trees[, ("id") := 1:nrow(trees)]

  tree_vars <- c("common_name_m", "botanical_name_m", "dbh_val", "spp_value_assignment")
  trees_unique <- trees[, .SD, .SDcols = tree_vars]
  trees_unique <- unique(trees_unique, by = c("common_name_m", "dbh_val"))

  data.table::setnames(trees, "common_name_m", "common_name")
  data.table::setnames(trees, "botanical_name_m", "botanical_name")
  data.table::setnames(trees_unique, "common_name_m", "common_name")
  data.table::setnames(trees_unique, "botanical_name_m", "botanical_name")

  output <- list(trees = trees, trees_unique = trees_unique)
  return(output)
}