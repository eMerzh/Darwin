<?php

class myUser extends sfBasicSecurityUser
{
  public function getId()
  {
    return $this->getAttribute('db_user_id');
  }

  public function getDbUserType()
  {
    return $this->getAttribute('db_user_type');
  }
  
  /**
   * Save the visible columns in the search
   * @param array $columns Array of columns names
   */
  public function storeVisibleCols($columns)
  {
    $this->setAttribute('spec_search_columns',$columns);
  }

  /**
   * Fetch the visible columns in the search
   * @return array an array of visible fields
   */
  public function fetchVisibleCols($source)
  {
    if($source=='specimen')
      return explode('|',Doctrine::getTable('Preferences')->getPreference($this->getId(),'search_cols_specimen',true));
    if($source=='individual')
      return explode('|',Doctrine::getTable('Preferences')->getPreference($this->getId(),'search_cols_individual',true));
    return explode('|',Doctrine::getTable('Preferences')->getPreference($this->getId(),'search_cols_part',true));
  }


  public function storeRecPerPage($number)
  {
    $this->setAttribute('rec_per_page',$number);
  }
  
  public function fetchRecPerPage()
  {
    return $this->getAttribute('rec_per_page',10);
  }


  public function removePinTo($id,$source)
  {
    $pins = $this->getAttribute('spec_pinned_'.$source, array());
    if( ($key = array_search($id, $pins)) !== false)
      unset($pins[$key]);

    $this->setAttribute('spec_pinned_'.$source, $pins);
    
  }
  
  public function clearPinned($source)
  {
     $this->setAttribute('spec_pinned_'.$source,array());
  }
  
  public function addPinTo($id, $source)
  {
    $pins = $this->getAttribute('spec_pinned_'.$source, array());
    if(array_search($id, $pins) === false)
      $pins[] = $id;
    $pins = array_unique($pins);
    $this->setAttribute('spec_pinned_'.$source,$pins);
    
  }

  public function getAllPinned($source)
  {
    return $this->getAttribute('spec_pinned_'.$source,array());
  }
  
  public function isPinned($id,$source)
  {
    $pins = $this->getAttribute('spec_pinned_'.$source, array());
    return (array_search($id, $pins) === false) ? false : true;
  }
}
