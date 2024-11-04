DELETE FROM character_subclasses WHERE class_id=135 OR class_id=136 OR default_class_id=135 OR default_class_id=136;
DELETE FROM character_skills WHERE class_index=135 OR class_index=136;
DELETE FROM character_skills_save WHERE class_index=135 OR class_index=136;
DELETE FROM character_effects_save WHERE id=135 OR id=136;
DELETE FROM character_hennas WHERE class_index=135 OR class_index=136;
DELETE FROM character_shortcuts WHERE class_index=135 OR class_index=136;