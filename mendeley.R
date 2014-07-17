library(httr)
library(rjson)
library(RCurl)
library(yaml)
library(RColorBrewer)

config <- yaml.load_file('config.yml')

mendeley <- oauth_endpoint(base_url = 'https://api.mendeley.com/oauth', authorize = 'authorize', access = 'token')
myapp <- oauth_app(appname = 'My app', key = config$clientId, secret = config$clientSecret)
token <- oauth2.0_token(mendeley, myapp, scope='all')

profile_rsp <- GET('https://api.mendeley.com/profiles/me', config(token = token))
profile <- fromJSON(rawToChar(content(profile_rsp)))
message(paste('Hello, ', profile$display_name, '!', sep=''))

doi <- readline('Enter a DOI: ')
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
