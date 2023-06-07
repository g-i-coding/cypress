##VPC Variables
variable "amplify-name" {
  type = string
  default = "cypress-project3"
  description = "The name of the app"

}


variable "amplify-repo" {
  type = string
  default = "https://github.com/Rizi0/amplify"
  description = "Repo amplify pulls from"
}



variable "github_token" {
  type    = string
  default = null
  sensitive = true
}