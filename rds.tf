# resource "aws_db_subnet_group" "metabase_subnet_group" {
#   name       = "metabase_subnet_group"

#   subnet_ids = [
#     "${aws_default_subnet.metabase_subnet_a.id}",
#     "${aws_default_subnet.metabase_subnet_b.id}"
#   ]

#   tags = {
#     Name = "My DB subnet group"
#   }
# }

# resource "aws_db_instance" "metabase" {
#   allocated_storage        = 100 
#   backup_retention_period  = 7 
#   engine                   = "postgres"
#   engine_version           = "12.7"
#   identifier               = "metabase"
#   instance_class           = "db.t3.micro"
#   db_name                  = "metabase"
#   password                 = "xq2AcVwza2"
#   port                     = 5432
#   storage_type             = "gp2"
#   username                 = "metabase"
#   vpc_security_group_ids   = ["${aws_security_group.metabase_sec_group.id}"]
#   db_subnet_group_name     = "${aws_db_subnet_group.metabase_subnet_group.id}"
# } 