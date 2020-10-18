# Main policy
path "sys/*" {
  policy = "deny"
}
path "secret/alfred_ring_data_collector_service/*" {
  policy = "write"
}
path "secret/alfred_common/*" {
  policy = "read"
}

# Local dev policy
path "secret/localhost/*" {
  policy = "read"
}

# Allow tokens to renew themselves
path "auth/token/*" {
  capabilities = [ "update" ]
}
path "auth/token/renew-self" {
  policy = "write"
}