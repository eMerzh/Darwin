<?php
/**
 */
class ClassificationSynonymiesTable extends DarwinTable
{

  /**
  * Find all Synonyms for a table name and a recordId
  * @param string $table_name the table to look for
  * @param int record_id the record to be linked.
  * @return Doctrine_Collection Collection of Doctrine records
  */
  public function findForTable($table_name, $record_id)
  {
    $q = Doctrine_Query::create()
	 ->from('ClassificationSynonymies s');
    $q = $this->addCatalogueReferences($q,$table_name, $record_id,'s');
    return $q->execute();
  }

  public function findOneForTableWithGroup($table_name, $record_id, $group_id)
  {
    $q = Doctrine_Query::create()
	 ->from('ClassificationSynonymies s')
	 ->andWhere('s.group_id = ?',$group_id);
    $q = $this->addCatalogueReferences($q,$table_name, $record_id,'s');
    return $q->fetchOne();
  }

  public function findGroupsIdsForRecord($table_name, $record_id)
  {
    $q = Doctrine_Query::create()
	 ->select('DISTINCT(group_id) as group')
	 ->from('ClassificationSynonymies s INDEXBY group');
    $q = $this->addCatalogueReferences($q,$table_name, $record_id,'s');
    $results = $q->fetchArray();
    if(!count($results))
      return array();
    $groups = array();
    foreach($results as $result)
    {
      $groups[] = $result['group'];
    }
    return $groups;
  }

  public function findGroupForTable($table_name, $record_id)
  {
    $groups = $this->findGroupsIdsForRecord($table_name, $record_id);
    if(empty($groups))
      return array();
    $q = Doctrine_Query::create()
	 ->select('s.group_name, s.id, s.record_id, s.group_id, s.is_basionym, s.order_by, t.name')
	 ->from('ClassificationSynonymies s, '.Catalogue::getModelForTable($table_name). ' t')
	 ->whereIn('s.group_id', $groups)
	 ->andWhere('t.id=s.record_id')
	 ->andWhere('s.record_id != ?',$record_id)
	 ->andWhere('s.referenced_relation = ?',$table_name) //Not really necessay but....
	 ->orderBy('s.group_name ASC, s.order_by')
	 ->setHydrationMode(Doctrine::HYDRATE_NONE);
    $items = $q->execute();
    $results = array();
    foreach($items as $item)
    {
	//group_name 
	if(! isset($results[$item[0]]) )
	  $results[$item[0]]=array();
	$results[$item[0]][] = array(
	  'id' => $item[1],
	  'record_id' => $item[2],
	  'group_id' => $item[3],
	  'is_basionym' => $item[4],
	  'order_by' => $item[5],
	  'name' => $item[6],
	);
    }
    return $results;
  }
  
  public function findGroupnames()
  {
    return array(
      'synonym' => $this->getI18N()->__('Synonyms'),
      'isonym' => $this->getI18N()->__('Isonyms'),
      'homonym' => $this->getI18N()->__('Homonyms')
    );
  }

  public function findNextGroupId()
  {
    $q = Doctrine_Query::create()
	 ->select('MAX(s.group_id) as gid')
	 ->from('ClassificationSynonymies s');
    $result = $q->fetchOne();
    return $result->getGid()+1;
  }
  
  public  function findSynonymsFor($table_name, $record_id, $type)
  {
    $q = Doctrine_Query::create()
	 ->from('ClassificationSynonymies s')
	 ->andWhere('s.group_name = ?',$type);

    $q = $this->addCatalogueReferences($q,$table_name, $record_id,'s');

    $result = $q->fetchOne();
    if($result)
      return $result->getGroupId();
    else
      return 0;
  }

  public function mergeGroup($group1, $group2)
  {
    $q = Doctrine_Query::create()
      ->update('ClassificationSynonymies s')
      ->set('s.group_id', '?', $group1)
      ->where('s.group_id = ?', $group2);

    $updated = $q->execute();
  }
}