resource "google_sql_database_instance" "master" {
  name = "hostiflix"
  database_version = "POSTGRES_9_6"
  region = "europe-west3"

  settings {
    tier = "db-f1-micro"
  }
}