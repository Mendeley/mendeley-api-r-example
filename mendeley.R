require(httr)
require(rjson)
require(RCurl)
require(RColorBrewer)
require(optparse)

option_list <- list(
  make_option(c("-d", "--doi"), action="store_true", help="DOI to search for")
)
program_args = parse_args(OptionParser(option_list = option_list))
doi <- program_args$doi

message("Obtain OAuth client ID and secret from the corresponding environment variables")

client_id <- Sys.getenv("MENDELEY_CLIENT_ID")
client_secret <- Sys.getenv("MENDELEY_CLIENT_SECRET")
basic_auth_credentials = RCurl::base64(paste(client_id, client_secret, sep = ":"))

message("Obtain OAuth access token")

access_token_rsp = POST('https://api.mendeley.com/oauth/token',
	   add_headers(
		       'Authorization' = paste("Basic", basic_auth_credentials),
		       'Content-Type' = 'application/x-www-form-urlencoded'
	   ),
	   body = 'grant_type=client_credentials&scope=all'
)

access_token = content(access_token_rsp)$access_token

message("Search the Mendeley catalogue for the specified DOI")

catalogue_url = paste('https://api.mendeley.com/catalog?view=stats&doi=', curlEscape(doi), sep='')
doc_rsp <- GET(catalogue_url,
	       add_headers(
			   'Authorization' = paste("Bearer", access_token),
			   'Content-Type' = 'application/vnd.mendeley-document.1+json'
	       )
)

docs <- fromJSON(rawToChar(content(doc_rsp)))

if (length(docs) > 0) {
  doc <- docs[[1]]
  message(paste(doc$title, 'has', doc$reader_count, 'readers.'))
  
  message("Create visual representation of the data")

  df <- data.frame(t(data.frame(doc$reader_count_by_academic_status)))
  colnames(df) <- c('readers')
  par(mar=c(5,18,1,1), las=2)
  barplot(df$readers, names.arg=row.names(df), horiz=TRUE, col=brewer.pal(n=15, name="Reds"))
} else {
  message('Document not found.')
}
