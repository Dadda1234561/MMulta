DROP TABLE IF EXISTS character_monsterbook;

set @exist_Check1 := (
    select count(*) from information_schema.columns 
    where TABLE_NAME='clan_data' 
    and COLUMN_NAME='hunting_progress' 
    and TABLE_SCHEMA=database()
) ;
set @exist_Check2 := (
    select count(*) from information_schema.columns 
    where TABLE_NAME='clan_data' 
    and COLUMN_NAME='yesterday_hunting_reward' 
    and TABLE_SCHEMA=database()
) ;
set @exist_Check3 := (
    select count(*) from information_schema.columns 
    where TABLE_NAME='clan_data' 
    and COLUMN_NAME='yesterday_attendance_reward' 
    and TABLE_SCHEMA=database()
) ;
set @sqlstmt1 := if(@exist_Check1>0,'alter table clan_data drop column hunting_progress', 'select ''''') ;
prepare stmt1 from @sqlstmt1 ;
execute stmt1 ;

set @sqlstmt2 := if(@exist_Check2>0,'alter table clan_data drop column yesterday_hunting_reward', 'select ''''') ;
prepare stmt2 from @sqlstmt2 ;
execute stmt2 ;

set @sqlstmt3 := if(@exist_Check3>0,'alter table clan_data drop column yesterday_attendance_reward', 'select ''''') ;
prepare stmt3 from @sqlstmt3 ;
execute stmt3 ;