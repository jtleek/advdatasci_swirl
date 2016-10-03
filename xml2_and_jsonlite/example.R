lesson_info = list(Course = "advdatasci_swirl", Lesson = "xml2_and_jsonlite", 
                   Author = "Detian Deng", Type = "Standard", 
                   Organization = "JHU Biostatistics and DSL",
                   Version = "2.4.2")
## Make sure you have installed xml2 and jsonlite before starting this class.

# Xml2 is a wrapper around the comprehensive libxml2 C library that makes it easier to work with XML and HTML in R. Let's load the package first.
library(xml2)

# Then assign the following inline XML document to a variable called my_xml. "<foo><bar>text <baz id = 'a' /></bar><bar>2</bar><baz id = 'b' /> </foo>"
my_xml <- "<foo><bar>text <baz id = 'a' /></bar><bar>2</bar><baz id = 'b' /> </foo>"

# You can read XML and HTML with read_xml() and read_html(). Please read my_xml by read_xml() and assign it to x.
x <- read_xml(my_xml)

# You can extract various components of a node with xml_text(), xml_attrs(), xml_attr(), and xml_name(). Please get the name of this xml by xml_name().
xml_name(x)

# You can navigate the tree with xml_children(), xml_siblings() or xml_parent(). Now, get all the child nodes of x with xml_children().
xml_children(x)

# Alternatively, use xpath to jump directly to the nodes you’re interested in with xml_find_one() or xml_find_all(). Now, find all baz nodes anywhere in the document and assign it to baz.
baz <- xml_find_all(x, ".//baz")

# Take a look at baz.
baz

# Get the full path to the baz node with xml_path()
xml_path(baz)

# Get the id attribute of baz.
xml_attr(baz, "id")

## Congratulations, you have experienced the main functionality of xml2 package. Next, we will take a look at the jsonlite package.

## The jsonlite package is a JSON parser/generator optimized for the web. Its main strength is that it implements a bidirectional mapping between JSON data and the most important R data types. 
## Thereby we can convert between R objects and JSON without loss of type or information, and without the need for any manual data munging. This is ideal for interacting with web APIs, or to build pipelines where data structures seamlessly flow in and out of R using JSON.

# First, let's load the library.
library(jsonlite)

## In jsonlite package, the most frequently used functions are fromJSON, and toJSON. As the name suggests, they convert between R objects and JSON automatically.

## Simplification is the process where JSON arrays automatically get converted from a list into a more specific R class. The fromJSON function has 3 arguments which control the simplification process: simplifyVector, simplifyDataFrame and simplifyMatrix. Each one is enabled by default.

# When simplifyVector is enabled, JSON arrays containing primitives (strings, numbers, booleans or null) simplify into an atomic vector. For example, create a JSON array of primitives by   json <- '["Mario", "Peach", null, "Bowser"]'
json <- '["Mario", "Peach", null, "Bowser"]'

# Use fromJSON to convert and simplify it into an atomic vector.
fromJSON(json)

# Retry the previous step without simplification, any JSON array turns into a list.
fromJSON(json, simplifyVector = FALSE)

# When simplifyDataFrame is enabled, JSON arrays containing objects (key-value pairs) simplify into a data frame. For example, create a JSON array by json <- '[{"Name" : "Mario", "Age" : 32, "Occupation" : "Plumber"}, {"Name" : "Peach", "Age" : 21, "Occupation" : "Princess"}, {}, {"Name" : "Bowser", "Occupation" : "Koopa"}]'
json <- '[{"Name" : "Mario", "Age" : 32, "Occupation" : "Plumber"}, {"Name" : "Peach", "Age" : 21, "Occupation" : "Princess"}, {}, {"Name" : "Bowser", "Occupation" : "Koopa"}]'

# Convert and simplify it into a data.frame by fromJSON, and assign it to mydf.
mydf <- fromJSON(json)

# Take a look at mydf.
mydf

# Add a new column called Ranking to mydf with value 3, 1, 2, 4.
mydf$Ranking <- c(3, 1, 2, 4)

# Convert it back to JSON with toJSON
toJSON(mydf)

# You can make the converted JSON looks more structured by setting pretty = TRUE, let's try it.
toJSON(mydf, pretty = TRUE)

# When simplifyMatrix is enabled, JSON arrays containing equal-length sub-arrays simplify into a matrix (or higher order R array). For example, create a JSON array by json <- '[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]'
json <- '[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]'

# Converit to matrix and assign to mymatrix.
mymatrix <- fromJSON(json)

# Print mymatrix
mymatrix

# Convert it back to JSON with pretty enabled.
toJSON(mymatrix, pretty = TRUE)

## Congratulations, you have experienced the main functionality of jsonlite package.