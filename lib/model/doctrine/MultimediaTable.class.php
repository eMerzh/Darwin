<?php

/**
 * MultimediaTable
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class MultimediaTable extends DarwinTable
{
  /**
   * Returns an instance of this class.
   *
   * @return object MultimediaTable
   */
  public static function getInstance()
  {
      return Doctrine_Core::getTable('Multimedia');
  }
  
  public function findForTable($table_name, $record_id)
  {
    $q = Doctrine_Query::create()
	 ->from('Multimedia m')
	 ->orderBy('m.creation_date DESC');
    $q = $this->addCatalogueReferences($q, $table_name, $record_id, 'm', true);
    return $q->execute();
  }    
  
  /* return an array of URIs in order to delete related files */
  public function getMultimediaRelated($table,$record_id)
  {
    $files = array() ;
    foreach(self::findForTable($table, $record_id) as $media)
      $files[] = sfConfig::get('sf_upload_dir')."/multimedia/".$media->getUri();
    return $files ;
  }
}
