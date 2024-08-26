output "athena_databse_name" {
    value = aws_athena_database.athena_db.name
}

output "athena_workgroup_name" {
    value = aws_athena_workgroup.athena_workgroup.name
}