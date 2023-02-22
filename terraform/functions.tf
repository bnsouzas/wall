resource "google_cloudfunctions_function" "wall-register" {
    name     = "${var.app}-register"
    description = "User check in function"
    region = var.region
    labels = {
        app = var.app
    }
    entry_point = "register"
    runtime     = "nodejs18"
    max_instances = 5
    available_memory_mb = 128
    timeout = 60

    trigger_http = true
    https_trigger_security_level = "SECURE_ALWAYS"
    environment_variables = {
    }
    source_repository {
      url = "https://source.developers.google.com/projects/${var.project_id}/repos/${var.repo_name}/moveable-aliases/${var.branch_name}/paths/functions/register"
    }

    depends_on = [
    ]
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.wall-register.project
  region         = google_cloudfunctions_function.wall-register.region
  cloud_function = google_cloudfunctions_function.wall-register.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"

  depends_on = [
    google_cloudfunctions_function.wall-register
  ]
}