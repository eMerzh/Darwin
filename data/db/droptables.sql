\set log_error_verbosity terse
DROP TABLE  IF EXISTS specimens_accompanying CASCADE;
DROP TABLE  IF EXISTS igs CASCADE;
DROP TABLE  IF EXISTS associated_multimedia CASCADE;
DROP TABLE  IF EXISTS specimen_parts_insurances CASCADE;
DROP TABLE  IF EXISTS specimen_parts CASCADE;
DROP TABLE  IF EXISTS specimen_individuals CASCADE;
DROP TABLE  IF EXISTS codes CASCADE;
DROP TABLE  IF EXISTS specimens CASCADE;
DROP TABLE  IF EXISTS soortenregister CASCADE;
DROP TABLE  IF EXISTS multimedia_keywords CASCADE;
DROP TABLE  IF EXISTS habitats CASCADE;
DROP TABLE  IF EXISTS lithology CASCADE;
DROP TABLE  IF EXISTS taxonomy CASCADE;
DROP TABLE  IF EXISTS chronostratigraphy CASCADE;
DROP TABLE  IF EXISTS lithostratigraphy CASCADE;
DROP TABLE  IF EXISTS mineralogy CASCADE;
DROP TABLE  IF EXISTS template_classifications CASCADE;
DROP TABLE  IF EXISTS my_widgets CASCADE;
DROP TABLE  IF EXISTS my_saved_searches CASCADE;
DROP TABLE  IF EXISTS collection_maintenance CASCADE;
DROP TABLE  IF EXISTS users_tracking CASCADE;
DROP TABLE  IF EXISTS users_workflow CASCADE;
DROP TABLE  IF EXISTS record_visibilities CASCADE;
DROP TABLE  IF EXISTS users_coll_rights_asked CASCADE;
DROP TABLE  IF EXISTS collections_fields_visibilities CASCADE;
DROP TABLE  IF EXISTS collections_rights CASCADE;
DROP TABLE  IF EXISTS template_collections_users CASCADE;
DROP TABLE  IF EXISTS collections CASCADE;
DROP TABLE  IF EXISTS users_multimedia CASCADE;
DROP TABLE  IF EXISTS people_multimedia CASCADE;
DROP TABLE  IF EXISTS template_people_users_multimedia CASCADE;
DROP TABLE  IF EXISTS users_login_infos CASCADE;
DROP TABLE  IF EXISTS users_addresses CASCADE;
DROP TABLE  IF EXISTS users_comm CASCADE;
DROP TABLE  IF EXISTS people_relationships CASCADE;
DROP TABLE  IF EXISTS people_comm CASCADE;
DROP TABLE  IF EXISTS people_addresses CASCADE;
DROP TABLE  IF EXISTS template_people_users_comm_common CASCADE;
DROP TABLE  IF EXISTS template_people_users_rel_common CASCADE;
DROP TABLE  IF EXISTS template_people_users_addr_common CASCADE;
DROP TABLE  IF EXISTS multimedia CASCADE;
DROP TABLE  IF EXISTS people_languages CASCADE;
DROP TABLE  IF EXISTS users_languages CASCADE;
DROP TABLE  IF EXISTS catalogue_people CASCADE;
DROP TABLE  IF EXISTS identifications CASCADE;
DROP TABLE  IF EXISTS people CASCADE;
DROP TABLE  IF EXISTS users CASCADE;
DROP TABLE  IF EXISTS template_people CASCADE;
DROP TABLE  IF EXISTS template_people_languages CASCADE;
DROP TABLE  IF EXISTS expeditions CASCADE;
DROP TABLE  IF EXISTS vernacular_names CASCADE;
DROP TABLE  IF EXISTS class_vernacular_names CASCADE;
DROP TABLE  IF EXISTS properties_values CASCADE;
DROP TABLE  IF EXISTS catalogue_properties CASCADE;
DROP TABLE  IF EXISTS gtu CASCADE;
DROP TABLE  IF EXISTS tag_groups CASCADE;
DROP TABLE  IF EXISTS tags CASCADE;
DROP TABLE  IF EXISTS comments CASCADE;
DROP TABLE  IF EXISTS ext_links CASCADE;
DROP TABLE  IF EXISTS possible_upper_levels CASCADE;
DROP TABLE  IF EXISTS catalogue_levels CASCADE;
DROP TABLE  IF EXISTS classification_synonymies CASCADE;
DROP TABLE  IF EXISTS classification_keywords CASCADE;
DROP TABLE  IF EXISTS template_table_record_ref CASCADE;
DROP TABLE  IF EXISTS catalogue_relationships CASCADE;
DROP TABLE  IF EXISTS words CASCADE;
DROP TABLE  IF EXISTS darwin_flat CASCADE;
DROP TABLE  IF EXISTS collecting_methods CASCADE;
DROP TABLE  IF EXISTS collecting_tools CASCADE;
DROP TABLE  IF EXISTS specimen_collecting_methods CASCADE;
DROP TABLE  IF EXISTS specimen_collecting_tools CASCADE;
DROP TABLE  IF EXISTS preferences CASCADE;
DROP TABLE  IF EXISTS flat_dict CASCADE;
DROP TABLE  IF EXISTS imports CASCADE;
DROP TABLE  IF EXISTS staging CASCADE;
DROP TABLE  IF EXISTS staging_tag_groups CASCADE;


DROP SEQUENCE IF EXISTS people_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS catalogue_relationships_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS catalogue_people_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS catalogue_levels_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS comments_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS ext_links_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS gtu_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS tag_groups_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS catalogue_properties_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS properties_values_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS identifications_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS class_vernacular_names_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS vernacular_names_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS expeditions_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS users_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS people_languages_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS users_languages_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS multimedia_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS people_relationships_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS people_comm_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS people_addresses_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS users_comm_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS users_addresses_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS users_login_info_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS collections_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS collections_admin_id_seq CASCADE;
DROP SEQUENCE IF EXISTS collections_rights_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS collections_fields_visibilities_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS users_coll_rights_asked_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS record_visibilities_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS users_workflow_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS users_tracking_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS collection_maintenance_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS my_saved_searches_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS my_widgets_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS classification_keywords_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS classification_synonymies_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS classification_synonymies_group_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS taxonomy_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS chronostratigraphy_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS lithostratigraphy_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS mineralogy_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS lithology_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS habitats_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS igs_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS specimens_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS codes_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS specimen_individuals_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS specimen_parts_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS insurances_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS associated_multimedia_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS specimens_accompanying_id_seq  CASCADE;
DROP SEQUENCE IF EXISTS darwin_flat_id_seq CASCADE;
DROP SEQUENCE IF EXISTS collecting_methods_id_seq CASCADE;
DROP SEQUENCE IF EXISTS collecting_tools_id_seq CASCADE;
DROP SEQUENCE IF EXISTS specimen_collecting_methods_id_seq CASCADE;
DROP SEQUENCE IF EXISTS specimen_collecting_tools_id_seq CASCADE;
DROP SEQUENCE IF EXISTS preferences_id_seq CASCADE;
DROP SEQUENCE IF EXISTS flat_dict_id_seq CASCADE;
DROP SEQUENCE IF EXISTS imports_id_seq CASCADE;
DROP SEQUENCE IF EXISTS staging_id_seq CASCADE;
DROP SEQUENCE IF EXISTS staging_tag_groups_id_seq CASCADE;