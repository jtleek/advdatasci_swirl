# For compatibility with 2.2.21
.get_course_path <- function(){
  tryCatch(swirl:::swirl_courses_dir(),
           error = function(c) {file.path(find.package("swirl"),"Courses")}
  )
}

# Make data available to user in a data frame
.path2csv <- file.path(.get_course_path(),
                      'advdatasci_swirl',
                      'Grouping_and_Chaining_with_dplyr',
                      '2014-07-08.csv.gz')
mydf <- read.csv(.path2csv, as.is = TRUE)

# To keep things moving quickly, I'm defining these variables
# upfront. This way, swirl won't try to save them in the
# progress file after each step.
cran <- tbl_df(mydf)
by_package <- group_by(cran, package)
swirl_options(swirl_logging = TRUE)