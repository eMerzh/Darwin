<?php

/**
 * LoanItems form.
 *
 * @package    darwin
 * @subpackage form
 * @author     DB team <collections@naturalsciences.be>
 * @version    SVN: $Id: sfDoctrineFormTemplate.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class LoanItemWidgetForm extends BaseLoanItemsForm
{
  public function configure()
  {
    $this->useFields(array());

    $this->widgetSchema['comment'] = new sfWidgetFormInputHidden(array('default'=>1));
    $this->widgetSchema['sender'] = new sfWidgetFormInputHidden(array('default'=>1));    
    $this->widgetSchema['receiver'] = new sfWidgetFormInputHidden(array('default'=>1));        
    $this->widgetSchema['relatedfiles'] = new sfWidgetFormInputHidden(array('default'=>1));    
    $this->widgetSchema['insurance'] = new sfWidgetFormInputHidden(array('default'=>1));    

    $this->validatorSchema['comment'] = new sfValidatorPass();
    $this->validatorSchema['sender'] = new sfValidatorPass();
    $this->validatorSchema['receiver'] = new sfValidatorPass();    
    $this->validatorSchema['relatedfiles'] = new sfValidatorPass();
    $this->validatorSchema['insurance'] = new sfValidatorPass();
  }

  public function addActorsSender($num, $people_ref, $order_by=0)
  {
    if(! isset($this['newActorsSender'])) $this->loadEmbedActorsSender();
    $options = array('referenced_relation' => 'loans', 'people_ref' => $people_ref, 'people_type' => 'sender', 'order_by' => $order_by);
    $val = new CataloguePeople();
    $val->fromArray($options);
    $val->setRecordId($this->getObject()->getId());
    $form = new ActorsForm($val);
    $this->embeddedForms['newActorsSender']->embedForm($num, $form);
    //Re-embedding the container
    $this->embedForm('newActorsSender', $this->embeddedForms['newActorsSender']);
  }

  public function loadEmbedActorsSender()
  {
    if($this->isBound()) return;
    /* Comments sub form */
    $subForm = new sfForm();
    $this->embedForm('ActorsSender',$subForm);    
    if($this->getObject()->getId() !='')
    {
      foreach(Doctrine::getTable('CataloguePeople')->findActors($this->getObject()->getId(),'sender') as $key=>$vals)
      {
        $form = new ActorsForm($vals);
        $this->embeddedForms['ActorsSender']->embedForm($key, $form);
      }
      //Re-embedding the container
      $this->embedForm('ActorsSender', $this->embeddedForms['ActorsSender']);
    }

    $subForm = new sfForm();
    $this->embedForm('newActorsSender',$subForm);
  } 

  public function addActorsReceiver($num, $people_ref, $order_by=0)
  {
    if(! isset($this['newActorsReceiver'])) $this->loadEmbedActorsReceiver();
    $options = array('referenced_relation' => 'loans', 'people_ref' => $people_ref, 'people_type' => 'receiver', 'order_by' => $order_by);
    $val = new CataloguePeople();     
    $val->fromArray($options);
    $val->setRecordId($this->getObject()->getId());
    $form = new ActorsForm($val);
    $this->embeddedForms['newActorsReceiver']->embedForm($num, $form);
    //Re-embedding the container
    $this->embedForm('newActorsReceiver', $this->embeddedForms['newActorsReceiver']);
  }
   
  public function loadEmbedActorsReceiver()
  {
    if($this->isBound()) return;
    /* Comments sub form */
    $subForm = new sfForm();
    $this->embedForm('ActorsReceiver',$subForm);    
    if($this->getObject()->getId() !='')
    {
      foreach(Doctrine::getTable('CataloguePeople')->findActors($this->getObject()->getId(),'receiver') as $key=>$vals)
      {
        $form = new ActorsForm($vals);
        $this->embeddedForms['ActorsReceiver']->embedForm($key, $form);
      }
      //Re-embedding the container
      $this->embedForm('ActorsReceiver', $this->embeddedForms['ActorsReceiver']);
    }

    $subForm = new sfForm();
    $this->embedForm('newActorsReceiver',$subForm);
  }
  
  public function addInsurances($num, $obj=null)
  {
    if(! isset($this['newInsurance'])) $this->loadEmbedInsurance();
    $options = array('referenced_relation' => 'loans');
    if(!$obj) $val = new Insurances();
    else $val = $obj ;
    $val->fromArray($options);
    $val->setRecordId($this->getObject()->getId());
    $form = new InsurancesSubForm($val);
    $this->embeddedForms['newInsurance']->embedForm($num, $form);
    //Re-embedding the container
    $this->embedForm('newInsurance', $this->embeddedForms['newInsurance']);
  }
  
  public function loadEmbedInsurance()
  {
    if($this->isBound()) return;

    /* Comments sub form */
    $subForm = new sfForm();
    $this->embedForm('Insurances',$subForm);
    if($this->getObject()->getId() !='')
    {
      foreach(Doctrine::getTable('Insurances')->findForTable('loans', $this->getObject()->getId()) as $key=>$vals)
      {
        $form = new InsurancesSubForm($vals,array('table' => 'loans'));
        $this->embeddedForms['Insurances']->embedForm($key, $form);
      }
      //Re-embedding the container
      $this->embedForm('Insurances', $this->embeddedForms['Insurances']);
    }

    $subForm = new sfForm();
    $this->embedForm('newInsurance',$subForm);
  }
    
  public function addComments($num, $obj=null)
  {
      if(! isset($this['newComments'])) $this->loadEmbedComments();
      $options = array('referenced_relation' => 'loans', 'record_id' => $this->getObject()->getId());
      if (!$obj) $val = new Comments();
      else $val = $obj ;      
      $val->fromArray($options);
      $val->setRecordId($this->getObject()->getId());
      $form = new CommentsSubForm($val,array('table' => 'loans', 'line_display' => true));
      $this->embeddedForms['newComments']->embedForm($num, $form);
      //Re-embedding the container
      $this->embedForm('newComments', $this->embeddedForms['newComments']);
  }  
  
  public function loadEmbedComments()
  {
    if($this->isBound()) return;
    /* Comments sub form */
    $subForm = new sfForm();
    $this->embedForm('Comments',$subForm);    
    if($this->getObject()->getId() !='')
    {
      foreach(Doctrine::getTable('comments')->findForTable('loans', $this->getObject()->getId()) as $key=>$vals)
      {
        $form = new CommentsSubForm($vals,array('table' => 'loans'));
        $this->embeddedForms['Comments']->embedForm($key, $form);
      }
      //Re-embedding the container
      $this->embedForm('Comments', $this->embeddedForms['Comments']);
    }

    $subForm = new sfForm();
    $this->embedForm('newComments',$subForm);
  }
  
  public function bind(array $taintedValues = null, array $taintedFiles = null)
  {
    /* For each embedded informations 
     * test if the widget is on screen by testing a flag field present on the concerned widget
     * If widget is not on screen, remove the field from list of fields to be bound, and than potentially saved
    */

    if(!isset($taintedValues['comment']))
    {
      $this->offsetUnset('Comments');
      unset($taintedValues['Comments']);
      $this->offsetUnset('newComments');
      unset($taintedValues['newComments']);
    }
    else
    {
      $this->loadEmbedComments();
      if(isset($taintedValues['newComments']))
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
    }

    if(!isset($taintedValues['sender']))
    {
      $this->offsetUnset('ActorsSender');
      unset($taintedValues['ActorsSender']);
      $this->offsetUnset('newActorsSender');
      unset($taintedValues['newActorsSender']);
    }
    else
    {
      $this->loadEmbedActorsSender();
      if(isset($taintedValues['newActorsSender']))
      {
        foreach($taintedValues['newActorsSender'] as $key=>$newVal)
        {
          if (!isset($this['newActorsSender'][$key]))
          {
            $this->addActorsSender($key,$newVal['people_ref'],$newVal['order_by']);
          }
          $taintedValues['newActorsSender'][$key]['record_id'] = 0;
        }
      }
    }

    if(!isset($taintedValues['receiver']))
    {
      $this->offsetUnset('ActorsReceiver');
      unset($taintedValues['ActorsReceiver']);
      $this->offsetUnset('newActorsReceiver');
      unset($taintedValues['newActorsReceiver']);
    }
    else
    {
      $this->loadEmbedActorsReceiver();
      if(isset($taintedValues['newActorsReceiver']))
      {
        foreach($taintedValues['newActorsReceiver'] as $key=>$newVal)
        {
          if (!isset($this['newActorsReceiver'][$key]))
          {
            $this->addActorsReceiver($key,$newVal['people_ref'],$newVal['order_by']);
          }
          $taintedValues['newActorsReceiver'][$key]['record_id'] = 0;
        }
      }
    }    

    if(!isset($taintedValues['insurance']))
    {
      $this->offsetUnset('Insurances');
      unset($taintedValues['Insurances']);
      $this->offsetUnset('newInsurance');
      unset($taintedValues['newInsurance']);
    }
    else
    {
      $this->loadEmbedInsurance();
      if(isset($taintedValues['newInsurance']))
      {
        foreach($taintedValues['newInsurance'] as $key=>$newVal)
        {
          if (!isset($this['newInsurance'][$key]))
          {
            $this->addInsurances($key);
          }
          $taintedValues['newInsurance'][$key]['record_id'] = 0;
        }
      }
    }  
    parent::bind($taintedValues, $taintedFiles);   
  }

  public function saveEmbeddedForms($con = null, $forms = null)
  {
    if (null === $forms && $this->getValue('comment'))
    {
      $value = $this->getValue('newComments');
      foreach($this->embeddedForms['newComments']->getEmbeddedForms() as $name => $form)
      {
        if(!isset($value[$name]['comment'] ))
          unset($this->embeddedForms['newComments'][$name]);
        else
        {
          $form->getObject()->setRecordId($this->getObject()->getId());
        }
      }
      $value = $this->getValue('Comments');
      foreach($this->embeddedForms['Comments']->getEmbeddedForms() as $name => $form)
      {
        if (!isset($value[$name]['comment'] ))
        {
          $form->getObject()->delete();
          unset($this->embeddedForms['Comments'][$name]);
        }
      }
    }  
    if (null === $forms && $this->getValue('sender'))
    {
      $value = $this->getValue('newActorsSender');
      foreach($this->embeddedForms['newActorsSender']->getEmbeddedForms() as $name => $form)
      {
        if(!isset($value[$name]['people_ref'] ))
          unset($this->embeddedForms['newActorsSender'][$name]);
        else
        {
          $form->getObject()->setRecordId($this->getObject()->getId());
        }
      }
      $value = $this->getValue('ActorsSender');
      foreach($this->embeddedForms['ActorsSender']->getEmbeddedForms() as $name => $form)
      {
        if (!isset($value[$name]['people_ref'] ))
        {
          $form->getObject()->delete();
          unset($this->embeddedForms['ActorsSender'][$name]);
        }
      }
    }

    if (null === $forms && $this->getValue('receiver'))
    {
      $value = $this->getValue('newActorsReceiver');
      foreach($this->embeddedForms['newActorsReceiver']->getEmbeddedForms() as $name => $form)
      {
        if(!isset($value[$name]['people_ref'] ))
          unset($this->embeddedForms['newActorsReceiver'][$name]);
        else
        {
          $form->getObject()->setRecordId($this->getObject()->getId());
        }
      }
      $value = $this->getValue('ActorsReceiver');
      foreach($this->embeddedForms['ActorsReceiver']->getEmbeddedForms() as $name => $form)
      {
        if (!isset($value[$name]['people_ref'] ))
        {
          $form->getObject()->delete();
          unset($this->embeddedForms['ActorsReceiver'][$name]);
        }
      }
    }
    if (null === $forms && $this->getValue('insurance'))
    {
      $value = $this->getValue('newInsurance');
      foreach($this->embeddedForms['newInsurance']->getEmbeddedForms() as $name => $form)
      {
        if(!isset($value[$name]['insurance_value']))
          unset($this->embeddedForms['newInsurance'][$name]);
        else
          $form->getObject()->setRecordId($this->getObject()->getId());
      }

      $value = $this->getValue('Insurances');
      foreach($this->embeddedForms['Insurances']->getEmbeddedForms() as $name => $form)
      {
        if (!isset($value[$name]['insurance_value']))
        {
          $form->getObject()->delete();
          unset($this->embeddedForms['Insurances'][$name]);
        }
      }
    }              
    return parent::saveEmbeddedForms($con, $forms);
  }   
  
  public function getJavaScripts()
  {
    $javascripts=parent::getJavascripts();
    $javascripts[]='/js/jquery-datepicker-lang.js';
    $javascripts[]='/js/button_ref.js'; 
    $javascripts[]='/js/catalogue_people.js';   
    return $javascripts;
  }

  public function getStylesheets()
  {
    $javascripts=parent::getStylesheets();
    $javascripts['/css/ui.datepicker.css']='all';
    return $javascripts;
  }  
}
