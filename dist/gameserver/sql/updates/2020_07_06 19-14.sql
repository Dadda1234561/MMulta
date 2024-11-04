set @exist_Check1 := (
    select count(*) from information_schema.columns 
    where TABLE_NAME='characters' 
    and COLUMN_NAME='symbol_seal_points' 
    and TABLE_SCHEMA=database()
) ;

set @sqlstmt1 := if(@exist_Check1=0,'ALTER TABLE characters ADD symbol_seal_points FLOAT NOT NULL DEFAULT 0 AFTER hide_head_accessories', 'select ''''') ;
prepare stmt1 from @sqlstmt1 ;
execute stmt1 ;