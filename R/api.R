
endpoint <- function(type = c("gql", "subscription")) {
  type <- match.arg(type,
                    c("gql", "subscription"))
  switch(
    type,
    "gql" = "https://api.tibber.com/v1-beta/gql",
    "subscription" = "wss://api.tibber.com/v1-beta/gql/subscriptions"
  )
}


query <- function(query = '{viewer {homes {currentSubscription {priceInfo {current {total energy tax startsAt }}}}}}',
                  token = "476c477d8a039529478ebd690d35ddd80e3308ffc49b59c65b142321aee963a4") {
  con <- ghql::GraphqlClient$new(
    url = endpoint(),
    headers = list(Authorization = paste0("Bearer ", token))
  )
  qry <- ghql::Query$new()
  qry$query('query', query)
  resp <- con$exec(qry$queries$query)
  cont <- jsonlite::fromJSON(resp, flatten = TRUE)
  cont <- dplyr::as_tibble(cont$data$viewer$homes)
  janitor::clean_names(cont)
}
