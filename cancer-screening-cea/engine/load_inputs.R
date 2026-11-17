# load_inputs.R
# Reads inputs/inputs.csv and returns every parameter as a named list,
# so the model code says l_params$p_H_Pre instead of a hard-coded number.
#
# Usage (from the repo root, e.g. after opening the .Rproj):
#   source("engine/load_inputs.R")
#   l_params <- load_inputs()
#   l_params$r_disc   # 0.03

load_inputs <- function(path = "inputs/inputs.csv", warn_missing = TRUE) {
  df <- read.csv(path, stringsAsFactors = FALSE, strip.white = TRUE)

  # 1. The file must have the columns everyone agreed on
  required <- c("parameter", "value", "low", "high", "distribution",
                "unit", "module", "owner", "source", "notes")
  missing_cols <- setdiff(required, names(df))
  if (length(missing_cols) > 0) {
    stop("inputs.csv is missing columns: ", paste(missing_cols, collapse = ", "))
  }

  # 2. Each parameter name must appear once
  dupes <- df$parameter[duplicated(df$parameter)]
  if (length(dupes) > 0) {
    stop("Duplicate parameter names in inputs.csv: ", paste(unique(dupes), collapse = ", "))
  }

  # 3. Values must be numbers (NA allowed while the team is still filling them in)
  df$value <- suppressWarnings(as.numeric(df$value))

  # 4. Flag inputs that still need a value or a source
  if (warn_missing) {
    no_value  <- df$parameter[is.na(df$value)]
    no_source <- df$parameter[df$source == "" | grepl("^TBD", df$source)]
    if (length(no_value) > 0) {
      message("Still missing a value: ", paste(no_value, collapse = ", "))
    }
    if (length(no_source) > 0) {
      message("Still missing a source: ", paste(no_source, collapse = ", "))
    }
  }

  # 5. Probabilities and utilities must sit between 0 and 1
  bounded <- df$unit %in% c("prob/year", "proportion", "utility") & !is.na(df$value)
  out_of_range <- df$parameter[bounded & (df$value < 0 | df$value > 1)]
  if (length(out_of_range) > 0) {
    stop("These must be between 0 and 1: ", paste(out_of_range, collapse = ", "))
  }

  # Named list: name = parameter, value = number
  l_params <- setNames(as.list(df$value), df$parameter)
  attr(l_params, "table") <- df  # full table kept for sensitivity analysis later
  l_params
}

# Running this file directly prints a quick check
if (sys.nframe() == 0 || interactive()) {
  l_params <- load_inputs()
  str(l_params, give.attr = FALSE)
}
