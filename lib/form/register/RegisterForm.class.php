<?php

/**
 * Register form.
 *
 * @package    form
 * @subpackage Register
 * @version    SVN: $Id: sfDoctrineFormTemplate.php 6174 2007-11-27 06:22:40Z fabien $
 */
class RegisterForm extends BaseUsersForm
{
  public function configure()
  {
    $this->useFields(array('id','is_physical','sub_type','title','family_name','given_name')) ;
    $choices = array($this->getI18N()->__('Moral person'), $this->getI18N()->__('Physical person'));
    $this->widgetSchema['is_physical'] = new sfWidgetFormChoice(array ('choices' => $choices));
    $this->setDefault('is_physical', 1);
    $this->widgetSchema['is_physical']->setAttributes(array('class'=>'required_field'));
    $this->widgetSchema['sub_type'] = new sfWidgetFormDoctrineChoice(array('model' => 'Users',
                                                                           'table_method' => 'getDistinctSubType',
                                                                           'method' => 'getSubType',
                                                                           'key_method' => 'getSubType',
                                                                           'add_empty'=>true,
                                                                          )
                                                                    );
    $this->widgetSchema['title'] = new sfWidgetFormDoctrineChoice(array('model' => 'Users',
                                                                        'table_method' => 'getDistinctTitle',
                                                                        'method' => 'getTitle',
                                                                        'key_method' => 'getTitle',
                                                                        'add_empty'=>true,
                                                                       )
                                                                 );
    $this->widgetSchema['given_name'] = new sfWidgetFormInput();
    $this->widgetSchema['given_name']->setAttributes(array('class'=>'medium_size'));
    $this->widgetSchema['family_name'] = new sfWidgetFormInput();
    $this->widgetSchema['family_name']->setAttributes(array('class'=>'medium_size required_field'));

    $this->widgetSchema['terms_of_use'] = new sfWidgetFormInputCheckbox();
    $this->widgetSchema['terms_of_use']->setAttributes(array('class'=>'required_field'));
    $this->setDefault('terms_of_use',false);

    /* Captcha */
    
    $this->widgetSchema['captcha'] = new sfWidgetFormReCaptcha(array('public_key' => sfConfig::get('app_recaptcha_public_key')));
 
    /* Validators */

    $this->validatorSchema['terms_of_use'] = new sfValidatorBoolean(array('required'=>true),
                                                                    array('required'=> 'You cannot register without accepting DaRWIN 2  term of use',
                                                                          'invalid' => 'The value provided for term of use is invalid'
                                                                         )
                                                                   );
    $this->validatorSchema['is_physical'] = new sfValidatorBoolean(array('required'=>true),
                                                                   array('required'=> 'Status is required',
                                                                         'invalid' => 'The value provided for status is invalid'
                                                                        )
                                                                  );
    $this->validatorSchema['family_name'] = new sfValidatorString(array('trim'=>true,
                                                                        'required'=>true
                                                                       ),
                                                                   array('required'=> 'Name is required',
                                                                         'invalid' => 'The value provided for name is invalid'
                                                                        )
                                                                 );
    $this->validatorSchema['captcha'] = new sfValidatorReCaptcha(array('private_key' => sfConfig::get('app_recaptcha_private_key'),
                                                                       'proxy_host' => '193.190.234.10',
                                                                       'proxy_port' => 3128
                                                                      ));

    /* Labels */
    $this->widgetSchema->setLabels(array('family_name'=>'Name',
                                         'given_name'=>'First name',
                                         'is_physical'=>'Status',
                                         'sub_type'=>'Type'
                                        )
                                  );

    /* Login infos as embedded form */

    $regLoginInfoSubForm = new sfForm();
    $this->embedForm('RegisterLoginInfosForm',$regLoginInfoSubForm);


    /* Comm means as embedded form */
    $regCommSubForm = new sfForm();
    $this->embedForm('RegisterCommForm',$regCommSubForm);

    /* Languages as embedded form */
    $regLangSubForm = new sfForm();
    $this->embedForm('RegisterLanguagesForm',$regLangSubForm);

  }

  public function addLoginInfos($num)
  {
    $val = new UsersLoginInfos();
    $val->User = $this->getObject();
    $form = new RegisterLoginInfosForm($val);
    $this->embeddedForms['RegisterLoginInfosForm']->embedForm($num, $form);
    //Re-embedding the container
    $this->embedForm('RegisterLoginInfosForm', $this->embeddedForms['RegisterLoginInfosForm']);
  }

  public function addComm($num)
  {
    $val = new UsersComm();
    $val->Users = $this->getObject();
    $form = new RegisterCommForm($val);
    $this->embeddedForms['RegisterCommForm']->embedForm($num, $form);
    //Re-embedding the container
    $this->embedForm('RegisterCommForm', $this->embeddedForms['RegisterCommForm']);
  }

  public function addLanguages($num)
  {
    $val = new UsersLanguages();
    $val->User = $this->getObject();
    $form = new RegisterLanguagesForm($val);
    $this->embeddedForms['RegisterLanguagesForm']->embedForm($num, $form);
    //Re-embedding the container
    $this->embedForm('RegisterLanguagesForm', $this->embeddedForms['RegisterLanguagesForm']);
  }

  public function bind(array $taintedValues = null, array $taintedFiles = null)
  {
    if(isset($taintedValues['RegisterLoginInfosForm']))
    {
      foreach($taintedValues['RegisterLoginInfosForm'] as $key=>$newVal)
      {
        if (!isset($this['RegisterLoginInfosForm'][$key]))
        {
          $this->addLoginInfos($key);
        }
      }
    }
    if(isset($taintedValues['RegisterCommForm']))
    {
      foreach($taintedValues['RegisterCommForm'] as $key=>$newVal)
      {
        if (!isset($this['RegisterCommForm'][$key]))
        {
          $this->addComm($key);
        }
      }
    }
    if(isset($taintedValues['RegisterLanguagesForm']))
    {
      foreach($taintedValues['RegisterLanguagesForm'] as $key=>$newVal)
      {
        if (!isset($this['RegisterLanguagesForm'][$key]))
        {
          $this->addLanguages($key);
        }
      }
    }
    parent::bind($taintedValues, $taintedFiles);
  }

  public function saveEmbeddedForms($con = null, $forms = null)
  {
    if (null === $forms)
    {
      $value = $this->getValue('RegisterLoginInfosForm');
      foreach($this->embeddedForms['RegisterLoginInfosForm']->getEmbeddedForms() as $name => $form)
      {
        $form->getObject()->setUserRef($this->getObject()->getId());
        $form->getObject()->save();
      }
      $value = $this->getValue('RegisterCommForm');
      foreach($this->embeddedForms['RegisterCommForm']->getEmbeddedForms() as $name => $form)
      {
        $form->getObject()->setPersonUserRef($this->getObject()->getId());
        $form->getObject()->save();
      }
      $value = $this->getValue('RegisterLanguagesForm');
      foreach($this->embeddedForms['RegisterLanguagesForm']->getEmbeddedForms() as $name => $form)
      {
        $form->getObject()->setUsersRef($this->getObject()->getId());
        $form->getObject()->save();
      }
    }
    return parent::saveEmbeddedForms($con, $forms);
  }
}