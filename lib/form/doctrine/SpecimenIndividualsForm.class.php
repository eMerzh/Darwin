<?php

/**
 * SpecimenIndividuals form.
 *
 * @package    form
 * @subpackage SpecimenIndividuals
 * @version    SVN: $Id: sfDoctrineFormTemplate.php 6174 2007-11-27 06:22:40Z fabien $
 */
class SpecimenIndividualsForm extends BaseSpecimenIndividualsForm
{
  public function configure()
  { 
    unset($this['type_group'], $this['type_search']);
    $this->widgetSchema['id'] = new sfWidgetFormInputHidden();
    $this->widgetSchema['specimen_ref'] = new sfWidgetFormInputHidden();
    $this->widgetSchema['type'] = new widgetFormSelectComplete(array(
        'model' => 'SpecimenIndividuals',
        'table_method' => 'getDistinctTypes',
        'method' => 'getType',
        'key_method' => 'getType',
        'add_empty' => false,
        'change_label' => 'Pick a type in the list',
        'add_label' => 'Add an other type',
    ));
    $this->widgetSchema['sex'] = new widgetFormSelectComplete(array(
        'model' => 'SpecimenIndividuals',
        'table_method' => 'getDistinctSexes',
        'method' => 'getSex',
        'key_method' => 'getSex',
        'add_empty' => false,
        'change_label' => 'Pick a sex in the list',
        'add_label' => 'Add an other sex',
    ));
    $this->widgetSchema['state'] = new widgetFormSelectComplete(array(
        'model' => 'SpecimenIndividuals',
        'table_method' => 'getDistinctStates',
        'method' => 'getState',
        'key_method' => 'getState',
        'add_empty' => false,
        'change_label' => 'Pick a "sexual" state in the list',
        'add_label' => 'Add an other "sexual" state',
    ));
    $this->widgetSchema['stage'] = new widgetFormSelectComplete(array(
        'model' => 'SpecimenIndividuals',
        'table_method' => 'getDistinctStages',
        'method' => 'getStage',
        'key_method' => 'getStage',
        'add_empty' => false,
        'change_label' => 'Pick a stage in the list',
        'add_label' => 'Add an other stage',
    ));
    $this->widgetSchema['social_status'] = new widgetFormSelectComplete(array(
        'model' => 'SpecimenIndividuals',
        'table_method' => 'getDistinctSocialStatuses',
        'method' => 'getSocialStatus',
        'key_method' => 'getSocialStatus',
        'add_empty' => false,
        'change_label' => 'Pick a social status in the list',
        'add_label' => 'Add an other social status',
    ));
    $this->widgetSchema['rock_form'] = new widgetFormSelectComplete(array(
        'model' => 'SpecimenIndividuals',
        'table_method' => 'getDistinctRockForms',
        'method' => 'getRockForm',
        'key_method' => 'getRockForm',
        'add_empty' => false,
        'change_label' => 'Pick a rock form in the list',
        'add_label' => 'Add an other rock form',
    ));

    $this->widgetSchema['accuracy'] = new sfWidgetFormChoice(array(
        'choices'  => array($this->getI18N()->__('exact'), $this->getI18N()->__('imprecise')),
        'expanded' => true,
    ));

    $this->setDefault('accuracy', 1);
    $this->widgetSchema['accuracy']->setLabel('Accuracy');

    /* Identifications sub form */
    
    $subForm = new sfForm();
    $this->embedForm('Identifications',$subForm);   
    foreach(Doctrine::getTable('Identifications')->getIdentificationsRelated('specimen_individuals', $this->getObject()->getId()) as $key=>$vals)
    {
      $form = new IdentificationsForm($vals);
      $this->embeddedForms['Identifications']->embedForm($key, $form);
    }
    //Re-embedding the container
    $this->embedForm('Identifications', $this->embeddedForms['Identifications']);

    $subForm = new sfForm();
    $this->embedForm('newIdentification',$subForm);


    $this->widgetSchema['ident'] = new sfWidgetFormInputHidden(array('default'=>1));

    /* Comments sub form */
    
    $subForm = new sfForm();
    $this->embedForm('Comments',$subForm);   
    foreach(Doctrine::getTable('comments')->findForTable('specimen_individuals', $this->getObject()->getId()) as $key=>$vals)
    {
      $form = new CommentsForm($vals,array('table' => 'individuals'));
      $this->embeddedForms['Comments']->embedForm($key, $form);
    }
    //Re-embedding the container
    $this->embedForm('Comments', $this->embeddedForms['Comments']);

    $subForm = new sfForm();
    $this->embedForm('newComments',$subForm);
    
    $this->widgetSchema['comment'] = new sfWidgetFormInputHidden(array('default'=>1));

    /* Validators */

    $this->validatorSchema['id'] = new sfValidatorInteger(array('required'=>false));
    $this->validatorSchema['specimen_ref'] = new sfValidatorInteger(array('required'=>false));
    $this->validatorSchema['type'] = new sfValidatorString(array('trim'=>true, 'required'=>false, 'empty_value'=>$this->getDefault('type')));
    $this->validatorSchema['sex'] = new sfValidatorString(array('trim'=>true, 'required'=>false, 'empty_value'=>$this->getDefault('sex')));
    $this->validatorSchema['stage'] = new sfValidatorString(array('trim'=>true, 'required'=>false, 'empty_value'=>$this->getDefault('stage')));
    $this->validatorSchema['state'] = new sfValidatorString(array('trim'=>true, 'required'=>false, 'empty_value'=>$this->getDefault('state')));
    $this->validatorSchema['social_status'] = new sfValidatorString(array('trim'=>true, 'required'=>false, 'empty_value'=>$this->getDefault('social_status')));
    $this->validatorSchema['rock_form'] = new sfValidatorString(array('trim'=>true, 'required'=>false, 'empty_value'=>$this->getDefault('rock_form')));
    $this->validatorSchema['accuracy'] = new sfValidatorChoice(array(
        'choices' => array(0,1),
        'required' => false,
        ));
	$this->setEmptyToObjectValue();
    $this->validatorSchema['ident'] = new sfValidatorPass();
    $this->validatorSchema['comment'] = new sfValidatorPass();
  }
  public function addIdentifications($num, $order_by=0)
  {
      $options = array('referenced_relation' => 'specimen_individuals', 'order_by' => $order_by);
      $val = new Identifications();
      $val->fromArray($options);
      $val->setRecordId($this->getObject()->getId());
      $form = new IdentificationsForm($val);
      $this->embeddedForms['newIdentification']->embedForm($num, $form);
      //Re-embedding the container
      $this->embedForm('newIdentification', $this->embeddedForms['newIdentification']);
  }

  public function reembedIdentifications ($identification, $identification_number)
  {
      $this->getEmbeddedForm('Identifications')->embedForm($identification_number, $identification);
      $this->embedForm('Identifications', $this->embeddedForms['Identifications']);
  }

  public function reembedNewIdentification ($identification, $identification_number)
  {
      $this->getEmbeddedForm('newIdentification')->embedForm($identification_number, $identification);
      $this->embedForm('newIdentification', $this->embeddedForms['newIdentification']);
  }

  public function addComments($num)
  {
      $options = array('referenced_relation' => 'specimen_individuals', 'record_id' => $this->getObject()->getId());
      $val = new Comments();
      $val->fromArray($options);
      $val->setRecordId($this->getObject()->getId());
      $form = new CommentsForm($val,array('table' => 'individuals'));
      $this->embeddedForms['newComments']->embedForm($num, $form);
      //Re-embedding the container
      $this->embedForm('newComments', $this->embeddedForms['newComments']);
  }
  
  public function bind(array $taintedValues = null, array $taintedFiles = null)
  {
    if(isset($taintedValues['newIdentification']) && isset($taintedValues['ident']))
    {
	foreach($taintedValues['newIdentification'] as $key=>$newVal)
	{
	  if (!isset($this['newIdentification'][$key]))
	  {
	    $this->addIdentifications($key);
            if(isset($taintedValues['newIdentification'][$key]['newIdentifier']))
            {
              foreach($taintedValues['newIdentification'][$key]['newIdentifier'] as $ikey=>$ival)
              {
                if(!isset($this['newIdentification'][$key]['newIdentifier'][$ikey]))
	        {
                  $identification = $this->getEmbeddedForm('newIdentification')->getEmbeddedForm($key);
                  $identification->addIdentifiers($ikey, $ival['order_by']);
                  $this->reembedNewIdentification($identification, $key);
                }
                $taintedValues['newIdentification'][$key]['newIdentifier'][$ikey]['record_id'] = 0;
              }
	    }
          }
          $taintedValues['newIdentification'][$key]['record_id'] = 0;
	}
    }

    if(isset($taintedValues['Identifications']) && isset($taintedValues['ident']))
    {
	foreach($taintedValues['Identifications'] as $key=>$newval)
	{
          if(isset($newval['newIdentifier']))
            {
              foreach($taintedValues['Identifications'][$key]['newIdentifier'] as $ikey=>$ival)
              {
                if(!isset($this['Identifications'][$key]['newIdentifier'][$ikey]))
	        {
                  $identification = $this->getEmbeddedForm('Identifications')->getEmbeddedForm($key);
                  $identification->addIdentifiers($ikey, $ival['order_by']);
                  $this->reembedIdentifications($identification, $key);
                }
                $taintedValues['Identifications'][$key]['newIdentifier'][$ikey]['record_id'] = 0;
              }
            }
	}
    }
    if(isset($taintedValues['newComments']) && isset($taintedValues['comment']))
    {
     foreach($taintedValues['newComments'] as $key=>$newVal)
	{
	  if (!isset($this['newComments'][$key]))
	  {
	    $this->addComments($key);
	  }
       $taintedValues['newComments'][$key]['record_id'] = 0;
	}
    }
    if(!isset($taintedValues['ident']))
    {
      $this->offsetUnset('Identifications');
      unset($taintedValues['Identifications']);
    }
    if(!isset($taintedValues['comment']))
    {
      $this->offsetUnset('Comments');
      unset($taintedValues['Comments']);
    }
    parent::bind($taintedValues, $taintedFiles);
  }

  public function saveEmbeddedForms($con = null, $forms = null)
  {
    if (null === $forms && $this->getValue('ident'))
    {
	$value = $this->getValue('newIdentification');
	foreach($this->embeddedForms['newIdentification']->getEmbeddedForms() as $name => $form)
	{
	  if (!isset($value[$name]['value_defined']))
	  {
	    unset($this->embeddedForms['newIdentification'][$name]);
	  }
          else
          {
            $form->getObject()->setRecordId($this->getObject()->getId());
            $form->getObject()->save();
            $subvalue = $value[$name]['newIdentifier'];
            foreach($form->embeddedForms['newIdentifier']->getEmbeddedForms() as $subname => $subform)
            {
              if (!isset($subvalue[$subname]['people_ref']))
              {
                unset($form->embeddedForms['newIdentifier'][$subname]);
              }
              else
              {
                $subform->getObject()->setRecordId($form->getObject()->getId());
              }
            }
          }
	}
	$value = $this->getValue('Identifications');
	foreach($this->embeddedForms['Identifications']->getEmbeddedForms() as $name => $form)
	{
	  if (!isset($value[$name]['value_defined']))
	  {
	    $form->getObject()->delete();
	    unset($this->embeddedForms['Identifications'][$name]);
	  }
          else
          {
            $subvalue = $value[$name]['newIdentifier'];
            foreach($form->embeddedForms['newIdentifier']->getEmbeddedForms() as $subname => $subform)
            {
              if (!isset($subvalue[$subname]['people_ref']))
              {
                unset($form->embeddedForms['newIdentifier'][$subname]);
              }
              else
              {
                $subform->getObject()->setRecordId($form->getObject()->getId());
              }
            }
            $subvalue = $value[$name]['Identifiers'];
            foreach($form->embeddedForms['Identifiers']->getEmbeddedForms() as $subname => $subform)
            {
              if (!isset($subvalue[$subname]['people_ref']))
              {
                $subform->getObject()->delete();
                unset($form->embeddedForms['Identifiers'][$subname]);
              }
            }
          }
	}
    }
    if (null === $forms && $this->getValue('comment'))
    {
	$value = $this->getValue('newComments');
	foreach($this->embeddedForms['newComments']->getEmbeddedForms() as $name => $form)
	{
	  if($value[$name]['referenced_relation'] == "0")
	    unset($this->embeddedForms['newComments'][$name]);
	  else
	  {
	    $form->getObject()->setRecordId($this->getObject()->getId());
	    $form->getObject()->setReferencedRelation('specimen_individuals') ;      
	  }
	}
	$value = $this->getValue('Comments');
	foreach($this->embeddedForms['Comments']->getEmbeddedForms() as $name => $form)
	{	
	  if ($value[$name]['referenced_relation'] == "0")
	  {
	    $form->getObject()->delete();
	    unset($this->embeddedForms['Comments'][$name]);
	  }
	}
    }    
    return parent::saveEmbeddedForms($con, $forms);
  }  
}
