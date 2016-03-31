require(httr)
require(rjson)
require(RCurl)
require(RColorBrewer)
require(optparse)

option_list <- list(
  make_option(c("-d", "--doi"), action="store_true", help="DOI to search for")
)
opt = parse_args(OptionParser(option_list = option_list))

clientId <- Sys.getenv("MENDELEY_CLIENT_ID")
clientSecret <- Sys.getenv("MENDELEY_CLIENT_SECRET")

secret = RCurl::base64(paste(clientId, clientSecret, sep = ":"))

req = POST('https://api.mendeley.com/oauth/token',
	   add_headers(
		       'Authorization' = paste("Basic", secret),
		       'Content-Type' = 'application/x-www-form-urlencoded'
	   ),
	   body = 'grant_type=client_credentials&scope=all'
)

token = paste("Bearer", content(req)$access_token)

doi <- opt$doi 
doc_rsp <- GET(paste('https://api.mendeley.com/catalog?view=stats&doi=', curlEscape(doi), sep=''), config(token = token))
docs <- fromJSON(rawToChar(content(doc_rsp)))

if (length(docs) > 0) {
  doc <- docs[[1]]
  message(paste(doc$title, 'has', doc$reader_count, 'readers.'))
  
  df <- data.frame(t(data.frame(doc$reader_count_by_academic_status)))
  colnames(df) <- c('readers')
  par(mar=c(5,18,1,1), las=2)
  barplot(df$readers, names.arg=row.names(df), horiz=TRUE, col=brewer.pal(n=15, name="Reds"))
} else {
  message('Document not found.')
}
