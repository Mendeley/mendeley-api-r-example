# Mendeley API R Example #

This is a simple example of an application that consumes the [Mendeley](http://www.mendeley.com) API. It uses the OAuth client credentials flow. For more information on the API, see the [developer portal](http://dev.mendeley.com).

## About the application ##

The application is a simple command-line script that retrieves the number of Mendeley users that have read a document with a given DOI, and produces a barplot of the readers by academic status.

## Prerequisites ##

Register your client at the [developer portal](http://dev.mendeley.com).  This will give you a client ID and secret. Save them somewhere safe - they are sensitive credentials, and once the secret is set it is never revealed again (to protect it).

## How to run ##

1. Install [R](http://www.r-project.org/).
2. In a shell, or in Rstudio, set the MENDELEY_CLIENT_ID and MENDELEY_CLIENT_SECRET environment variables to the values you just got from the developer portal.
3. Think of a DOI you would like to search for.
4. Run the script, passing the DOI in as a command line argument. You can do that like this:

        Rscript mendeley.R --doi 10.1.1.105.1540


## Build status

![Travis CI](https://travis-ci.org/Mendeley/mendeley-api-r-example.svg?branch=master)
