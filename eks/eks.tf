resource "aws_eks_cluster" "my_cluster" {
    name     = "my-cluster"
    role_arn = aws_iam_role.eks_cluster_role.arn

    vpc_config {
        subnet_ids         = var.subnet_ids  # Specify your subnet IDs
        security_group_ids = var.security_group_ids  # Specify your security group IDs
    }
}

resource "aws_eks_node_group" "my_node_group" {
    cluster_name    = aws_eks_cluster.my_cluster.name
    node_group_name = "my-node-group"
    node_role_arn   = aws_iam_role.eks_node_group_role.arn

    subnet_ids = var.security_group_ids  # Specify your subnet IDs

    scaling_config {
        desired_size = 2
        max_size     = 3
        min_size     = 1
    }

    depends_on = [aws_eks_cluster.my_cluster]
}

resource "aws_iam_role" "eks_cluster_role" {
    name = "eks-cluster-role"
    assume_role_policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [{
            "Effect" : "Allow",
            "Principal" : {
            "Service" : "eks.amazonaws.com"
            },
            "Action" : "sts:AssumeRole"
        }]
    })
}