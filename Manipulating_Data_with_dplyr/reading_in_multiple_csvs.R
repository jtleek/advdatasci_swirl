
df_ids = 1:10
for (idf in 1:10){
x = data.frame(x = rnorm(100),
               y = sample(letters, size = 100,
                          replace = TRUE), 
               stringsAsFactors = FALSE)
filename = paste0("tmp_", idf, ".csv")
write.csv(x, file = filename, row.names = FALSE)
}

all_files = paste0("tmp_", 1:10, ".csv")
library(plyr)
res = llply(all_files,
            function(x){
            print(x)
              df = fread(x)
            dplyr::sample_frac(df, size = 0.5)
            },
      .progress = "text")
class(res)
length(res)
big_df = rbindlist(res)
big_df = as.data.frame(big_df)
class(big_df)
