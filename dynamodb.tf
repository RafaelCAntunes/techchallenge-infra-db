# Tabela de Pagamentos
resource "aws_dynamodb_table" "pagamentos" {
  name           = "techchallenge-pagamentos"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "pedidoId"

  attribute {
    name = "pedidoId"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  attribute {
    name = "criadoEm"
    type = "N"
  }

  # Índice para consultar pagamentos por status
  global_secondary_index {
    name               = "StatusIndex"
    hash_key           = "status"
    range_key          = "criadoEm"
    read_capacity      = 5
    write_capacity     = 5
    projection_type    = "ALL"
  }

  tags = {
    Name        = "techchallenge-pagamentos"
    Environment = "production"
    Service     = "pagamento"
  }
}

# Tabela de Produção (fila da cozinha)
resource "aws_dynamodb_table" "producao" {
  name           = "techchallenge-producao"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "pedidoId"
  range_key      = "timestamp"

  attribute {
    name = "pedidoId"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }

  attribute {
    name = "statusProducao"
    type = "S"
  }

  # Índice para consultar por status (EM_PREPARO, PRONTO, ENTREGUE)
  global_secondary_index {
    name               = "StatusProducaoIndex"
    hash_key           = "statusProducao"
    range_key          = "timestamp"
    read_capacity      = 5
    write_capacity     = 5
    projection_type    = "ALL"
  }

  tags = {
    Name        = "techchallenge-producao"
    Environment = "production"
    Service     = "producao"
  }
}