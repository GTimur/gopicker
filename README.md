# gopicker

  * Утилита для автоматического разнесения файлов по дереву каталогов ROOT\YYYY\MM\DD на основании даты создания файла.  
  * Дополнительно на основании фильтра позволяет создавать подкаталоги в дереве ROOT\YYYY\MM\DD\SUBFOLDER и копировать туда отфильтрованные файлы.  

## Запуск

### Пример 1

Все файлы, заданные параметром file (-file="*.txt") в папке будут перемещены в каталоги со структурой dst\ГГГГ\ММ\ДД, дополнительно: файлы содержащие в имени фразу "ED211" (-findNameContains="ED211"), а так же содержащие в тексте фразу "ОКОНЧ" (-findPhrase="ОКОНЧ") будут скопирваны в каталог заданный параметром findDir (-findDir="ED211"), т.е. в примере ниже в каталог ГГГГ\ММ\ДД\ED211.  

    gopicker.exe -file="*.txt" -dst="Z:\forms_real\RKC\xml\IN\outpath\content" -silent=false -findDir="ED211" -findNameContains="ED211" -findPhrase="ОКОНЧ"  

### Пример 2

Параметр -findOnly=true запрещает перемещение всех файлов из параметра file (-file="*.ED*") в каталоги со структурой ГГГГ\ММ\ДД.  
Поэтому в данном примере только осуществляется поиск файлов, содержащих в имени фразу "ED807" (-findNameContains="ED807"), данные файлы будут скопирваны в дополнителный к дереву dst\ГГГГ\ММ\ДД каталог, заданный параметром findDir (-findDir="ED807"), т.е. в примере ниже в каталог dst\ГГГГ\ММ\ДД\ED807.  
    
    Z:\forms_real\RKC\xml\IN\GOPICKER\gopicker.exe -file="*.ED*" -dst="Z:\forms_real\RKC\xml\IN\outpath\Object" -silent=false -findDir="ED807" -findNameContains="ED807" -findOnly=true
