locals {
  vpc_id                = var.vpc_id
  subnet_ids            = var.subnet_ids
  image                 = var.image
  cluster_id            = var.cluster_id
  high_availability     = length(local.subnet_ids) > 2
  image_pull_secret_arn = var.image_pull_secret_arn
  cpu                   = var.cpu
  memory                = var.memory
  task_execute_role_arn = var.task_execute_role_arn
  # network
  security_groups_ids     = var.security_group_ids
  network_mode            = "awsvpc"
  support_provider        = ["FARGATE"]
  application_credentials = var.application_credentials
  jdbc_driver_class_name  = var.jdbc_driver_class_name
  log_mode                = "awslogs"
}

resource "aws_ecs_task_definition" "this" {
  cpu                      = local.cpu
  memory                   = local.memory
  execution_role_arn       = local.task_execute_role_arn
  network_mode             = local.network_mode
  requires_compatibilities = local.support_provider
  task_role_arn            = local.task_execute_role_arn

  container_definitions = jsonencode(
    [
      {
        name  = "apiserver"
        image = local.image
        repositoryCredentials = {
          credentialsParameter = local.image_pull_secret_arn
        }
        secrets = [
          {
            name      = "DB_PASSWORD",
            valueFrom = format("%s:%s::", local.application_credentials, "DB_PASSWORD")
          },
          {
            name      = "DB_USERNAME",
            valueFrom = format("%s:%s::", local.application_credentials, "DB_USERNAME")
          },
          {
            name      = "DB_JDBC_URL",
            valueFrom = format("%s:%s::", local.application_credentials, "DB_JDBC_URL")
          }
        ]
        environment = [
          {
            name  = "DB_DRIVER_CLASS",
            value = local.jdbc_driver_class_name
          },
        ]
//        logConfiguration = {
//          logDriver = local.log_mode
//          options = {
//            awslogs-group         = "/ecs",
//            awslogs-region        = "ap-northeast-2",
//            awslogs-stream-prefix = "apiserver"
//          }
//        }
      }

    ]
  )
  family = "apiserver"
}

resource "aws_ecs_service" "this" {
  for_each = toset(local.subnet_ids)

  name            = "apiserver-${trimprefix(each.key, "subnet-")}"
  cluster         = local.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [each.key]
    security_groups = local.security_groups_ids
  }

  lifecycle {
    create_before_destroy = true
  }
}