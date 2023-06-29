 # backup via script
   -- Criar arquivo .ps1 para leitura no power shell
   
$backuppath = "C:\mysqlapoio\backups\"  # Caminho para armazenar os backups, coloque a barra \ no final da caminho, caso use outra pasta para backup
$config = "C:\mysqlapoio\config.cnf"  # Caminho para o arquivo com as credenciais
$database = "pip" # Nome do nosso banco de dados
$errorLog = "C:\mysqlapoio\backups\erros\error_dump.log"  # Caminho para o nosso arquivo de log
$days = 30 # Dias para manter os arquivos de backup
$date = Get-Date
$timestamp = "" + $date.day + $date.month + $date.year + "_" + $date.hour + $date.minute 
$backupfile = $backuppath + $database + "_" + $timestamp +".sql"
$backupzip = $backuppath + $database + "_" + $timestamp +".zip"
$7zip = "C:\Program Files\7-Zip\7z.exe\"
-- FAZ O BACKUP
mysqldump.exe --defaults-extra-file=$config --log-error=$errorLog  --result-file=$backupfile  --databases $database  --single-transaction --flush-logs --routines --events

# Inicia o processo de compactacao com 7zip  
# "C:\Program Files\7-Zip\7zFM.exe" a -tzip $backupzip $backupfile

& "C:\Program Files\7-Zip\7z.exe" a -tzip "$backupzip" "$backupfile"
  
# Deleta o arquivo original e deixa apenas o zip
Del $backupfile
 
# Deleta arquivos antigos
CD $backuppath
$oldbackups = gci *.zip* 
  
for($i=0; $i -lt $oldbackups.count; $i++){ 
    if ($oldbackups[$i].CreationTime -lt $date.AddDays(-$days)){ 
        $oldbackups[$i] | Remove-Item -Confirm:$false
    } 
}

# fim

----------------------------SCRIPT DE Backup dos arquivos LOG---------------------------


$dadosoriginaispath = "C:\ProgramData\MySQL\MySQL Server 8.0\Data\*-bin.*" # caminho onde estao os seus arquivos bin log. Altere o caminho se precisar e mascara * do seus binlogs
                      

$backuppath = "C:\mysqlapoio\backups\"  # Caminho para armazenar os backups, coloque a barra \ no final da caminho, caso use outra pasta para backup
$config = "C:\mysqlapoio\config.cnf"  # Caminho para o arquivo com as credenciais do root
$date = Get-Date
$timestamp = "" + $date.day + $date.month + $date.year + "_" + $date.hour + $date.minute 

$backupfile = "C:\mysqlapoio\backups\*-bin.*" # local onde foram copiados os binarios e aqui sera o local usado pelo 7z para compactar os arquivos biblog
$backupzip = $backuppath + "BINLOGBK_" + $timestamp +".zip"

# Aqui o mysql ira reclicar o logbin atual, criando um novo arquivo de log. Altere o caminho abaixo onde esta seu arquivo com a senha do root.
mysqladmin --defaults-extra-file=$config  flush-logs

# Aqui iremos copiar os arquivos de log que estao na pasta padrao para destino onde estarão todos os backups full e dos logs. Favor alterar o caminho se for necessário.
Copy-Item $dadosoriginaispath -Destination $backuppath 

# Inicia o processo de compactacao com 7zip  

& "C:\Program Files\7-Zip\7z.exe" a -tzip "$backupzip" "$backupfile"

# Remove os arquivos original deixando apenas os binlogs compactados
Remove-item $backupfile

# Deleta arquivos antigos
CD $backuppath
$oldbackups = gci *.zip* 
  
for($i=0; $i -lt $oldbackups.count; $i++){ 
    if ($oldbackups[$i].CreationTime -lt $date.AddDays(-$days)){ 
        $oldbackups[$i] | Remove-Item -Confirm:$false
    } 
}

# fim

   -- Vamos Executar no DOS o backup manual full com arquivo de erros.
   -- VAMOS EXECUTAR no DOS o Backup do LOGs full.

C:\MYSQLAPOIO\backupfulldb.ps1
C:\mysqlapoio\backupLOGdb.ps1 

SHOW BINARY LOGS;