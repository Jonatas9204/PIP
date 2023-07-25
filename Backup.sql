  -- BACKUP ATRAVES DO PLUG-IN CLONE DLL
  -- ARQUIVO MY.INI EDITADO PARA INSTALAR O PLUG-in
  -- As linhas abaixo no my.ini devem estar abaixo do label [mysqld]

plugin-load="mysql_clone.dll"
clone-enable-compression
clone-max-data-bandwidth=50
clone-max-network-bandwidth=100

-- CHAMAR O SNAP SHOT DAS BASES.
 clone LOCAL DATA DIRECTORY 'C:\\mysqlapoio\\clonebackup';
  
-- EVENTO PARA BACKUP AUTOMÁTICO VIA PLUG IN CLONE

delimiter $$

CREATE EVENT snapshotpip
    ON SCHEDULE AT '2023-07-14 14:49:00'
    DO
      BEGIN
        clone LOCAL DATA DIRECTORY 'C:\\mysqlapoio\\clonebackup';
      END $$

delimiter ;