<?php

/**
 * Reports
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @package    darwin
 * @subpackage model
 * @author     DB team <darwin-ict@naturalsciences.be>
 * @version    SVN: $Id: Builder.php 7490 2010-03-29 19:53:27Z jwage $
 */
class Reports extends BaseReports
{

  private static $reports = array(
      'annual_stat_collection' => array(
        'name_fr' => 'Statistiques annuelles par collections',
        'name_nl' => 'Jaarlijkse statistieken collecties',
        'name_en' => 'Annual statistic by collections',
        'format' => array('xls'=>'xls','pdf'=>'pdf'),
        'widgets' => array('collection_ref' => 'Collection',
                           'date_from' => 'Date from',
                           'date_to' => 'Date to'
                          ),
        'widgets_options' => array('collection_ref'=> array(),
                                   'date_from' => array(),
                                   'date_to' => array()
                                  ),
        'fast' => true,
        'rights' => array(
          'at_least' => Users::MANAGER
        ),
      ),
      'catalogues_x_listing' => array(
        'name_fr' => "Listing des hiérarchies taxonomiques à partir de points d'entrée donnés",
        'name_nl' => "Listing taxonomische hiërarchieën van binnenkomst punten gegeven",
        'name_en' => "Listing taxonomic hierarchies from entry points given",
        'format' => array('csv'=>'csv'),
        'widgets' => array('catalogue_type'=>'Catalogue',
                           'catalogue_unit_ref' => 'Catalogue Unit',
                           'nbr_records' => 'Number of Records'
                          ),
        'widgets_options' => array('catalogue_type' => array('default_value' => 'taxonomy',
                                                             'values' => array('taxonomy' => 'Taxonomy (All)',
                                                                               'zoology' => 'Taxonomy (Zoology)',
                                                                               'botany' => 'Taxonomy (Botany)',
                                                                               'chronostratigraphy' => 'Chronostratigraphy',
                                                                               'lithostratigraphy' => 'Lithostratigraphy',
                                                                               'lithology' => 'Lithology',
                                                                               'mineralogy' => 'Mineralogy'
                                                                              )
                                                             ),
                                   'catalogue_unit_ref' => array('multi' => true,
                                                                 'second_line' => true
                                                                ),
                                   'nbr_records' => array('default_value' => '0',
                                                          'values' => array('0'=>'All',
                                                                            '500' => '500',
                                                                            '1000' => '1000',
                                                                            '5000' => '5000',
                                                                            '10000' => '10000',
                                                                            '25000' => '25000',
                                                                            '50000' => '50000'
                                                                           )
                                                         )
                                 ),
        'fast' => false,
        'rights' => array(
          'at_least' => Users::ENCODER
        ),
      ),
      'loans_form_complete' => array(
        'name_fr' => "Formulaire de prêt scientifique",
        'name_nl' => "Wetenschappelijk leen formulier",
        'name_en' => "Scientific loan form",
        'format' => array('pdf'=>'pdf','odt'=>'odt'),
        'widgets' => array('loan_id'=>'Loan',
                           'loan_target_selected' => 'Copy to print',
                           'loan_target_catalogues' => 'Catalogue(s) concerned',
                           'lang' => 'Language'
        ),
        'widgets_options' => array(
                                    'loan_id' => array(),
                                    'loan_target_selected' => array(
                                      'default_value' => 'RBINS copy',
                                      'values' => array(
                                        'RBINS copy' => 'RBINS copy',
                                        'Your copy' => 'Your copy',
                                        'Specimens copy' => 'Specimens copy',
                                        'Responsible copy' => 'Responsible copy'
                                      )
                                    ),
                                    'loan_target_catalogues' => array(
                                      'default_value' => 'taxonomy',
                                      'values' => array(
                                        'taxonomy' => 'Taxonomy',
                                        'chronostratigraphy' => 'Chronostratigraphy',
                                        'lithostratigraphy' => 'Lithostratigraphy',
                                        'lithology' => 'Lithology',
                                        'mineralogy' => 'Mineralogy'
                                      )
                                    ),
                                    'lang' => array(
                                      'default_value' => 'en',
                                      'values' => array(
                                        'nl' => 'Dutch',
                                        'en' => 'English',
                                        'fr' => 'French'
                                      )
                                    ),
                                  ),
        'fast' => true,
        'rights' => array(
          'at_least' => Users::REGISTERED_USER
        ),
      ),
    );

  /*
   * Display the list of available reports
   * @param $user object The sfUser Object
   * @return array A subset of self::$reports - List of reports available
   */
  static public function getGlobalReports($user)
  {
    $reports_list = array();
    foreach( self::$reports as $report_key => $report_val ) {
      if ( $user->isAtLeast( $report_val['rights']['at_least'] ) ) {
        $reports_list [$report_key] = $report_val;
      }
    }
    return $reports_list;
  }

  static public function getReportName($name,$lang)
  {
    return self::$reports[$name]['name_'.$lang] ;
  }
  
  static public function getRequiredFieldForReport($name)
  {
    if(!$name) return array() ;
    return self::$reports[$name]['widgets'] ;
  }

  static public function getRequiredFieldForReportOptions($name)
  {
    if(!$name) return array() ;
    return self::$reports[$name]['widgets_options'] ;
  }

  static public function getFieldsOptions($name)
  {
    if(!$name) return array() ;
    return self::$reports[$name]['widgets_options'] ;
  }

  static public function getFormatFor($name)
  {
    if(!$name) return array() ;
    return self::$reports[$name]['format'] ;
  }
  static public function getIsFast($name)
  {
    if(!$name) return array() ;
    return self::$reports[$name]['fast'] ;
  }
  public function setParameters($data)
  {
    $param = '' ;
    $widget = self::getRequiredFieldForReport($data['name']) ;
    foreach($widget as $field => $name)
    {
      if($field == 'date_from' OR $field == 'date_to')
      {
        $dateTime = new FuzzyDateTime($data[$field], 56, true); 
        $param .= '"'.$field.'"=>"'.$dateTime->format('Y-m-d').'",' ;
      }
      else {
        if (is_array($data[ $field ])) {
          $param .= '"' . $field . '"=>"[' . implode(", ",$data[ $field ]) . ']",';
        }
        else {
          $param .= '"' . $field . '"=>"' . $data[ $field ] . '",';
        }
      }
    }
    $this->_set('parameters',$param) ;
  }

  public function getParameters()
  {
    $hstore = new Hstore() ;
    $hstore->import($this->_get('parameters')) ;
    return $hstore ;
  }

  public function getUrlReport()
  {
    $variables = $this->getParameters();
    $name = $this->getName();
    switch($name) {
      case "catalogues_x_listing":
        if(in_array($variables['catalogue_type'],array_keys(self::$reports[$name]['widgets_options']['catalogue_type']['values']))){
          $name = str_replace('_x_','_'.$variables['catalogue_type'].'_',$name);
        }
    }

    sfApplicationConfiguration::getActive()->loadHelpers(array("Darwin"));

    $url = constructReportBaseUrl($name, $this->getLang(), $this->getFormat());

    if(!empty($url) && !in_array($url, array($name.'.'.$this->getFormat(), $name.'_'.$this->getLang().'.'.$this->getFormat()))) {
      if (!empty($variables)) {
        $url .= '?' . http_build_query($variables);
      }
      // We add userLocale to the url to avoid different date format depending on which locale jasper choose
      $url .= "&userLocale=en";
    }

    return $url ;
  }

  public function getDiffAsArray()
  {
    $hstore = $this->_get('parameters');
    $diff = new Hstore();
    $diff->import($hstore);
    $tab = $diff->getIterator() ;
    foreach($tab as $key=>$value)
    {
      if(preg_match("/_indexed$/", $key) || preg_match("/_name_ts$/", $key) || preg_match("/_order_by$/", $key))
        $tab->offsetUnset($key);
    }
    return $tab;
  }
}
