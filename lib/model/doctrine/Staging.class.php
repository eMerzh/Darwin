<?php

/**
 * Staging
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @package    darwin
 * @subpackage model
 * @author     DB team <collections@naturalsciences.be>
 * @version    SVN: $Id: Builder.php 7490 2010-03-29 19:53:27Z jwage $
 */
class Staging extends BaseStaging
{
  public function getGtu()
  {
    return $this->_get('gtu_code');
  }
  
  public function getTaxon()
  {
    return $this->_get('taxon_name');
  }

  public function getChrono()
  {
    return $this->_get('chrono_name');
  }

  public function getLitho()
  {
    return $this->_get('litho_name');
  }

  public function getMineral()
  {
    return $this->_get('mineral_name');
  }

  public function getLithology()
  {
    return $this->_get('lithology_name');
  }

  public function getIg()
  {
    return $this->_get('ig_num');
  }

  public function getAcquisition()
  {
    return $this->_get('acquisition_category');
  }
  
  public function getStatusFor($field)
  {
    $emtpy = 'fld_empty';
    $tb_completed = 'fld_tocomplete';
    $tb_ok = 'fld_ok';
    if($this[$field] == '')
    {
      return $emtpy;
    }
    elseif($field == "taxon")
    {
      if($this['taxon_ref'] == '')
        return $tb_completed;
      else
        return $tb_ok;
    }
    elseif($field == "chrono")
    {
      if($this['chrono_ref'] == '')
        return $tb_completed;
      else
        return $tb_ok;
    }
    elseif($field == "litho")
    {
      if($this['litho_ref'] == '')
        return $tb_completed;
      else
        return $tb_ok;
    }
    elseif($field == "lithology")
    {
      if($this['lithology_ref'] == '')
        return $tb_completed;
      else
        return $tb_ok;
    }
    elseif($field == "mineral")
    {
      if($this['mineral_ref'] == '')
        return $tb_completed;
      else
        return $tb_ok;
    }
  }
}
