<?php
/**
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class CommentsTable extends DarwinTable
{
  protected static $notions = array('taxonomy' => array('taxon information' => 'taxon information',
                                                        'taxon life history' => 'taxon life history',
                                                        'taxon sp comments' => 'taxon old sp. comments',
                                                       ),
                                    'chronostratigraphy' => array('unit information' => 'unit information',
                                                                 ),
                                    'lithostratigraphy' => array('unit information' => 'unit information',
                                                                 ),
                                    'lithology' => array('unit information' => 'unit information',
                                                                 ),
                                    'mineralogy' => array('unit information' => 'unit information',
                                                                 ),
                                    'igs' => array('ig definition' => 'ig definition',
                                             'diverse' => 'diverse'
                                                  ),
                                    'expeditions' => array('expedition information' => 'expedition information',
                                                         ),
                                    'collections' => array('collection information' => 'collection information',
                                                         ),
                                    'people' => array('general information' => 'general information',
                                                      'people history' => 'people history',
                                                         ),
                                    'gtu' => array('position information' => 'Position information',
                                                   'period information' => 'Period information',
                                                   'general comments' => 'sampling point information',
                                                  ),
                                    'collecting_methods' => array('general information' => 'general information',
                                                                  'method description' => 'method description',
                                                                 ),
                                    'collecting_tools' => array('general information' => 'general information',
                                                                'tool description' => 'tool description',
                                                                 ),
                                    'specimen_parts' => array('container' => 'Container',
                                                              'disposal' => 'Disposal',
                                                              'part' => 'Parts',
                                                             ),
                                    'specimens' => array('general' => 'General', 'taxonomy' => 'Taxonomy', 'chronostratigraphy' => 'Chronostratigraphy',
                                    		'lithostratigraphy' => 'Lithostratigraphy', 'lithology' => 'Lithology', 'mineralogy' => 'Mineralogy',
                                    		'sampling_locations' => 'Sampling locations', 'igs' => 'IGs', 'identifications' => 'Identifications',
                                    		'collectors' => 'Collectors', 'hosting' => 'Hosting'
                                    		            ),
                                    'individuals' => array('general' => 'General', 'type' => 'Type', 'stage' => 'Stage', 'sex' => 'Sex',
                                    		'social_status' => 'Social status', 'rock_form' => 'Rock form', 'identifications' => 'Identifications'
                                    		            ),
                                    'parts' => array('general' => 'General', 'description' => 'Description', 'conservation_mean' => 'Conservation mean',
                                              'conservation_location' => 'Conservation location', 'preparation' => 'Preparation')
                                   );

  /**
  * Find all comments for a table name and a recordId
  * @param string $table_name the table to look for
  * @param int record_id the record to be commented out.
  * @return Doctrine_Collection Collection of Doctrine records
  */
  public function findForTable($table_name, $record_id)
  {
     $q = Doctrine_Query::create()
        ->from('Comments c');
     $q = $this->addCatalogueReferences($q, $table_name, $record_id, 'c', true);
    return $q->execute();
  }

  /**
  * Get commentable notions for a given table as an array
  * @param string $table_name The table name
  * @return array an array of key/values with notion that can be commented
  */
  public static function getNotionsFor($table_name)
  {
	if(isset( self::$notions[$table_name]))
	  return self::$notions[$table_name];
	else
	   return array();
  }
}
