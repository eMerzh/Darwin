<?php

/**
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class Gtu extends BaseGtu
{
  public function getGtuFromDateMasked ()
  {
    $dateTime = new FuzzyDateTime($this->_get('gtu_from_date'), $this->_get('gtu_from_date_mask'),true, true);
    return $dateTime->getDateMasked();
  }
  
  public function getGtuToDateMasked ()
  {
    $dateTime = new FuzzyDateTime($this->_get('gtu_to_date'), $this->_get('gtu_to_date_mask'),false, true);
    return $dateTime->getDateMasked();
  }
  
  public function getGtuFromDate()
  {
    $from_date = new FuzzyDateTime($this->_get('gtu_from_date'), $this->_get('gtu_from_date_mask'),true,true);
    return $from_date->getDateTimeMaskedAsArray();
  }

  public function getGtuToDate()
  {
    $to_date = new FuzzyDateTime($this->_get('gtu_to_date'), $this->_get('gtu_to_date_mask'), false,true);
    return $to_date->getDateTimeMaskedAsArray();
  }

  public function setGtuFromDate($fd)
  {
    if ($fd instanceof FuzzyDateTime)
    {
      $this->_set('gtu_from_date', $fd->format('Y/m/d H:i:s'));
      $this->_set('gtu_from_date_mask', $fd->getMask());
    }
    else
    {
      $dateTime = new FuzzyDateTime($fd, 56, true,true); 
      $this->_set('gtu_from_date', $dateTime->format('Y/m/d H:i:s'));
      $this->_set('gtu_from_date_mask', $dateTime->getMask());
    }
  }

  public function setGtuToDate($fd)
  {
    if ($fd instanceof FuzzyDateTime)
    {
      $this->_set('gtu_to_date', $fd->format('Y/m/d H:i:s'));
      $this->_set('gtu_to_date_mask', $fd->getMask());
    }
    else
    {
      $dateTime = new FuzzyDateTime($fd, 56, false,true); 
      $this->_set('gtu_to_date', $dateTime->format('Y/m/d H:i:s'));
      $this->_set('gtu_to_date_mask', $dateTime->getMask());
    }
  }

  public function getName($view = null)
  {
    if($this->_get('id')==0) return '-';
    $nbr = count($this->TagGroups);
    if(! $nbr) return "No Tags";
    $str = '<ul  class="search_tags">';
    foreach($this->TagGroups as $group)
    {
      $str .= '<li><label>'.$group->getSubGroupName().'<span class="gtu_group"> - '.TagGroups::getGroup($group->getGroupName()).'</span></label><ul class="name_tags'.($view!=null?"_view":"").'">';
      $tags = explode(";",$group->getTagValue());
      foreach($tags as $value)
        if (strlen($value))
          $str .=  '<li>' . trim($value).'</li>';
      $str .= '</ul><div class="clear"></div>';
    }
    $str .= '</ul>';
    return $str;
  }

  public function getMap()
  {
    if( $this->getLatitude() != '' && $this->getLongitude()!= '')
      return '<img class="gtu_img_loc" src="http://dev.openstreetmap.de/staticmap/staticmap.php?&size=480x240&center='.$this->getLatitude().','.$this->getLongitude().'&zoom=5&markers='.$this->getLatitude().','.$this->getLongitude().',red-pushpin" alt="Sampling location" />';
    return '';
  }
  public function getTagsWithCode($view = null)
  {
    $str = $this->getName($view);
    if($this->getLongitude() != '')
      $str .= '<b class="img">'.$this->getMap().'</b>';
    $str .=  '<b class="code">'.$this->getCode().'</b>';
    $str .=  '<b class="lat">'.$this->getLatitude().'</b>';
    $str .=  '<b class="lon">'.$this->getLongitude().'</b>';
    $str .=  '<b class="date_from">'.$this->getGtuFromDateMasked().'</b>';
    $str .=  '<b class="date_to">'.$this->getGtuToDateMasked().'</b>';

    return $str;
  }

  public function getCode()
  {
    if(! $this->isNew() && $this->_get('id')==0)
      return '-';
    return $this->_get('code');
  }
}
