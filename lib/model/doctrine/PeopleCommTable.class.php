<?php
/**
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class PeopleCommTable extends DarwinTable
{
  public function getTags($type)
  {
    if($type=="phone/fax")
      $tag_comm = array('home'=>'Home', 'pager'=>'Pager', 'work'=>'Work', 'pref'=>'Preferred', 'voice'=>'Voice', 'fax'=>'Fax', 'cell'=>'Cell', 'tel'=>'Tel');
    else
      $tag_comm = array('home'=>'Home','pref'=>'Preferred', 'work'=>'Work','internet'=> 'Internet');

    try{
        $i18n_object = sfContext::getInstance()->getI18n();
    }
    catch( Exception $e )
    {
        return $tag_comm;
    }
    return array_map(array($i18n_object, '__'), $tag_comm);      
  }

  public function fetchByPeople($id)
  {
    $q = Doctrine_Query::create()
	  ->from('PeopleComm r')
	  ->where('r.person_user_ref = ?',$id)
	  ->orderBy('r.comm_type ASC, r.id ASC');
    return $q->execute();
  }
}
