<?php

/**
 * Chronostratigraphy filter form.
 *
 * @package    darwin
 * @subpackage filter
 * @author     DB team <collections@naturalsciences.be>
 * @version    SVN: $Id: sfDoctrineFormFilterTemplate.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class ChronostratigraphyFormFilter extends BaseChronostratigraphyFormFilter
{
  public function configure()
  {
    $this->useFields(array('name', 'level_ref', 'lower_bound', 'upper_bound'));
    $this->addPagerItems();
    $this->widgetSchema['name'] = new sfWidgetFormInputText();
    $this->widgetSchema['lower_bound'] = new sfWidgetFormInput();
    $this->widgetSchema['upper_bound'] = new sfWidgetFormInput();
    $this->widgetSchema['table'] = new sfWidgetFormInputHidden();
    $this->widgetSchema->setNameFormat('searchCatalogue[%s]');
    $this->widgetSchema['lower_bound']->setAttributes(array('class'=>'small_size datesNum'));
    $this->widgetSchema['lower_bound']->setLabel($this->getI18N()->__('Low. bound (My)'));
    $this->widgetSchema['upper_bound']->setAttributes(array('class'=>'small_size datesNum'));
    $this->widgetSchema['upper_bound']->setLabel($this->getI18N()->__('Up. bound (My)'));
    $this->widgetSchema['level_ref'] = new sfWidgetFormDoctrineChoice(array(
        'model' => 'CatalogueLevels',
        'table_method' => 'getLevelsForChronostratigraphy',
        'add_empty' => 'All'
      ));
    $this->widgetSchema->setLabels(array('level_ref' => $this->getI18N()->__('Level')
                                        )
                                  );

    $this->validatorSchema['name'] = new sfValidatorString(array('required' => false,
                                                                 'trim' => true
                                                                )
                                                          );
    $this->validatorSchema['table'] = new sfValidatorString(array('required' => true));
    $this->validatorSchema['lower_bound'] = new sfValidatorNumber(array('required' => false, 'empty_value' => -4600, 'min' => -4600));
    $this->validatorSchema['upper_bound'] = new sfValidatorNumber(array('required' => false, 'empty_value' => 1, 'max' => 1));
    $this->validatorSchema->setPostValidator(new sfValidatorSchemaCompare('lower_bound', 
                                                                          '<=', 
                                                                          'upper_bound', 
                                                                          array('throw_global_error' => true), 
                                                                          array('invalid'=>$this->getI18N()->__('The lower bound (%left_field%) cannot be above the upper bound (%right_field%).'))
                                                                         )
                                            );
  }

  public function addBoundRangeColumnQuery(Doctrine_Query $query, $val_from, $val_to)
  {
    $query->andWhere('coalesce(lower_bound, -4600) Between ? and ?', array($val_from, $val_to))
          ->andWhere('coalesce(upper_bound, 1) Between ? and ?', array($val_from, $val_to));
    return $query;
  }


  public function doBuildQuery(array $values)
  {
    $query = parent::doBuildQuery($values);
    $this->addNamingColumnQuery($query, 'chronostratigraphy', 'name_indexed', $values['name']);
    $this->addBoundRangeColumnQuery($query, $values['lower_bound'], $values['upper_bound']);
    $query->andWhere("id != 0 ")
          ->limit($this->getCatalogueRecLimits());
    return $query;
  }
}
