<?php
/**
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class TagGroupsTable extends DarwinTable
{
  public function getDistinctSubGroups($group)
  {
    $q = $this->createDistinct('TagGroups  INDEXBY sgn', 'sub_group_name', 'sgn','');
    $q->andWhere('group_name = ?', $group);
    $results = $q->fetchArray();
    if(count($results))
      $results = array_combine(array_keys($results),array_keys($results));

    return array_merge(array(''=>''), $results);
  }

  public function getPropositions($value, $group, $sub_group)
  {
    $conn = Doctrine_Manager::connection();
    $tags = $conn->quote($value, 'string');

    $result = $conn->fetchAssoc("SELECT tag, sum(cnt) as cnt FROM tags as t RIGHT JOIN (SELECT x.group_ref,COUNT(*) as cnt FROM
(
	SELECT group_ref from tags where tag_indexed in (SELECT distinct(fulltoIndex(tags)) as u_tag FROM regexp_split_to_table($tags, ';') as tags WHERE fulltoIndex(tags) != '')
) as x GROUP BY x.group_ref
ORDER BY cnt DESC) AS y on t.group_ref = y.group_ref 
WHERE tag_indexed not in (SELECT distinct(fulltoIndex(tags)) as u_tag FROM regexp_split_to_table($tags, ';') as tags WHERE fulltoIndex(tags) != '')
GROUP by tag
order BY tag asc LIMIT 10");

  $max = 0;
  $min = 0;
  $nbr_of_steps= 5;
  foreach($result as $i => $item)
  {
    if($max < $item['cnt'])
      $max = $item['cnt'];
    if($min > $item['cnt'])
      $min = $item['cnt'];
  }
  $step = ($max - $min) / $nbr_of_steps;
  foreach($result as $i => $item)
  {
//round($minsize + (($item['cnt'] - $min) * $step));
    $result[$i]['size'] = round($item['cnt'] / $step);
  }

  return $result;
    
  }

  public function fetchTag($ids)
  {
    $q = Doctrine_Query::create()
	 ->from('TagGroups g')
	 ->innerJoin('g.Tags t')
	 ->andWherein('g.gtu_ref', $ids);
    $r = $q->execute();
    $results = array();
    foreach($r as $i)
    {
      if(!isset($results[$i->getGtuRef()]))
	$results[$i->getGtuRef()] = array();

      $results[$i->getGtuRef()][] = $i;      
    }
    return $results;
  }

}