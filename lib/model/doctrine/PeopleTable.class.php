<?php
/**
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class PeopleTable extends DarwinTable
{
  /**
  * Find all distinct tyoe of institutions
  * @return Doctrine_Collection with only the key 'type'
  */
  public function getDistinctTitles()
  {
    return $this->createFlatDistinct('people', 'title', 'titles')->execute();

  }

  /**
  * Search all physical people by name
  * @param string $name a part of the formated name to look for (with ts)
  * @return Doctrine_Collection Collection of People
  */
  public function searchPysical($name)
  {
    $q = Doctrine_Query::create()
      ->from('People p')
      ->andWhere('p.is_physical = ?', true)
      ->andWhere('p.id != 0')
      ->andWhere('p.formated_name_indexed like concat(\'%\', fulltoindex(?), \'%\' )',$name);
    return $q->execute();
  }


  /**
  * Find Only people not institution
  * @param int the id of the people
  * @return Doctrine_Record 
  */
  public function findPeople($id)
  {
    $q = Doctrine_Query::create()
	 ->from('People p')
	 ->where('p.id = ?', $id)
   ->andWhere('p.id != 0')
	 ->andWhere('p.is_physical = ?', true);

    return $q->fetchOne(); 
  }
  
  /**
  * Find Only people with specified family name
  * @param string the name of the people
  * @return Doctrine_Record 
  */
    public function getPeopleByName($name)
    {
      $q = Doctrine_Query::create()
      ->from('people p')
      ->where('p.family_name = ?', $name);

      return $q->fetchOne(); 
    }

}
