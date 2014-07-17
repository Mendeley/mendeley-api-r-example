# Mendeley API R Example #

This is a simple example of an application that consumes the [Mendeley](http://www.mendeley.com) API.  For more information on the API, see the [developer portal](http://dev.mendeley.com).

## About the application ##

The application is a simple command-line script that retrieves the number of Mendeley users that have read a document with a given DOI, and produces a barplot of the readers by academic status.

## How to run ##

1. Install [R](http://www.r-project.org/) and [Packrat](http://rstudio.github.io/packrat/).
2. Register your client at the [developer portal](http://dev.mendeley.com).  This will give you a client ID and secret.
3. Rename the config.yml.example file to config.yml, and fill in your client ID and secret in this file.
4. Start R:

        R

5. Run the example:

		source("mendeley.R")
