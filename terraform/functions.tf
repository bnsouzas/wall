resource "google_cloudfunctions2_function" "nps-sanitation" {
    name     = "${var.environment}-${var.app}-register"
    location = var.region
    description = "User check in function"

    labels = {
        app = var.app
        environment = var.environment
    }

    build_config {
        runtime     = "nodejs16"
        entry_point = "register"
        source {
            repo_source {
                project_id = var.project_id
                repo_name = "wall"
                branch_name = "main"
                dir = "functions/register"
            }
        }
    }

    service_config {
        max_instance_count = 5
        available_memory   = "256Mi"
        timeout_seconds    = 60
        environment_variables = {
        }
    }

    depends_on            = [
    ]
}