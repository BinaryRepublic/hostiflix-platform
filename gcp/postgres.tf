resource "google_sql_database_instance" "master" {
  name = "production"
  database_version = "POSTGRES_9_6"
  region = "europe-west3"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "users" {
  name      = "hostiflix"
  instance  = "${google_sql_database_instance.master.name}"
}

resource "google_sql_user" "users" {
  instance = "${google_sql_database_instance.master.name}"
  name     = "postgres"
  password = "password"
}