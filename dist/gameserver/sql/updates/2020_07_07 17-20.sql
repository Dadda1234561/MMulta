set @exist_Check1 := (
    select count(*) from information_schema.columns 
    where TABLE_NAME='characters' 
    and COLUMN_NAME='last_login' 
    and TABLE_SCHEMA=database()
) ;

set @sqlstmt1 := if(@exist_Check1=0,'ALTER TABLE characters ADD last_login BIGINT UNSIGNED NOT NULL DEFAULT 0 AFTER symbol_seal_points', 'select ''''') ;
prepare stmt1 from @sqlstmt1 ;
execute stmt1 ;

set @exist_Check2 := (
    select count(*) from information_schema.columns 
    where TABLE_NAME='character_subclasses' 
    and COLUMN_NAME='certification' 
    and TABLE_SCHEMA=database()
) ;

set @sqlstmt2 := if(@exist_Check2>0,'RENAME TABLE character_subclasses TO character_dualclasses', 'select ''''') ;
prepare stmt2 from @sqlstmt2 ;
execute stmt2 ;

set @exist_Check3 := (
    select count(*) from information_schema.columns 
    where TABLE_NAME='character_dualclasses' 
    and COLUMN_NAME='certification' 
    and TABLE_SCHEMA=database()
) ;
set @exist_Check4 := (
    select count(*) from information_schema.columns 
    where TABLE_NAME='characters' 
    and COLUMN_NAME='clan_attendance' 
    and TABLE_SCHEMA=database()
) ;

set @sqlstmt3 := if(@exist_Check3>0,'alter table character_dualclasses drop column certification', 'select ''''') ;
prepare stmt3 from @sqlstmt3 ;
execute stmt3 ;

set @sqlstmt4 := if(@exist_Check4>0,'alter table characters drop column clan_attendance', 'select ''''') ;
prepare stmt4 from @sqlstmt4 ;
execute stmt4 ;