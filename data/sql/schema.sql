CREATE TABLE associated_multimedia (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id BIGINT NOT NULL, multimedia_ref BIGINT NOT NULL, PRIMARY KEY(id));
CREATE TABLE catalogue_levels (id BIGSERIAL, level_type TEXT NOT NULL, level_name TEXT NOT NULL, level_sys_name TEXT NOT NULL, optional_level BOOLEAN DEFAULT 'false' NOT NULL, PRIMARY KEY(id));
CREATE TABLE catalogue_people (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id BIGINT NOT NULL, people_type TEXT DEFAULT 'author' NOT NULL, people_sub_type TEXT NOT NULL, order_by BIGINT DEFAULT 1 NOT NULL, people_ref BIGINT NOT NULL, PRIMARY KEY(id));
CREATE TABLE catalogue_properties (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id BIGINT NOT NULL, property_type TEXT NOT NULL, property_sub_type TEXT, property_sub_type_indexed TEXT, property_qualifier TEXT, property_qualifier_indexed TEXT, date_from_mask BIGINT DEFAULT 0 NOT NULL, date_from TEXT DEFAULT '0001-01-01' NOT NULL, date_to_mask BIGINT DEFAULT 0 NOT NULL, date_to TEXT DEFAULT '2038-12-31' NOT NULL, property_unit TEXT DEFAULT NULL, property_accuracy_unit TEXT, property_method TEXT, property_method_indexed TEXT, property_tool TEXT, property_tool_indexed TEXT, PRIMARY KEY(id));
CREATE TABLE catalogue_relationships (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id_1 BIGINT NOT NULL, record_id_2 BIGINT NOT NULL, relationship_type TEXT DEFAULT 'recombined from' NOT NULL, PRIMARY KEY(id));
CREATE TABLE chronostratigraphy (id BIGSERIAL, name TEXT NOT NULL, name_indexed TEXT, name_order_by TEXT, level_ref BIGINT NOT NULL, status TEXT DEFAULT 'valid' NOT NULL, path TEXT DEFAULT '/', parent_ref BIGINT DEFAULT 0, lower_bound NUMERIC(10,3), upper_bound NUMERIC(10,3), PRIMARY KEY(id));
CREATE TABLE class_vernacular_names (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id BIGINT NOT NULL, community TEXT NOT NULL, PRIMARY KEY(id));
CREATE TABLE classification_keywords (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id BIGINT NOT NULL, keyword_type TEXT DEFAULT 'name' NOT NULL, keyword TEXT NOT NULL, PRIMARY KEY(id));
CREATE TABLE classification_synonymies (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id BIGINT NOT NULL, group_id BIGINT NOT NULL, group_name TEXT NOT NULL, is_basionym BOOLEAN DEFAULT 'false', order_by BIGINT DEFAULT 0 NOT NULL, PRIMARY KEY(id));
CREATE TABLE codes (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id BIGINT NOT NULL, code_category TEXT DEFAULT 'main' NOT NULL, code_prefix TEXT, code_prefix_separator TEXT, code TEXT, code_suffix TEXT, code_suffix_separator TEXT, full_code_indexed TEXT, full_code_order_by TEXT, code_date TEXT, code_date_mask BIGINT DEFAULT 0 NOT NULL, PRIMARY KEY(id));
CREATE TABLE collecting_methods (id BIGSERIAL, method TEXT NOT NULL, method_indexed TEXT, PRIMARY KEY(id));
CREATE TABLE collecting_tools (id BIGSERIAL, tool TEXT NOT NULL, tool_indexed TEXT, PRIMARY KEY(id));
CREATE TABLE collection_maintenance (id BIGSERIAL, record_id BIGINT NOT NULL, referenced_relation TEXT NOT NULL, people_ref BIGINT NOT NULL, category TEXT DEFAULT 'action' NOT NULL, action_observation TEXT NOT NULL, description TEXT, description_ts TEXT, modification_date_time TEXT NOT NULL, modification_date_mask BIGINT DEFAULT 0 NOT NULL, PRIMARY KEY(id));
CREATE TABLE collections (id BIGSERIAL, collection_type VARCHAR(255) DEFAULT 'mix' NOT NULL, code TEXT NOT NULL, name TEXT NOT NULL, institution_ref BIGINT NOT NULL, main_manager_ref BIGINT NOT NULL, parent_ref BIGINT, path TEXT DEFAULT '/' NOT NULL, code_auto_increment BOOLEAN DEFAULT 'false' NOT NULL, code_last_value BIGINT DEFAULT 0 NOT NULL, code_prefix TEXT, code_prefix_separator TEXT, code_suffix TEXT, code_suffix_separator TEXT, code_part_code_auto_copy BOOLEAN DEFAULT 'false' NOT NULL,is_public BOOLEAN DEFAULT 'true' NOT NULL, PRIMARY KEY(id));
CREATE TABLE collections_admin (id BIGSERIAL, collection_ref BIGINT DEFAULT 0 NOT NULL, user_ref BIGINT DEFAULT 0 NOT NULL, PRIMARY KEY(id));
CREATE TABLE collections_fields_visibilities (id BIGSERIAL, collection_ref BIGINT DEFAULT 0 NOT NULL, user_ref BIGINT DEFAULT 0 NOT NULL, field_group_name TEXT NOT NULL, db_user_type BIGINT DEFAULT 1 NOT NULL, searchable BOOLEAN DEFAULT 'true' NOT NULL, visible BOOLEAN DEFAULT 'true' NOT NULL, PRIMARY KEY(id));
CREATE TABLE collections_rights (id BIGSERIAL, collection_ref BIGINT NOT NULL, user_ref BIGINT DEFAULT 0 NOT NULL, PRIMARY KEY(id));
CREATE TABLE comments (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id BIGINT NOT NULL, notion_concerned TEXT NOT NULL, comment TEXT NOT NULL, comment_ts TEXT, comment_language_full_text TEXT, PRIMARY KEY(id));
CREATE TABLE expeditions (id BIGSERIAL, name TEXT NOT NULL, name_ts TEXT, name_indexed TEXT, name_language_full_text TEXT, expedition_from_date_mask BIGINT DEFAULT 0 NOT NULL, expedition_from_date TEXT DEFAULT '0001-01-01', expedition_to_date_mask BIGINT DEFAULT 0 NOT NULL, expedition_to_date TEXT DEFAULT '0001-01-01', PRIMARY KEY(id));
CREATE TABLE gtu (id BIGSERIAL, code TEXT NOT NULL, parent_ref BIGINT DEFAULT 0 NOT NULL, gtu_from_date_mask BIGINT DEFAULT 0 NOT NULL, gtu_from_date TEXT DEFAULT '0001-01-01' NOT NULL, gtu_to_date_mask BIGINT DEFAULT 0 NOT NULL, gtu_to_date TEXT DEFAULT '0001-01-01' NOT NULL, PRIMARY KEY(id));
CREATE TABLE habitats (id BIGSERIAL, name TEXT NOT NULL, path TEXT DEFAULT '/' NOT NULL, code TEXT NOT NULL, code_indexed TEXT DEFAULT '/', description TEXT NOT NULL, description_ts TEXT, description_language_full_text TEXT, habitat_system TEXT DEFAULT 'eunis' NOT NULL, PRIMARY KEY(id));
CREATE TABLE identifications (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id BIGINT NOT NULL, notion_concerned TEXT NOT NULL, notion_date TEXT DEFAULT '0001-01-01' NOT NULL, notion_date_mask BIGINT DEFAULT 0 NOT NULL, value_defined TEXT, value_defined_indexed TEXT, value_defined_ts TEXT, determination_status TEXT, order_by BIGINT DEFAULT 1 NOT NULL, PRIMARY KEY(id));
CREATE TABLE igs (id BIGSERIAL, ig_num TEXT NOT NULL, ig_num_indexed TEXT NOT NULL, ig_date_mask BIGINT DEFAULT 0 NOT NULL, ig_date TEXT DEFAULT '0001-01-01', PRIMARY KEY(id));
CREATE TABLE people (id BIGSERIAL, is_physical BOOLEAN, sub_type TEXT, formated_name TEXT, formated_name_indexed TEXT, formated_name_ts TEXT, family_name TEXT NOT NULL, additional_names TEXT, PRIMARY KEY(id));
CREATE TABLE insurances (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id BIGINT NOT NULL, insurance_value NUMERIC(16,2) NOT NULL, insurance_currency TEXT DEFAULT '€' NOT NULL, insurance_year BIGINT DEFAULT 0, insurer_ref BIGINT, PRIMARY KEY(id));
CREATE TABLE lithology (id BIGSERIAL, name TEXT NOT NULL, name_indexed TEXT, name_order_by TEXT, level_ref BIGINT NOT NULL, status TEXT DEFAULT 'valid' NOT NULL, path TEXT DEFAULT '/', parent_ref BIGINT DEFAULT 0, PRIMARY KEY(id));
CREATE TABLE lithostratigraphy (id BIGSERIAL, name TEXT NOT NULL, name_indexed TEXT, name_order_by TEXT, level_ref BIGINT NOT NULL, status TEXT DEFAULT 'valid' NOT NULL, path TEXT DEFAULT '/', parent_ref BIGINT DEFAULT 0, PRIMARY KEY(id));
CREATE TABLE mineralogy (id BIGSERIAL, name TEXT NOT NULL, name_indexed TEXT, name_order_by TEXT, level_ref BIGINT NOT NULL, status TEXT DEFAULT 'valid' NOT NULL, path TEXT DEFAULT '/', parent_ref BIGINT DEFAULT 0, code TEXT NOT NULL, classification TEXT DEFAULT 'strunz' NOT NULL, formule TEXT, formule_indexed TEXT, cristal_system TEXT, PRIMARY KEY(id));
CREATE TABLE multimedia (id BIGSERIAL, is_digital BOOLEAN NOT NULL, type TEXT DEFAULT 'image' NOT NULL, sub_type TEXT, title TEXT NOT NULL, title_indexed TEXT, subject TEXT DEFAULT '/' NOT NULL, coverage TEXT DEFAULT 'temporal' NOT NULL, apercu_path TEXT, copyright TEXT, license TEXT, uri TEXT, descriptive_ts TEXT, descriptive_language_full_text TEXT, creation_date TEXT DEFAULT '0001-01-01' NOT NULL, creation_date_mask BIGINT DEFAULT 0 NOT NULL, publication_date_from TEXT DEFAULT '0001-01-01' NOT NULL, publication_date_from_mask BIGINT DEFAULT 0 NOT NULL, publication_date_to TEXT DEFAULT '0001-01-01' NOT NULL, publication_date_to_mask BIGINT DEFAULT 0 NOT NULL, parent_ref BIGINT, path TEXT DEFAULT '/' NOT NULL, mime_type TEXT, PRIMARY KEY(id));
CREATE TABLE multimedia_keywords (id BIGSERIAL, object_ref BIGINT NOT NULL, keyword TEXT NOT NULL, keyword_indexed TEXT, PRIMARY KEY(id));
CREATE TABLE my_saved_searches (id BIGSERIAL, user_ref BIGINT NOT NULL, name TEXT NOT NULL, search_criterias TEXT NOT NULL, favorite BOOLEAN DEFAULT 'false' NOT NULL, is_only_id BOOLEAN DEFAULT 'false' NOT NULL, modification_date_time TEXT NOT NULL, visible_fields_in_result TEXT NOT NULL, PRIMARY KEY(id));
CREATE TABLE my_widgets (id BIGSERIAL, user_ref BIGINT NOT NULL, category TEXT DEFAULT 'board_widget' NOT NULL, group_name TEXT NOT NULL, order_by BIGINT DEFAULT 1 NOT NULL, col_num BIGINT DEFAULT 1 NOT NULL, mandatory BOOLEAN DEFAULT 'false' NOT NULL, visible BOOLEAN DEFAULT 'true' NOT NULL, is_available BOOLEAN DEFAULT 'false', opened BOOLEAN DEFAULT 'true' NOT NULL, color TEXT DEFAULT '#5BAABD', icon_ref BIGINT, title_perso TEXT, PRIMARY KEY(id));
CREATE TABLE people (id BIGSERIAL, is_physical BOOLEAN NOT NULL, sub_type TEXT, formated_name TEXT, formated_name_indexed TEXT, formated_name_ts TEXT, title TEXT, family_name TEXT NOT NULL, given_name TEXT, additional_names TEXT, birth_date_mask BIGINT DEFAULT 0 NOT NULL, birth_date TEXT DEFAULT '0001-01-01' NOT NULL, gender VARCHAR(255), end_date_mask BIGINT DEFAULT 0 NOT NULL, end_date TEXT DEFAULT '0001-01-01' NOT NULL, activity_date_from TEXT DEFAULT '0001-01-01' NOT NULL, activity_date_from_mask BIGINT DEFAULT 0 NOT NULL, activity_date_to TEXT DEFAULT '0001-01-01' NOT NULL, activity_date_to_mask BIGINT DEFAULT 0 NOT NULL, PRIMARY KEY(id));
CREATE TABLE people_addresses (id BIGSERIAL, person_user_ref BIGINT NOT NULL, tag TEXT DEFAULT '' NOT NULL, entry TEXT, po_box TEXT, extended_address TEXT, locality TEXT NOT NULL, region TEXT, zip_code TEXT, country TEXT NOT NULL, address_parts_ts TEXT, PRIMARY KEY(id));
CREATE TABLE people_comm (id BIGSERIAL, person_user_ref BIGINT NOT NULL, comm_type TEXT DEFAULT 'TEL' NOT NULL, tag TEXT DEFAULT '' NOT NULL, entry TEXT NOT NULL, PRIMARY KEY(id));
CREATE TABLE people_languages (id BIGSERIAL, people_ref BIGINT NOT NULL, language_country TEXT DEFAULT 'en_gb' NOT NULL, mother BOOLEAN DEFAULT 'true' NOT NULL, preferred_language BOOLEAN DEFAULT 'false' NOT NULL, PRIMARY KEY(id));
CREATE TABLE people_multimedia (id BIGSERIAL, person_user_ref BIGINT NOT NULL, object_ref BIGINT NOT NULL, category TEXT DEFAULT 'avatar' NOT NULL, PRIMARY KEY(id));
CREATE TABLE people_relationships (id BIGSERIAL, relationship_type TEXT DEFAULT 'belongs to' NOT NULL, person_1_ref BIGINT NOT NULL, person_2_ref BIGINT NOT NULL, path TEXT, activity_date_from TEXT DEFAULT '0001-01-01' NOT NULL, activity_date_from_mask BIGINT DEFAULT 0 NOT NULL, activity_date_to TEXT DEFAULT '0001-01-01' NOT NULL, activity_date_to_mask BIGINT DEFAULT 0 NOT NULL, person_user_role TEXT, PRIMARY KEY(id));
CREATE TABLE possible_upper_levels (level_ref BIGINT, level_upper_ref BIGINT, PRIMARY KEY(level_ref, level_upper_ref));
CREATE TABLE properties_values (id BIGSERIAL, property_ref BIGINT, property_value TEXT NOT NULL, property_value_unified TEXT, property_accuracy FLOAT, property_accuracy_unified FLOAT, PRIMARY KEY(id));
CREATE TABLE record_visibilities (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id BIGINT NOT NULL, db_user_type BIGINT DEFAULT 0 NOT NULL, user_ref BIGINT DEFAULT 0 NOT NULL, visible BOOLEAN DEFAULT 'true' NOT NULL, PRIMARY KEY(id));
CREATE TABLE soortenregister (id BIGSERIAL, taxa_ref BIGINT DEFAULT 0 NOT NULL, gtu_ref BIGINT DEFAULT 0 NOT NULL, habitat_ref BIGINT DEFAULT 0 NOT NULL, date_from TEXT, date_to TEXT, PRIMARY KEY(id));
CREATE TABLE specimen_individuals (id BIGSERIAL, specimen_ref BIGINT NOT NULL, type TEXT DEFAULT 'specimen' NOT NULL, type_group TEXT, type_search TEXT, sex TEXT DEFAULT 'undefined' NOT NULL, stage TEXT DEFAULT 'undefined' NOT NULL, state TEXT DEFAULT 'not applicable' NOT NULL, social_status TEXT DEFAULT 'not applicable' NOT NULL, rock_form TEXT DEFAULT 'not applicable' NOT NULL, specimen_individuals_count_min BIGINT DEFAULT 1 NOT NULL, specimen_individuals_count_max BIGINT DEFAULT 1 NOT NULL, PRIMARY KEY(id));
CREATE TABLE specimen_parts (id BIGSERIAL, path TEXT DEFAULT '/' NOT NULL, parent_ref BIGINT, specimen_individual_ref BIGINT NOT NULL, specimen_part TEXT DEFAULT 'specimen' NOT NULL, complete BOOLEAN DEFAULT 'true' NOT NULL, building TEXT, floor TEXT, room TEXT, row TEXT, shelf TEXT, container TEXT, sub_container TEXT, container_type TEXT DEFAULT 'container' NOT NULL, sub_container_type TEXT DEFAULT 'container' NOT NULL, container_storage TEXT DEFAULT 'dry' NOT NULL, sub_container_storage TEXT DEFAULT 'dry' NOT NULL, surnumerary BOOLEAN DEFAULT 'false' NOT NULL, specimen_status TEXT DEFAULT 'good state' NOT NULL, specimen_part_count_min BIGINT DEFAULT 1 NOT NULL, specimen_part_count_max BIGINT DEFAULT 1 NOT NULL, PRIMARY KEY(id));
CREATE TABLE darwin_flat (id BIGSERIAL, spec_ref BIGINT NOT NULL, category TEXT, collection_ref BIGINT DEFAULT 0 NOT NULL, collection_type TEXT, collection_code TEXT, collection_name TEXT, collection_institution_ref BIGINT DEFAULT 0 NOT NULL, collection_institution_formated_name TEXT, collection_institution_formated_name_ts TEXT, collection_institution_formated_name_indexed TEXT, collection_institution_sub_type TEXT, collection_main_manager_ref BIGINT DEFAULT 0 NOT NULL, collection_main_manager_formated_name TEXT, collection_main_manager_formated_name_ts TEXT, collection_main_manager_formated_name_indexed TEXT, collection_parent_ref BIGINT DEFAULT 0, collection_path TEXT, expedition_ref BIGINT DEFAULT 0 NOT NULL, expedition_name TEXT, expedition_name_ts TEXT, expedition_name_indexed TEXT, station_visible BOOLEAN, gtu_ref BIGINT DEFAULT 0 NOT NULL, gtu_code TEXT, gtu_parent_ref BIGINT DEFAULT 0, gtu_path TEXT, gtu_from_date_mask BIGINT, gtu_from_date TEXT, gtu_to_date_mask BIGINT, gtu_to_date TEXT, gtu_tag_values_indexed TEXT, gtu_country_tag_value TEXT, taxon_ref BIGINT DEFAULT 0 NOT NULL, taxon_name TEXT, taxon_name_indexed TEXT, taxon_name_order_by TEXT, taxon_level_ref BIGINT NOT NULL, taxon_level_name TEXT, taxon_status TEXT, taxon_path TEXT, taxon_parent_ref BIGINT DEFAULT 0, taxon_extinct BOOLEAN, litho_ref BIGINT DEFAULT 0 NOT NULL, litho_name TEXT, litho_name_indexed TEXT, litho_name_order_by TEXT, litho_level_ref BIGINT DEFAULT 0 NOT NULL, litho_level_name TEXT, litho_status TEXT, litho_path TEXT, litho_parent_ref BIGINT DEFAULT 0, chrono_ref BIGINT DEFAULT 0 NOT NULL, chrono_name TEXT, chrono_name_indexed TEXT, chrono_name_order_by TEXT, chrono_level_ref BIGINT DEFAULT 0 NOT NULL, chrono_level_name TEXT, chrono_status TEXT, chrono_path TEXT, chrono_parent_ref BIGINT DEFAULT 0, lithology_ref BIGINT DEFAULT 0 NOT NULL, lithology_name TEXT, lithology_name_indexed TEXT, lithology_name_order_by TEXT, lithology_level_ref BIGINT DEFAULT 0 NOT NULL, lithology_level_name TEXT, lithology_status TEXT, lithology_path TEXT, lithology_parent_ref BIGINT DEFAULT 0, mineral_ref BIGINT DEFAULT 0 NOT NULL, mineral_name TEXT, mineral_name_indexed TEXT, mineral_name_order_by TEXT, mineral_level_ref BIGINT DEFAULT 0 NOT NULL, mineral_level_name TEXT, mineral_status TEXT, mineral_path TEXT, mineral_parent_ref BIGINT DEFAULT 0, host_taxon_ref BIGINT DEFAULT 0 NOT NULL, host_relationship TEXT, host_taxon_name TEXT, host_taxon_name_indexed TEXT, host_taxon_name_order_by TEXT, host_taxon_level_ref integer notnull: true DEFAULT , host_taxon_level_name TEXT, host_taxon_status TEXT, host_taxon_path TEXT, host_taxon_parent_ref BIGINT DEFAULT 0, host_taxon_extinct BOOLEAN, ig_ref BIGINT, ig_num TEXT, ig_num_indexed TEXT, ig_date_mask BIGINT, ig_date TEXT, acquisition_category TEXT, acquisition_date_mask BIGINT, acquisition_date TEXT, specimen_count_min BIGINT, specimen_count_max BIGINT, with_types BOOLEAN);
CREATE TABLE specimens (id BIGSERIAL, category TEXT DEFAULT 'physical' NOT NULL, collection_ref BIGINT NOT NULL, expedition_ref BIGINT DEFAULT 0, gtu_ref BIGINT DEFAULT 0, taxon_ref BIGINT DEFAULT 0, litho_ref BIGINT DEFAULT 0, chrono_ref BIGINT DEFAULT 0, lithology_ref BIGINT DEFAULT 0, mineral_ref BIGINT DEFAULT 0, host_taxon_ref BIGINT DEFAULT 0, host_specimen_ref BIGINT, host_relationship TEXT, acquisition_category TEXT DEFAULT 'expedition', acquisition_date_mask BIGINT DEFAULT 0 NOT NULL, acquisition_date TEXT DEFAULT '0001-01-01', specimen_count_min BIGINT DEFAULT 1, specimen_count_max BIGINT DEFAULT 1, station_visible BOOLEAN DEFAULT 'true', multimedia_visible BOOLEAN DEFAULT 'true', ig_ref BIGINT, PRIMARY KEY(id));
CREATE TABLE specimens_accompanying (id BIGSERIAL, accompanying_type TEXT DEFAULT 'biological' NOT NULL, specimen_ref BIGINT NOT NULL, taxon_ref BIGINT DEFAULT 0 NOT NULL, mineral_ref BIGINT DEFAULT 0 NOT NULL, form TEXT DEFAULT 'isolated' NOT NULL, quantity NUMERIC(16,2), unit TEXT DEFAULT '%', PRIMARY KEY(id));
CREATE TABLE codes (id BIGSERIAL, referenced_relation TEXT DEFAULT 'specimens' NOT NULL, record_id BIGINT NOT NULL, code_category TEXT DEFAULT 'main' NOT NULL, code_prefix TEXT, code_prefix_separator TEXT, code TEXT, code_suffix TEXT, code_suffix_separator TEXT, full_code_indexed TEXT, full_code_order_by TEXT, code_date TEXT, code_date_mask BIGINT DEFAULT 0 NOT NULL, PRIMARY KEY(id));
CREATE TABLE specimen_collecting_methods (id BIGSERIAL, specimen_ref BIGINT NOT NULL, collecting_method_ref BIGINT NOT NULL, PRIMARY KEY(id));
CREATE TABLE specimen_collecting_tools (id BIGSERIAL, specimen_ref BIGINT NOT NULL, collecting_tool_ref BIGINT NOT NULL, PRIMARY KEY(id));
CREATE TABLE tag_groups (id BIGSERIAL, gtu_ref BIGINT NOT NULL, group_name TEXT NOT NULL, group_name_indexed TEXT, sub_group_name TEXT NOT NULL, sub_group_name_indexed TEXT, color TEXT DEFAULT '#FFFFFF', tag_value TEXT NOT NULL, PRIMARY KEY(id));
CREATE TABLE tags (gtu_ref BIGINT, group_ref BIGINT, tag TEXT NOT NULL, group_type TEXT NOT NULL, sub_group_type TEXT NOT NULL, tag_indexed TEXT, PRIMARY KEY(gtu_ref, group_ref, tag_indexed));
CREATE TABLE taxonomy (id BIGSERIAL, name TEXT NOT NULL, name_indexed TEXT, name_order_by TEXT, level_ref BIGINT NOT NULL, status TEXT DEFAULT 'valid' NOT NULL, path TEXT DEFAULT '/', parent_ref BIGINT DEFAULT 0, extinct BOOLEAN DEFAULT 'false' NOT NULL, PRIMARY KEY(id));
CREATE TABLE users (id BIGSERIAL, is_physical BOOLEAN NOT NULL, sub_type TEXT, formated_name TEXT, formated_name_indexed TEXT, formated_name_ts TEXT, title TEXT, family_name TEXT NOT NULL, given_name TEXT, additional_names TEXT, birth_date_mask BIGINT DEFAULT 0 NOT NULL, birth_date TEXT DEFAULT '0001-01-01' NOT NULL, gender VARCHAR(255), db_user_type BIGINT DEFAULT 1 NOT NULL, people_id BIGINT, PRIMARY KEY(id));
CREATE TABLE users_addresses (id BIGSERIAL, person_user_ref BIGINT NOT NULL, tag TEXT DEFAULT '' NOT NULL, entry TEXT, organization_unit TEXT, person_user_role TEXT, po_box TEXT, extended_address TEXT, locality TEXT NOT NULL, region TEXT, zip_code TEXT, country TEXT NOT NULL, address_parts_ts TEXT, PRIMARY KEY(id));
CREATE TABLE users_coll_rights_asked (id BIGSERIAL, collection_ref BIGINT DEFAULT 0 NOT NULL, user_ref BIGINT DEFAULT 0 NOT NULL, field_group_name TEXT NOT NULL, db_user_type BIGINT NOT NULL, searchable BOOLEAN DEFAULT 'true' NOT NULL, visible BOOLEAN DEFAULT 'true' NOT NULL, motivation TEXT NOT NULL, asking_date_time TEXT NOT NULL, with_sub_collections BOOLEAN DEFAULT 'true' NOT NULL, PRIMARY KEY(id));
CREATE TABLE users_comm (id BIGSERIAL, person_user_ref BIGINT NOT NULL, comm_type TEXT DEFAULT 'TEL' NOT NULL, entry TEXT NOT NULL, tag TEXT DEFAULT '' NOT NULL, PRIMARY KEY(id));
CREATE TABLE users_languages (id BIGSERIAL, users_ref BIGINT NOT NULL, language_country TEXT DEFAULT 'en_gb' NOT NULL, mother BOOLEAN DEFAULT 'true' NOT NULL, preferred_language BOOLEAN DEFAULT 'false' NOT NULL, PRIMARY KEY(id));
CREATE TABLE users_login_infos (id BIGINT, user_ref BIGINT NOT NULL, login_type TEXT DEFAULT 'local' NOT NULL, user_name TEXT, password TEXT, login_system TEXT, last_seen TEXT, PRIMARY KEY(id));
CREATE TABLE users_multimedia (id BIGSERIAL, person_user_ref BIGINT NOT NULL, object_ref BIGINT NOT NULL, category TEXT DEFAULT 'avatar' NOT NULL, PRIMARY KEY(id));
CREATE TABLE users_tracking (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id BIGINT NOT NULL, user_ref BIGINT NOT NULL, action TEXT DEFAULT 'insert' NOT NULL, modification_date_time TEXT NOT NULL, old_value TEXT, new_value TEXT, PRIMARY KEY(id));
CREATE TABLE users_workflow (id BIGSERIAL, referenced_relation TEXT NOT NULL, record_id BIGINT NOT NULL, user_ref BIGINT NOT NULL, status TEXT DEFAULT 'to check' NOT NULL, modification_date_time TEXT NOT NULL, comment TEXT, PRIMARY KEY(id));
CREATE TABLE vernacular_names (id BIGSERIAL, vernacular_class_ref BIGINT, name TEXT NOT NULL, name_indexed TEXT, name_ts TEXT, PRIMARY KEY(id));
ALTER TABLE associated_multimedia ADD CONSTRAINT associated_multimedia_multimedia_ref_multimedia_id FOREIGN KEY (multimedia_ref) REFERENCES multimedia(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE catalogue_people ADD CONSTRAINT catalogue_people_people_ref_people_id FOREIGN KEY (people_ref) REFERENCES people(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE chronostratigraphy ADD CONSTRAINT chronostratigraphy_parent_ref_chronostratigraphy_id FOREIGN KEY (parent_ref) REFERENCES chronostratigraphy(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE chronostratigraphy ADD CONSTRAINT chronostratigraphy_level_ref_catalogue_levels_id FOREIGN KEY (level_ref) REFERENCES catalogue_levels(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE collection_maintenance ADD CONSTRAINT collection_maintenance_people_ref_people_id FOREIGN KEY (people_ref) REFERENCES people(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE collections ADD CONSTRAINT collections_parent_ref_collections_id FOREIGN KEY (parent_ref) REFERENCES collections(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE collections ADD CONSTRAINT collections_main_manager_ref_users_id FOREIGN KEY (main_manager_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE collections ADD CONSTRAINT collections_institution_ref_people_id FOREIGN KEY (institution_ref) REFERENCES people(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE collections_admin ADD CONSTRAINT collections_admin_user_ref_users_id FOREIGN KEY (user_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE collections_admin ADD CONSTRAINT collections_admin_collection_ref_collections_id FOREIGN KEY (collection_ref) REFERENCES collections(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE collections_fields_visibilities ADD CONSTRAINT collections_fields_visibilities_user_ref_users_id FOREIGN KEY (user_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE collections_fields_visibilities ADD CONSTRAINT collections_fields_visibilities_collection_ref_collections_id FOREIGN KEY (collection_ref) REFERENCES collections(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE collections_rights ADD CONSTRAINT collections_rights_user_ref_users_id FOREIGN KEY (user_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE collections_rights ADD CONSTRAINT collections_rights_collection_ref_collections_id FOREIGN KEY (collection_ref) REFERENCES collections(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE gtu ADD CONSTRAINT gtu_parent_ref_gtu_id FOREIGN KEY (parent_ref) REFERENCES gtu(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE insurances ADD CONSTRAINT insurances_insurer_ref_people_id FOREIGN KEY (insurer_ref) REFERENCES people(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE lithology ADD CONSTRAINT lithology_parent_ref_lithology_id FOREIGN KEY (parent_ref) REFERENCES lithology(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE lithology ADD CONSTRAINT lithology_level_ref_catalogue_levels_id FOREIGN KEY (level_ref) REFERENCES catalogue_levels(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE lithostratigraphy ADD CONSTRAINT lithostratigraphy_parent_ref_lithostratigraphy_id FOREIGN KEY (parent_ref) REFERENCES lithostratigraphy(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE lithostratigraphy ADD CONSTRAINT lithostratigraphy_level_ref_catalogue_levels_id FOREIGN KEY (level_ref) REFERENCES catalogue_levels(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE mineralogy ADD CONSTRAINT mineralogy_parent_ref_mineralogy_id FOREIGN KEY (parent_ref) REFERENCES mineralogy(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE mineralogy ADD CONSTRAINT mineralogy_level_ref_catalogue_levels_id FOREIGN KEY (level_ref) REFERENCES catalogue_levels(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE multimedia ADD CONSTRAINT multimedia_parent_ref_multimedia_id FOREIGN KEY (parent_ref) REFERENCES multimedia(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE multimedia_keywords ADD CONSTRAINT multimedia_keywords_object_ref_multimedia_id FOREIGN KEY (object_ref) REFERENCES multimedia(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE my_saved_searches ADD CONSTRAINT my_saved_searches_user_ref_users_id FOREIGN KEY (user_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE my_widgets ADD CONSTRAINT my_widgets_user_ref_users_id FOREIGN KEY (user_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE my_widgets ADD CONSTRAINT my_widgets_icon_ref_multimedia_id FOREIGN KEY (icon_ref) REFERENCES multimedia(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE people_addresses ADD CONSTRAINT people_addresses_person_user_ref_people_id FOREIGN KEY (person_user_ref) REFERENCES people(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE people_comm ADD CONSTRAINT people_comm_person_user_ref_people_id FOREIGN KEY (person_user_ref) REFERENCES people(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE people_languages ADD CONSTRAINT people_languages_people_ref_people_id FOREIGN KEY (people_ref) REFERENCES people(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE people_multimedia ADD CONSTRAINT people_multimedia_person_user_ref_people_id FOREIGN KEY (person_user_ref) REFERENCES people(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE people_multimedia ADD CONSTRAINT people_multimedia_object_ref_multimedia_id FOREIGN KEY (object_ref) REFERENCES multimedia(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE people_relationships ADD CONSTRAINT people_relationships_person_2_ref_people_id FOREIGN KEY (person_2_ref) REFERENCES people(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE people_relationships ADD CONSTRAINT people_relationships_person_1_ref_people_id FOREIGN KEY (person_1_ref) REFERENCES people(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE possible_upper_levels ADD CONSTRAINT possible_upper_levels_level_upper_ref_catalogue_levels_id FOREIGN KEY (level_upper_ref) REFERENCES catalogue_levels(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE possible_upper_levels ADD CONSTRAINT possible_upper_levels_level_ref_catalogue_levels_id FOREIGN KEY (level_ref) REFERENCES catalogue_levels(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE properties_values ADD CONSTRAINT properties_values_property_ref_catalogue_properties_id FOREIGN KEY (property_ref) REFERENCES catalogue_properties(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE record_visibilities ADD CONSTRAINT record_visibilities_user_ref_users_id FOREIGN KEY (user_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE soortenregister ADD CONSTRAINT soortenregister_taxa_ref_taxonomy_id FOREIGN KEY (taxa_ref) REFERENCES taxonomy(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE soortenregister ADD CONSTRAINT soortenregister_habitat_ref_habitats_id FOREIGN KEY (habitat_ref) REFERENCES habitats(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE soortenregister ADD CONSTRAINT soortenregister_gtu_ref_gtu_id FOREIGN KEY (gtu_ref) REFERENCES gtu(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimen_individuals ADD CONSTRAINT specimen_individuals_specimen_ref_specimens_id FOREIGN KEY (specimen_ref) REFERENCES specimens(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimen_parts ADD CONSTRAINT specimen_parts_specimen_individual_ref_specimen_individuals_id FOREIGN KEY (specimen_individual_ref) REFERENCES specimen_individuals(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimen_parts ADD CONSTRAINT specimen_parts_parent_ref_specimen_parts_id FOREIGN KEY (parent_ref) REFERENCES specimen_parts(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens ADD CONSTRAINT specimens_taxon_ref_taxonomy_id FOREIGN KEY (taxon_ref) REFERENCES taxonomy(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens ADD CONSTRAINT specimens_mineral_ref_mineralogy_id FOREIGN KEY (mineral_ref) REFERENCES mineralogy(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens ADD CONSTRAINT specimens_lithology_ref_lithology_id FOREIGN KEY (lithology_ref) REFERENCES lithology(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens ADD CONSTRAINT specimens_litho_ref_lithostratigraphy_id FOREIGN KEY (litho_ref) REFERENCES lithostratigraphy(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens ADD CONSTRAINT specimens_ig_ref_igs_id FOREIGN KEY (ig_ref) REFERENCES igs(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens ADD CONSTRAINT specimens_host_taxon_ref_taxonomy_id FOREIGN KEY (host_taxon_ref) REFERENCES taxonomy(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens ADD CONSTRAINT specimens_host_specimen_ref_specimens_id FOREIGN KEY (host_specimen_ref) REFERENCES specimens(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens ADD CONSTRAINT specimens_gtu_ref_gtu_id FOREIGN KEY (gtu_ref) REFERENCES gtu(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens ADD CONSTRAINT specimens_expedition_ref_expeditions_id FOREIGN KEY (expedition_ref) REFERENCES expeditions(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens ADD CONSTRAINT specimens_collection_ref_collections_id FOREIGN KEY (collection_ref) REFERENCES collections(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens ADD CONSTRAINT specimens_chrono_ref_chronostratigraphy_id FOREIGN KEY (chrono_ref) REFERENCES chronostratigraphy(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens_accompanying ADD CONSTRAINT specimens_accompanying_taxon_ref_taxonomy_id FOREIGN KEY (taxon_ref) REFERENCES taxonomy(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens_accompanying ADD CONSTRAINT specimens_accompanying_specimen_ref_specimens_id FOREIGN KEY (specimen_ref) REFERENCES specimens(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimens_accompanying ADD CONSTRAINT specimens_accompanying_mineral_ref_mineralogy_id FOREIGN KEY (mineral_ref) REFERENCES mineralogy(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE codes ADD CONSTRAINT codes_record_id_specimens_id FOREIGN KEY (record_id) REFERENCES specimens(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimen_collecting_methods ADD CONSTRAINT specimen_collecting_methods_specimen_ref_specimens_id FOREIGN KEY (specimen_ref) REFERENCES specimens(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimen_collecting_methods ADD CONSTRAINT scci FOREIGN KEY (collecting_method_ref) REFERENCES collecting_methods(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimen_collecting_tools ADD CONSTRAINT specimen_collecting_tools_specimen_ref_specimens_id FOREIGN KEY (specimen_ref) REFERENCES specimens(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE specimen_collecting_tools ADD CONSTRAINT scci_1 FOREIGN KEY (collecting_tool_ref) REFERENCES collecting_tools(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE tag_groups ADD CONSTRAINT tag_groups_gtu_ref_gtu_id FOREIGN KEY (gtu_ref) REFERENCES gtu(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE tags ADD CONSTRAINT tags_gtu_ref_gtu_id FOREIGN KEY (gtu_ref) REFERENCES gtu(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE tags ADD CONSTRAINT tags_group_ref_tag_groups_id FOREIGN KEY (group_ref) REFERENCES tag_groups(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE taxonomy ADD CONSTRAINT taxonomy_parent_ref_taxonomy_id FOREIGN KEY (parent_ref) REFERENCES taxonomy(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE taxonomy ADD CONSTRAINT taxonomy_level_ref_catalogue_levels_id FOREIGN KEY (level_ref) REFERENCES catalogue_levels(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users ADD CONSTRAINT users_people_id_people_id FOREIGN KEY (people_id) REFERENCES people(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_addresses ADD CONSTRAINT users_addresses_person_user_ref_users_id FOREIGN KEY (person_user_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_coll_rights_asked ADD CONSTRAINT users_coll_rights_asked_user_ref_users_id FOREIGN KEY (user_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_coll_rights_asked ADD CONSTRAINT users_coll_rights_asked_collection_ref_collections_id FOREIGN KEY (collection_ref) REFERENCES collections(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_comm ADD CONSTRAINT users_comm_person_user_ref_users_id FOREIGN KEY (person_user_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_languages ADD CONSTRAINT users_languages_users_ref_users_id FOREIGN KEY (users_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_login_infos ADD CONSTRAINT users_login_infos_user_ref_users_id FOREIGN KEY (user_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_multimedia ADD CONSTRAINT users_multimedia_person_user_ref_users_id FOREIGN KEY (person_user_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_multimedia ADD CONSTRAINT users_multimedia_object_ref_multimedia_id FOREIGN KEY (object_ref) REFERENCES multimedia(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_tracking ADD CONSTRAINT users_tracking_user_ref_users_id FOREIGN KEY (user_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE users_workflow ADD CONSTRAINT users_workflow_user_ref_users_id FOREIGN KEY (user_ref) REFERENCES users(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE vernacular_names ADD CONSTRAINT vernacular_names_vernacular_class_ref_class_vernacular_names_id FOREIGN KEY (vernacular_class_ref) REFERENCES class_vernacular_names(id) NOT DEFERRABLE INITIALLY IMMEDIATE;
