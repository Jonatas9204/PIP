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
# FAZ O BACKUP
mysqldump.exe --defaults-extra-file=$config --log-error=$errorLog  --result-file=$backupfile  --databases $database  --single-transaction --flush-logs 

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

