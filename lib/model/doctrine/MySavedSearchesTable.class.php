<?php
/**
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class MySavedSearchesTable extends DarwinTable
{
  public function addUserOrder(Doctrine_Query $q = null,$user)
  {
    if (is_null($q))
    {
        $q = Doctrine_Query::create()
            ->from('MySavedSearches s');
    }
    $alias = $q->getRootAlias();
    $q->andWhere($alias . '.user_ref = ?', $user)
        ->orderBy($alias . '.favorite DESC');
    return $q;
  }
  
  public function getSavedSearchByKey($id)
  {       
    $q = Doctrine_Query::create()
      ->from('MySavedSearches s');
    $alias = $q->getRootAlias();
    $q->andWhere($alias . '.id = ?', $id)
      ->orderBy($alias . '.favorite DESC');
    return($q->fetchOne()) ;
  }
  
  public function getAllFields()
  {
    return array('category'=>'category',
                 'collection'=>'collection',
                 'taxon'=>'taxon',
                 'type'=>'type',                 
                 'gtu'=>'gtu',
                 'chrono'=>'chrono',
                 'litho'=>'litho',
                 'lithologic'=>'lithologic',
                 'expedition'=>'expedition',
                 'mineral'=>'mineral',
                 'count'=>'count');
  
  }
}
