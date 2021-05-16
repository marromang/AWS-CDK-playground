/*
  Internet Gateway: https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
*/

resource "aws_internet_gateway" "terraform-workshop-igw" {
  // Recuerda enlazarlo con la VPC
  // Referenciamos el ID de los resources con el formato (resource).(nombre_que_le_pusiste).(propiedad) sin comillas
  vpc_id = aws_vpc.terraform-workshop-vpc.id

  // Los tags son opcionales, los ponemos para para sean faciles de categorizar.
  tags = {
    Name = "terraform-workshop-igw",
    DeployVersion = "0.1"
  }
}

/*
  Route Table: https://www.terraform.io/docs/providers/aws/r/route_table.html
*/

resource "aws_route_table" "terraform-workshop-rt" {
  // Recuerda enlazarla con la VPC
  // Referenciamos el ID de los resources con el formato (resource).(nombre_que_le_pusiste).(propiedad) sin comillas
  vpc_id = aws_vpc.terraform-workshop-vpc.id

  route {
    //Que lo que entre sea de donde sea, entre por IGW
    cidr_block = "0.0.0.0/0"
    //Recuerda enlazarlo al internet_gateway
    // Referenciamos el ID de los resources con el formato (resource).(nombre_que_le_pusiste).(propiedad) sin comillas
    gateway_id = aws_internet_gateway.terraform-workshop-igw.id
  }

  // Los tags son opcionales, los ponemos para para sean faciles de categorizar.
  tags = {
    Name = "terraform-workshop-rt"
    DeployVersion = "0.1"
  }
}

/*
  Route Table Associations: https://www.terraform.io/docs/providers/aws/r/route_table_association.html
*/

resource "aws_route_table_association" "terraform-workshop-rt-association" {
  // Recuerda enlazarla con la subnet
  // Recuerda enlazarla con la route_table
  // Referenciamos el ID de los resources con el formato (resource).(nombre_que_le_pusiste).(propiedad) sin comillas
  subnet_id      = aws_subnet.terraform-workshop-subnet.id
  route_table_id = aws_route_table.terraform-workshop-rt.id
}
