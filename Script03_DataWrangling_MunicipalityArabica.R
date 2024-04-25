# Pasta de origem e destino
pasta_origem <- "X:/RDirectory/DSBD/LandscapeProductivity/Geo/Municipios_SHP"

pasta_destino <- "X:/RDirectory/DSBD/LandscapeProductivity/Geo/Produtores_Arabica"

nomes_arquivos <- muni_prod$CD_MUN

# Iterar sobre cada nome de arquivo
for (nome_arquivo in nomes_arquivos) {
  # Montar o caminho completo para o arquivo de origem
  caminho_origem <- file.path(pasta_origem, paste0(nome_arquivo, ".gpkg"))  # Supondo que os arquivos tenham extensão .txt
  
  # Verificar se o arquivo existe na pasta de origem
  if (file.exists(caminho_origem)) {
    # Copiar o arquivo para a pasta de destino
    file.copy(caminho_origem, pasta_destino, overwrite = TRUE)
    cat("Arquivo", nome_arquivo, "copiado com sucesso.\n")
  } else {
    cat("Arquivo", nome_arquivo, "não encontrado na pasta de origem.\n")
  }
}

# Shapefile list
caminho_pasta <- "X:/RDirectory/DSBD/LandscapeProductivity/Geo/Produtores_Arabica"

# Listar todos os arquivos shapefile na pasta
arquivos_shape <- list.files(caminho_pasta, pattern = "\\.gpkg$", full.names = TRUE)

# Inicializar uma lista para armazenar os objetos SpatialVector
lista_municipios <- list()

# Loop sobre cada arquivo shapefile
for (arquivo in arquivos_shape) {
  # Ler o arquivo shapefile e adicionar à lista
  municipio <- terra::vect(arquivo)
  lista_municipios[[basename(arquivo)]] <- municipio
}

prod_arab <- lista_municipios

save.image('environment_LandscapeProductivity.RData')