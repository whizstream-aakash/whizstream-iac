#main/modules/aws_ecs/main.tf

resource "aws_ecs_cluster" "video_transcoder_cluster" {
  name = var.ecs_cluster_name
}