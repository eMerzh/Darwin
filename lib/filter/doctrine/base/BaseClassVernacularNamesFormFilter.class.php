<?php

/**
 * ClassVernacularNames filter form base class.
 *
 * @package    darwin
 * @subpackage filter
 * @author     DB team <collections@naturalsciences.be>
 * @version    SVN: $Id: sfDoctrineFormFilterGeneratedTemplate.php 29570 2010-05-21 14:49:47Z Kris.Wallsmith $
 */
abstract class BaseClassVernacularNamesFormFilter extends BaseFormFilterDoctrine
{
  public function setup()
  {
    $this->setWidgets(array(
      'referenced_relation' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'record_id'           => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('SpecimenSearch'), 'add_empty' => true)),
      'community'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
    ));

    $this->setValidators(array(
      'referenced_relation' => new sfValidatorPass(array('required' => false)),
      'record_id'           => new sfValidatorDoctrineChoice(array('required' => false, 'model' => $this->getRelatedModelName('SpecimenSearch'), 'column' => 'id')),
      'community'           => new sfValidatorPass(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('class_vernacular_names_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    $this->setupInheritance();

    parent::setup();
  }

  public function getModelName()
  {
    return 'ClassVernacularNames';
  }

  public function getFields()
  {
    return array(
      'id'                  => 'Number',
      'referenced_relation' => 'Text',
      'record_id'           => 'ForeignKey',
      'community'           => 'Text',
    );
  }
}
