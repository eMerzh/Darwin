<?php

/**
 * Multimedia form.
 *
 * @package    darwin
 * @subpackage form
 * @author     DB team <darwin-ict@naturalsciences.be>
 * @version    SVN: $Id: sfDoctrineFormTemplate.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class MultimediaForm extends BaseMultimediaForm
{
  public function configure()
  {
    $this->useFields(array('referenced_relation','record_id', 'title','uri', 'description', 'type', 'creation_date', 'visible', 'publishable', 'filename', 'mime_type'));
    $this->widgetSchema['referenced_relation'] = new sfWidgetFormInputHidden();
    $this->validatorSchema['referenced_relation'] = new sfValidatorString(array('required'=>false));    
    $this->widgetSchema['record_id'] = new sfWidgetFormInputHidden();    
          
    $this->widgetSchema['title'] = new sfWidgetFormInput();
    $this->widgetSchema['title']->setAttributes(array('class'=>'medium_small_size'));
    $this->validatorSchema['title'] = new sfValidatorString();
    
    if($this->getObject()->isNew())
    {
      $this->widgetSchema['uri'] = new sfWidgetFormInputHidden();
      $this->validatorSchema['uri'] = new sfValidatorString();
    }
    else unset($this['uri']) ;
      
    $this->widgetSchema['description'] = new sfWidgetFormInput();    
    $this->widgetSchema['description']->setAttributes(array('class'=>'medium_small_size'));
    $this->validatorSchema['description'] = new sfValidatorString(array('required'=>false)); 

    $this->widgetSchema['filename'] = new sfWidgetFormInputHidden();
    $this->validatorSchema['filename'] = new sfValidatorPass();  
    
    $this->widgetSchema['mime_type'] = new sfWidgetFormInputHidden(); 
    $this->validatorSchema['mime_type'] = new sfValidatorString();     
    
    $this->widgetSchema['type'] = new sfWidgetFormInputHidden(); 
    $this->validatorSchema['type'] = new sfValidatorString(array('required'=>false));         
    
    $this->widgetSchema['creation_date'] = new sfWidgetFormInputHidden(); 
    $this->validatorSchema['creation_date'] = new sfValidatorPass();  
    
    $this->widgetSchema['visible'] = new sfWidgetFormInputCheckbox();
    $this->validatorSchema['visible'] = new sfValidatorBoolean();

    $this->widgetSchema['publishable'] = new sfWidgetFormInputCheckbox();
    $this->validatorSchema['publishable'] = new sfValidatorBoolean();

    /*Labels*/

    $this->widgetSchema->setLabels(array('title' => 'Name',
                                         'description' => 'Description',
                                         'creation_date' => 'Created At',
                                         'visible' => 'Visible ?',
                                         'publishable' => 'Publishable ?'
                                        )
                                  );

    $this->mergePostValidator(new MultimediaFileValidatorSchema());    
  }  

  public function updateObject($values = null)
  {
    $object = parent::updateObject($values);

    if($object->isNew())
      $object->changeUri();

    return $object;
  }

}
