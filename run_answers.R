
library(yaml)
fol = "Grouping_and_Chaining_with_dplyr"
run_answers = function(fol) {
  
  yaml = file.path(fol, "lesson.yaml")
  init = file.path(fol, "initLesson.R")
  deps = file.path(fol, "dependson.txt")
  if (file.exists(deps)) {
    deps = readLines(deps)
    deps = setdiff(deps, "")
    deps = paste0("library(", deps, ")")
    tmpfile = tempfile(fileext = ".R")
    writeLines(text = deps, tmpfile)
    source(tmpfile)
  }
  if (file.exists(init)) {
    source(init)
  }
  res = yaml.load_file(yaml)
  res = sapply(res, function(x) {
    script = x$Script
    if (!is.null(script)) {
      script = sub("[.]R$", "-correct.R", script)
      script = paste0("source('", file.path(fol, "scripts", script), "')")
    }
    xx = x$CorrectAnswer
    return(c(script, xx))
  })
  res = unlist(res)
  tmpfile = tempfile(fileext = ".R")
  writeLines(text = res, con = tmpfile)
  source(tmpfile)
}

fols = c("Grouping_and_Chaining_with_dplyr", 
         "Dates_and_Times_with_lubridate",
         "Manipulating_Data_with_dplyr",
         "Tidying_Data_with_tidyr",
         "httr_and_rvest_1")
for (ifol in fols) {
  print(ifol)
  run_answers(fol = ifol)
}
