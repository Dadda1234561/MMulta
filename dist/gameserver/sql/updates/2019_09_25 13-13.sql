DELETE FROM clan_skills;
DELETE FROM clan_subpledges_skills;
UPDATE characters SET clanid = 0, pledge_type = -128 WHERE pledge_type IN (-1,1001,1002,2001,2002);
UPDATE characters SET pledge_type = 0 WHERE pledge_type IN (100,200);