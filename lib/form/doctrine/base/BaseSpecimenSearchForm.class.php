<?php

/**
 * SpecimenSearch form base class.
 *
 * @method SpecimenSearch getObject() Returns the current form's model object
 *
 * @package    darwin
 * @subpackage form
 * @author     DB team <collections@naturalsciences.be>
 * @version    SVN: $Id: sfDoctrineFormGeneratedTemplate.php 29553 2010-05-20 14:33:00Z Kris.Wallsmith $
 */
abstract class BaseSpecimenSearchForm extends BaseFormDoctrine
{
  public function setup()
  {
    $this->setWidgets(array(
      'spec_ref'                                      => new sfWidgetFormInputHidden(),
      'category'                                      => new sfWidgetFormTextarea(),
      'collection_ref'                                => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('Collection'), 'add_empty' => false)),
      'collection_type'                               => new sfWidgetFormTextarea(),
      'collection_code'                               => new sfWidgetFormTextarea(),
      'collection_name'                               => new sfWidgetFormTextarea(),
      'collection_is_public'                          => new sfWidgetFormInputCheckbox(),
      'collection_institution_ref'                    => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('CollectionInstitution'), 'add_empty' => false)),
      'collection_institution_formated_name'          => new sfWidgetFormTextarea(),
      'collection_institution_formated_name_ts'       => new sfWidgetFormTextarea(),
      'collection_institution_formated_name_indexed'  => new sfWidgetFormTextarea(),
      'collection_institution_sub_type'               => new sfWidgetFormTextarea(),
      'collection_main_manager_ref'                   => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('CollectionMainManager'), 'add_empty' => false)),
      'collection_main_manager_formated_name'         => new sfWidgetFormTextarea(),
      'collection_main_manager_formated_name_ts'      => new sfWidgetFormTextarea(),
      'collection_main_manager_formated_name_indexed' => new sfWidgetFormTextarea(),
      'collection_parent_ref'                         => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('CollectionParent'), 'add_empty' => true)),
      'collection_path'                               => new sfWidgetFormTextarea(),
      'expedition_ref'                                => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('Expedition'), 'add_empty' => false)),
      'expedition_name'                               => new sfWidgetFormTextarea(),
      'expedition_name_ts'                            => new sfWidgetFormTextarea(),
      'expedition_name_indexed'                       => new sfWidgetFormTextarea(),
      'station_visible'                               => new sfWidgetFormInputCheckbox(),
      'gtu_ref'                                       => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('Gtu'), 'add_empty' => false)),
      'gtu_code'                                      => new sfWidgetFormTextarea(),
      'gtu_parent_ref'                                => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('GtuParent'), 'add_empty' => true)),
      'gtu_path'                                      => new sfWidgetFormTextarea(),
      'gtu_from_date_mask'                            => new sfWidgetFormInputText(),
      'gtu_from_date'                                 => new sfWidgetFormTextarea(),
      'gtu_to_date_mask'                              => new sfWidgetFormInputText(),
      'gtu_to_date'                                   => new sfWidgetFormTextarea(),
      'gtu_tag_values_indexed'                        => new sfWidgetFormTextarea(),
      'gtu_country_tag_value'                         => new sfWidgetFormTextarea(),
      'taxon_ref'                                     => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('Taxonomy'), 'add_empty' => false)),
      'taxon_name'                                    => new sfWidgetFormTextarea(),
      'taxon_name_indexed'                            => new sfWidgetFormTextarea(),
      'taxon_name_order_by'                           => new sfWidgetFormTextarea(),
      'taxon_level_ref'                               => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('TaxonomyLevel'), 'add_empty' => false)),
      'taxon_level_name'                              => new sfWidgetFormTextarea(),
      'taxon_status'                                  => new sfWidgetFormTextarea(),
      'taxon_path'                                    => new sfWidgetFormTextarea(),
      'taxon_parent_ref'                              => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('TaxonomyParent'), 'add_empty' => true)),
      'taxon_extinct'                                 => new sfWidgetFormInputCheckbox(),
      'litho_ref'                                     => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('Lithostratigraphy'), 'add_empty' => false)),
      'litho_name'                                    => new sfWidgetFormTextarea(),
      'litho_name_indexed'                            => new sfWidgetFormTextarea(),
      'litho_name_order_by'                           => new sfWidgetFormTextarea(),
      'litho_level_ref'                               => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('LithostratigraphyLevel'), 'add_empty' => false)),
      'litho_level_name'                              => new sfWidgetFormTextarea(),
      'litho_status'                                  => new sfWidgetFormTextarea(),
      'litho_path'                                    => new sfWidgetFormTextarea(),
      'litho_parent_ref'                              => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('LithostratigraphyParent'), 'add_empty' => true)),
      'chrono_ref'                                    => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('Chronostratigraphy'), 'add_empty' => false)),
      'chrono_name'                                   => new sfWidgetFormTextarea(),
      'chrono_name_indexed'                           => new sfWidgetFormTextarea(),
      'chrono_name_order_by'                          => new sfWidgetFormTextarea(),
      'chrono_level_ref'                              => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('ChronostratigraphyLevel'), 'add_empty' => false)),
      'chrono_level_name'                             => new sfWidgetFormTextarea(),
      'chrono_status'                                 => new sfWidgetFormTextarea(),
      'chrono_path'                                   => new sfWidgetFormTextarea(),
      'chrono_parent_ref'                             => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('ChronostratigraphyParent'), 'add_empty' => true)),
      'lithology_ref'                                 => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('Lithology'), 'add_empty' => false)),
      'lithology_name'                                => new sfWidgetFormTextarea(),
      'lithology_name_indexed'                        => new sfWidgetFormTextarea(),
      'lithology_name_order_by'                       => new sfWidgetFormTextarea(),
      'lithology_level_ref'                           => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('LithologyLevel'), 'add_empty' => false)),
      'lithology_level_name'                          => new sfWidgetFormTextarea(),
      'lithology_status'                              => new sfWidgetFormTextarea(),
      'lithology_path'                                => new sfWidgetFormTextarea(),
      'lithology_parent_ref'                          => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('LithologyParent'), 'add_empty' => true)),
      'mineral_ref'                                   => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('Mineralogy'), 'add_empty' => false)),
      'mineral_name'                                  => new sfWidgetFormTextarea(),
      'mineral_name_indexed'                          => new sfWidgetFormTextarea(),
      'mineral_name_order_by'                         => new sfWidgetFormTextarea(),
      'mineral_level_ref'                             => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('MineralogyLevel'), 'add_empty' => false)),
      'mineral_level_name'                            => new sfWidgetFormTextarea(),
      'mineral_status'                                => new sfWidgetFormTextarea(),
      'mineral_path'                                  => new sfWidgetFormTextarea(),
      'mineral_parent_ref'                            => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('MineralogyParent'), 'add_empty' => true)),
      'host_taxon_ref'                                => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('HostTaxon'), 'add_empty' => false)),
      'host_relationship'                             => new sfWidgetFormTextarea(),
      'host_taxon_name'                               => new sfWidgetFormTextarea(),
      'host_taxon_name_indexed'                       => new sfWidgetFormTextarea(),
      'host_taxon_name_order_by'                      => new sfWidgetFormTextarea(),
      'host_taxon_level_ref'                          => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('HostTaxonLevel'), 'add_empty' => false)),
      'host_taxon_level_name'                         => new sfWidgetFormTextarea(),
      'host_taxon_status'                             => new sfWidgetFormTextarea(),
      'host_taxon_path'                               => new sfWidgetFormTextarea(),
      'host_taxon_parent_ref'                         => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('HostTaxonParent'), 'add_empty' => true)),
      'host_taxon_extinct'                            => new sfWidgetFormInputCheckbox(),
      'ig_ref'                                        => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('Ig'), 'add_empty' => true)),
      'ig_num'                                        => new sfWidgetFormTextarea(),
      'ig_num_indexed'                                => new sfWidgetFormTextarea(),
      'ig_date_mask'                                  => new sfWidgetFormInputText(),
      'ig_date'                                       => new sfWidgetFormTextarea(),
      'acquisition_category'                          => new sfWidgetFormTextarea(),
      'acquisition_date_mask'                         => new sfWidgetFormInputText(),
      'acquisition_date'                              => new sfWidgetFormTextarea(),
      'specimen_count_min'                            => new sfWidgetFormInputText(),
      'specimen_count_max'                            => new sfWidgetFormInputText(),
      'individual_ref'                                => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('SpecimenIndividual'), 'add_empty' => true)),
      'individual_type'                               => new sfWidgetFormTextarea(),
      'individual_type_group'                         => new sfWidgetFormTextarea(),
      'individual_type_search'                        => new sfWidgetFormTextarea(),
      'individual_sex'                                => new sfWidgetFormTextarea(),
      'individual_state'                              => new sfWidgetFormTextarea(),
      'individual_stage'                              => new sfWidgetFormTextarea(),
      'individual_social_status'                      => new sfWidgetFormTextarea(),
      'individual_rock_form'                          => new sfWidgetFormTextarea(),
      'individual_count_min'                          => new sfWidgetFormInputText(),
      'individual_count_max'                          => new sfWidgetFormInputText(),
      'part_ref'                                      => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('Part'), 'add_empty' => true)),
      'part'                                          => new sfWidgetFormTextarea(),
      'part_status'                                   => new sfWidgetFormTextarea(),
      'building'                                      => new sfWidgetFormTextarea(),
      'floor'                                         => new sfWidgetFormTextarea(),
      'room'                                          => new sfWidgetFormTextarea(),
      'row'                                           => new sfWidgetFormTextarea(),
      'shelf'                                         => new sfWidgetFormTextarea(),
      'container_type'                                => new sfWidgetFormTextarea(),
      'container_storage'                             => new sfWidgetFormTextarea(),
      'container'                                     => new sfWidgetFormTextarea(),
      'sub_container_type'                            => new sfWidgetFormTextarea(),
      'sub_container_storage'                         => new sfWidgetFormTextarea(),
      'sub_container'                                 => new sfWidgetFormTextarea(),
      'part_count_min'                                => new sfWidgetFormInputText(),
      'part_count_max'                                => new sfWidgetFormInputText(),
    ));

    $this->setValidators(array(
      'spec_ref'                                      => new sfValidatorChoice(array('choices' => array($this->getObject()->get('spec_ref')), 'empty_value' => $this->getObject()->get('spec_ref'), 'required' => false)),
      'category'                                      => new sfValidatorString(array('required' => false)),
      'collection_ref'                                => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('Collection'), 'required' => false)),
      'collection_type'                               => new sfValidatorString(array('required' => false)),
      'collection_code'                               => new sfValidatorString(array('required' => false)),
      'collection_name'                               => new sfValidatorString(array('required' => false)),
      'collection_is_public'                          => new sfValidatorBoolean(array('required' => false)),
      'collection_institution_ref'                    => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('CollectionInstitution'), 'required' => false)),
      'collection_institution_formated_name'          => new sfValidatorString(array('required' => false)),
      'collection_institution_formated_name_ts'       => new sfValidatorString(array('required' => false)),
      'collection_institution_formated_name_indexed'  => new sfValidatorString(array('required' => false)),
      'collection_institution_sub_type'               => new sfValidatorString(array('required' => false)),
      'collection_main_manager_ref'                   => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('CollectionMainManager'), 'required' => false)),
      'collection_main_manager_formated_name'         => new sfValidatorString(array('required' => false)),
      'collection_main_manager_formated_name_ts'      => new sfValidatorString(array('required' => false)),
      'collection_main_manager_formated_name_indexed' => new sfValidatorString(array('required' => false)),
      'collection_parent_ref'                         => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('CollectionParent'), 'required' => false)),
      'collection_path'                               => new sfValidatorString(array('required' => false)),
      'expedition_ref'                                => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('Expedition'), 'required' => false)),
      'expedition_name'                               => new sfValidatorString(array('required' => false)),
      'expedition_name_ts'                            => new sfValidatorString(array('required' => false)),
      'expedition_name_indexed'                       => new sfValidatorString(array('required' => false)),
      'station_visible'                               => new sfValidatorBoolean(array('required' => false)),
      'gtu_ref'                                       => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('Gtu'), 'required' => false)),
      'gtu_code'                                      => new sfValidatorString(array('required' => false)),
      'gtu_parent_ref'                                => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('GtuParent'), 'required' => false)),
      'gtu_path'                                      => new sfValidatorString(array('required' => false)),
      'gtu_from_date_mask'                            => new sfValidatorInteger(array('required' => false)),
      'gtu_from_date'                                 => new sfValidatorString(array('required' => false)),
      'gtu_to_date_mask'                              => new sfValidatorInteger(array('required' => false)),
      'gtu_to_date'                                   => new sfValidatorString(array('required' => false)),
      'gtu_tag_values_indexed'                        => new sfValidatorString(array('required' => false)),
      'gtu_country_tag_value'                         => new sfValidatorString(array('required' => false)),
      'taxon_ref'                                     => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('Taxonomy'), 'required' => false)),
      'taxon_name'                                    => new sfValidatorString(array('required' => false)),
      'taxon_name_indexed'                            => new sfValidatorString(array('required' => false)),
      'taxon_name_order_by'                           => new sfValidatorString(array('required' => false)),
      'taxon_level_ref'                               => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('TaxonomyLevel'))),
      'taxon_level_name'                              => new sfValidatorString(array('required' => false)),
      'taxon_status'                                  => new sfValidatorString(array('required' => false)),
      'taxon_path'                                    => new sfValidatorString(array('required' => false)),
      'taxon_parent_ref'                              => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('TaxonomyParent'), 'required' => false)),
      'taxon_extinct'                                 => new sfValidatorBoolean(array('required' => false)),
      'litho_ref'                                     => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('Lithostratigraphy'), 'required' => false)),
      'litho_name'                                    => new sfValidatorString(array('required' => false)),
      'litho_name_indexed'                            => new sfValidatorString(array('required' => false)),
      'litho_name_order_by'                           => new sfValidatorString(array('required' => false)),
      'litho_level_ref'                               => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('LithostratigraphyLevel'), 'required' => false)),
      'litho_level_name'                              => new sfValidatorString(array('required' => false)),
      'litho_status'                                  => new sfValidatorString(array('required' => false)),
      'litho_path'                                    => new sfValidatorString(array('required' => false)),
      'litho_parent_ref'                              => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('LithostratigraphyParent'), 'required' => false)),
      'chrono_ref'                                    => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('Chronostratigraphy'), 'required' => false)),
      'chrono_name'                                   => new sfValidatorString(array('required' => false)),
      'chrono_name_indexed'                           => new sfValidatorString(array('required' => false)),
      'chrono_name_order_by'                          => new sfValidatorString(array('required' => false)),
      'chrono_level_ref'                              => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('ChronostratigraphyLevel'), 'required' => false)),
      'chrono_level_name'                             => new sfValidatorString(array('required' => false)),
      'chrono_status'                                 => new sfValidatorString(array('required' => false)),
      'chrono_path'                                   => new sfValidatorString(array('required' => false)),
      'chrono_parent_ref'                             => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('ChronostratigraphyParent'), 'required' => false)),
      'lithology_ref'                                 => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('Lithology'), 'required' => false)),
      'lithology_name'                                => new sfValidatorString(array('required' => false)),
      'lithology_name_indexed'                        => new sfValidatorString(array('required' => false)),
      'lithology_name_order_by'                       => new sfValidatorString(array('required' => false)),
      'lithology_level_ref'                           => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('LithologyLevel'), 'required' => false)),
      'lithology_level_name'                          => new sfValidatorString(array('required' => false)),
      'lithology_status'                              => new sfValidatorString(array('required' => false)),
      'lithology_path'                                => new sfValidatorString(array('required' => false)),
      'lithology_parent_ref'                          => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('LithologyParent'), 'required' => false)),
      'mineral_ref'                                   => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('Mineralogy'), 'required' => false)),
      'mineral_name'                                  => new sfValidatorString(array('required' => false)),
      'mineral_name_indexed'                          => new sfValidatorString(array('required' => false)),
      'mineral_name_order_by'                         => new sfValidatorString(array('required' => false)),
      'mineral_level_ref'                             => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('MineralogyLevel'), 'required' => false)),
      'mineral_level_name'                            => new sfValidatorString(array('required' => false)),
      'mineral_status'                                => new sfValidatorString(array('required' => false)),
      'mineral_path'                                  => new sfValidatorString(array('required' => false)),
      'mineral_parent_ref'                            => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('MineralogyParent'), 'required' => false)),
      'host_taxon_ref'                                => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('HostTaxon'), 'required' => false)),
      'host_relationship'                             => new sfValidatorString(array('required' => false)),
      'host_taxon_name'                               => new sfValidatorString(array('required' => false)),
      'host_taxon_name_indexed'                       => new sfValidatorString(array('required' => false)),
      'host_taxon_name_order_by'                      => new sfValidatorString(array('required' => false)),
      'host_taxon_level_ref'                          => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('HostTaxonLevel'), 'required' => false)),
      'host_taxon_level_name'                         => new sfValidatorString(array('required' => false)),
      'host_taxon_status'                             => new sfValidatorString(array('required' => false)),
      'host_taxon_path'                               => new sfValidatorString(array('required' => false)),
      'host_taxon_parent_ref'                         => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('HostTaxonParent'), 'required' => false)),
      'host_taxon_extinct'                            => new sfValidatorBoolean(array('required' => false)),
      'ig_ref'                                        => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('Ig'), 'required' => false)),
      'ig_num'                                        => new sfValidatorString(array('required' => false)),
      'ig_num_indexed'                                => new sfValidatorString(array('required' => false)),
      'ig_date_mask'                                  => new sfValidatorInteger(array('required' => false)),
      'ig_date'                                       => new sfValidatorString(array('required' => false)),
      'acquisition_category'                          => new sfValidatorString(array('required' => false)),
      'acquisition_date_mask'                         => new sfValidatorInteger(array('required' => false)),
      'acquisition_date'                              => new sfValidatorString(array('required' => false)),
      'specimen_count_min'                            => new sfValidatorInteger(array('required' => false)),
      'specimen_count_max'                            => new sfValidatorInteger(array('required' => false)),
      'individual_ref'                                => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('SpecimenIndividual'), 'required' => false)),
      'individual_type'                               => new sfValidatorString(array('required' => false)),
      'individual_type_group'                         => new sfValidatorString(array('required' => false)),
      'individual_type_search'                        => new sfValidatorString(array('required' => false)),
      'individual_sex'                                => new sfValidatorString(array('required' => false)),
      'individual_state'                              => new sfValidatorString(array('required' => false)),
      'individual_stage'                              => new sfValidatorString(array('required' => false)),
      'individual_social_status'                      => new sfValidatorString(array('required' => false)),
      'individual_rock_form'                          => new sfValidatorString(array('required' => false)),
      'individual_count_min'                          => new sfValidatorInteger(array('required' => false)),
      'individual_count_max'                          => new sfValidatorInteger(array('required' => false)),
      'part_ref'                                      => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('Part'), 'required' => false)),
      'part'                                          => new sfValidatorString(array('required' => false)),
      'part_status'                                   => new sfValidatorString(array('required' => false)),
      'building'                                      => new sfValidatorString(array('required' => false)),
      'floor'                                         => new sfValidatorString(array('required' => false)),
      'room'                                          => new sfValidatorString(array('required' => false)),
      'row'                                           => new sfValidatorString(array('required' => false)),
      'shelf'                                         => new sfValidatorString(array('required' => false)),
      'container_type'                                => new sfValidatorString(array('required' => false)),
      'container_storage'                             => new sfValidatorString(array('required' => false)),
      'container'                                     => new sfValidatorString(array('required' => false)),
      'sub_container_type'                            => new sfValidatorString(array('required' => false)),
      'sub_container_storage'                         => new sfValidatorString(array('required' => false)),
      'sub_container'                                 => new sfValidatorString(array('required' => false)),
      'part_count_min'                                => new sfValidatorInteger(array('required' => false)),
      'part_count_max'                                => new sfValidatorInteger(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('specimen_search[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    $this->setupInheritance();

    parent::setup();
  }

  public function getModelName()
  {
    return 'SpecimenSearch';
  }

}
