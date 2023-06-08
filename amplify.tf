resource "aws_amplify_app" "cypress-project3" {
  name         = var.amplify-name
  repository   = var.amplify-repo
  access_token = data.aws_ssm_parameter.github_token.value

  build_spec                  = file("./buildspec.yaml")
  enable_auto_branch_creation = true

  # The default patterns added by the Amplify Console.
  auto_branch_creation_patterns = [
    "*",
    "*/**",
  ]

  auto_branch_creation_config {
    # Enable auto build for the created branch.
    enable_auto_build = true

  }

  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.cypress-project3.id
  branch_name = "main"

  stage = "PRODUCTION"
}

data "aws_ssm_parameter" "github_token" {
  name = "/cypress_github"
}

output "Run_build" {
  value = "To start the build please run 'aws amplify start-job --app-id ${aws_amplify_branch.main.app_id} --branch-name ${aws_amplify_branch.main.branch_name} --job-type RELEASE'"
}
