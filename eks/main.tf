provider "aws" {
    region = "eu-west-1"  # Change this to your desired AWS region
}

resource "aws_eks_cluster" "my_cluster" {
    name     = "my-cluster"
    role_arn = aws_iam_role.eks_cluster_role.arn

    vpc_config {
        subnet_ids         = ["subnet-abc123", "subnet-def456", "subnet-ghi789"]  # Specify your subnet IDs
        security_group_ids = ["sg-123456"]  # Specify your security group IDs
}
}

resource "aws_eks_node_group" "my_node_group" {
    cluster_name    = aws_eks_cluster.my_cluster.name
    node_group_name = "my-node-group"
    node_role_arn   = aws_iam_role.eks_node_group_role.arn

    subnet_ids = ["subnet-abc123", "subnet-def456", "subnet-ghi789"]  # Specify your subnet IDs

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

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
    role       = aws_iam_role.eks_cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_node_group_role" {
    name = "eks-node-group-role"
    assume_role_policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [{
            "Effect" : "Allow",
            "Principal" : {
            "Service" : "ec2.amazonaws.com"
            },
            "Action" : "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "eks_node_group_policy_attachment" {
    role       = aws_iam_role.eks_node_group_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
    role       = aws_iam_role.eks_node_group_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}