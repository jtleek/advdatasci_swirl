# rm(list= ls())
library(yaml)
library(zoo)
# lesson_info = 5
# filename = "example.R"


make_df = function(filename) {
  if ("lesson_info" %in% ls()) {
    rm(list = "lesson_info")
  }
  source(filename) # check if it works
  suppressWarnings({
    vals = readLines(filename)
  })
  
  # start at first question
  first_q = grep("^#", vals)[1] 
  vals = vals[seq(first_q, length(vals))]
  
  # trim the white space 
  
  vals = trimws(vals)
  # remove empty strings
  vals = setdiff(vals, "")
  df = data.frame(value = vals,
                  stringsAsFactors = FALSE)
  df$type = NA
  df$type[ grepl("^###", df$value)] = "multiple"
  df$type[ grepl("^##[^#]", df$value)] = "message"
  df$type[ grepl("^#[^#]", df$value)] = "question"
  
  df$type = na.locf(df$type)
  
  df$question = grepl("^#", df$value)
  df$line = c("CorrectAnswer", "Output")[ df$question + 1]
  df$number = cumsum(df$question)
  
  ###############################
  # Every question can only be one line
  ###############################
  tab = table(df$number)
  stopifnot(all(tab %in% 1:2))
  
  # reomves the pounds
  df$value = gsub("^#*", "", df$value)
  df$value = trimws(df$value)
  
  ###########################
  # fixing lesson info
  ###########################
  lesson_info = as.list(lesson_info)
  nL = names(lesson_info)
  if (!"Class" %in% nL) {
    lesson_info$Class = "meta"
  }
  all_names = c("Class", "Course", "Lesson", "Author", 
                "Type", "Organization", "Version")
  nL = names(lesson_info)
  
  ###########################
  # check names of the list
  ###########################
  stopifnot(all(nL %in% all_names))
  lesson_info = lesson_info[all_names]
  L = list(lesson_info = lesson_info,
           df = df)
  return(L)
}

###############################
# converts the data to YAML
###############################
make_yaml = function(L) {
  df = L$df
  ss = split(df, df$number)
  x = ss[[4]]
  ss = lapply(ss, function(x){
    utype = unique(x$type)
    stopifnot(length(utype) == 1)
    vals = x$value
    
    if (utype %in% "question") {
      stopifnot(length(vals) == 2)
      L = list(
        Class = paste0("cmd_", utype),
        Output = vals[1],
        AnswerTests = paste0("omnitest(correctExpr='", vals[2], "')"),
        CorrectAnswer = vals[2],
        Hint = vals[2]
      )
    }
    
    if (utype %in% "multiple") {
      stopifnot(length(vals) == 2)
      choices = eval(parse(text = vals[2]))
      text_choices = paste(choices, collapse = ";")
      L = list(
        Class = paste0("cmd_", utype),
        Output = vals[1],
        AnswerChoices = text_choices,
        AnswerTests = paste0("omnitest(correctVal=", choices[1], "')"),
        CorrectAnswer = choices[1],
        Hint = ""
      )
    }    
    
    if (utype == "message") {
      stopifnot(length(vals) == 1)
      L = list(
        Class = "text",
        Output = vals[1]
      )
    }
    
    return(L)
  })
  ss = c(list(L$lesson_info), ss)
  names(ss) = NULL
  # yaml = sapply(ss, as.yaml)
  # changed this so we had spacing
  yaml = as.yaml(ss, line.sep = "\n")
  return(yaml)
}

###############################
# writes out YAML
###############################
write.yaml = function(yaml, output) {
  writeLines(text = yaml, con = output)
}

###############################
# wrapper
###############################
make_lesson = function(filename, output) {
  L = make_df(filename)
  yaml = make_yaml(L)
  write.yaml(yaml, output)
}
# filename = "example.R"
make_lesson("example.R", output = "example_lesson.yaml")

# }





