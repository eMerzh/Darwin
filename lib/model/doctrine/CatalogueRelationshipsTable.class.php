<?php
/**
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class CatalogueRelationshipsTable extends Doctrine_Table
{
  public function getRelationsForTable($table, $model, $id, $type=null)
  {
    $q = Doctrine_Query::create()
	    ->select('r.*, t.name')
	    ->from('CatalogueRelationships r, '.$model. ' t')
	    ->andWhere('t.id=r.record_id_2')
	    ->andwhere('r.referenced_relation = ?', $table)
	    ->andWhere('r.record_id_1=?', $id)
	    ->setHydrationMode(Doctrine::HYDRATE_NONE);
    if($type != null)
      $q->andWhere('r.relationship_type = ?',$type);
    return $q->execute();
  }

  public function DeleteRelationsForTable($table, $id)
  {
    $q = Doctrine_Query::create()
            ->delete('CatalogueRelationships r')
	    ->andwhere('r.referenced_relation = ?', $table)
	    ->andWhere('r.record_id_1=?', $id);
    return $q->execute();
  }

}