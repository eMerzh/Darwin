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

  public function addIsSearch(Doctrine_Query $q, $is_search = false)
  {
    $q->andWhere($q->getRootAlias() . '.is_only_id = ?', !$is_search);
    return $q;
  }
  
  public function getSavedSearchByKey($id, $user )
  {
    return $this->addUserOrder(null, $user)
      ->andWhere('id = ?', $id )
      ->fetchOne();
  }

  public function fetchSearch($user_ref, $num_per_page)
  {
    $q = $this->addUserOrder(null,$user_ref);
    $this->addIsSearch($q, true);
    $q->limit($num_per_page);

    return $q->execute();
  }

  public function fetchSpecimens($user_ref, $num_per_page)
  {
    $q = $this->addUserOrder(null,$user_ref);
    $this->addIsSearch($q, false);
    $q->limit($num_per_page);

    return $q->execute();
  }

  public function getListFor($user, $source)
  {
    $q = $this->addUserOrder(null,$user);
    $this->addIsSearch($q, false);
    return $q->andWhere('subject = ?',$source)->execute();
  }

  public function getAllFields($source, $is_reg_user = false)
  {
    $part_col = array();
    $individual_col = array();
    $specimen_col = array(
      'category'=>'category',
      'collection'=>'collection',
      'taxon'=>'taxon',
      'type'=>'type',
      'gtu'=>'gtu',
      'codes'=>'codes',
      'chrono'=>'chrono',
      'ig'=>'ig',
      'litho'=>'litho',
      'lithologic'=>'lithologic',
      'expedition'=>'expedition',
      'mineral'=>'mineral',
      'count'=>'count'
    );
    if($source == 'individual')
    {
      $individual_col = array(
        'individual_type',
        'sex',
        'state',
        'stage',
        'social_status',
        'rock_form',
        'individual_count',
      );
    }

    if($source == 'part')
    {
      if($is_reg_user)
      {
        $part_col = array(
          'part',
          'part_status',
          'part_code',
          'part_count',
        );      
      }
      else
      {
        $part_col = array(
          'part',
          'part_status',
          'building',
          'floor',
          'room',
          'row',
          'shelf',
          'container',
          'container_type',
          'container_storage',
          'sub_container',
          'sub_container_type',
          'sub_container_storage',
          'part_code',
          'part_count',
        );
      }
    }
    $columns = $specimen_col + $individual_col +  $part_col;
    return array_combine($columns, $columns);
  }
}
