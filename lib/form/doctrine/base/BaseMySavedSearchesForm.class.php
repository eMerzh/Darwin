<?php

/**
 * MySavedSearches form base class.
 *
 * @method MySavedSearches getObject() Returns the current form's model object
 *
 * @package    darwin
 * @subpackage form
 * @author     DB team <collections@naturalsciences.be>
 * @version    SVN: $Id: sfDoctrineFormGeneratedTemplate.php 29553 2010-05-20 14:33:00Z Kris.Wallsmith $
 */
abstract class BaseMySavedSearchesForm extends BaseFormDoctrine
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                       => new sfWidgetFormInputHidden(),
      'user_ref'                 => new sfWidgetFormDoctrineChoice(array('model' => $this->getRelatedModelName('User'), 'add_empty' => false)),
      'name'                     => new sfWidgetFormTextarea(),
      'search_criterias'         => new sfWidgetFormTextarea(),
      'favorite'                 => new sfWidgetFormInputCheckbox(),
      'modification_date_time'   => new sfWidgetFormTextarea(),
      'visible_fields_in_result' => new sfWidgetFormTextarea(),
    ));

    $this->setValidators(array(
      'id'                       => new sfValidatorChoice(array('choices' => array($this->getObject()->get('id')), 'empty_value' => $this->getObject()->get('id'), 'required' => false)),
      'user_ref'                 => new sfValidatorDoctrineChoice(array('model' => $this->getRelatedModelName('User'))),
      'name'                     => new sfValidatorString(),
      'search_criterias'         => new sfValidatorString(),
      'favorite'                 => new sfValidatorBoolean(array('required' => false)),
      'modification_date_time'   => new sfValidatorString(),
      'visible_fields_in_result' => new sfValidatorString(),
    ));

    $this->widgetSchema->setNameFormat('my_saved_searches[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    $this->setupInheritance();

    parent::setup();
  }

  public function getModelName()
  {
    return 'MySavedSearches';
  }

}
