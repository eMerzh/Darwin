<?php
/**
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class IdentificationsTable extends DarwinTable
{
  /**
  * Get Distincts suffix separators
  * @return array an Array of types in keys
  */
  public function getDistinctDeterminationStatus()
  {
    return $this->createFlatDistinct('identifications', 'determination_status', 'determination_status')->execute();
  }

  public function getIdentificationsRelated($table='specimens', $specId)
  {
    $q = Doctrine_Query::create()->
         from('Identifications')->
         where('referenced_relation = ?', $table)->
         andWhere('record_id = ?', $specId)->
         orderBy('order_by ASC, notion_date DESC, notion_concerned ASC');
    return $q->execute();
  }
  
  public function getStagingId($id)
  {
     $q = Doctrine_Query::create()->
         from('Identifications')->
         where('referenced_relation = \'staging\'')->
         andWhere('record_id = ?', $id);
    return $q->fetchOne(); 
  }

}
