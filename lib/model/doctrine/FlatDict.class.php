<?php

/**
 * FlatDict
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @package    darwin
 * @subpackage model
 * @author     DB team <collections@naturalsciences.be>
 * @version    SVN: $Id: Builder.php 7490 2010-03-29 19:53:27Z jwage $
 */
class FlatDict extends BaseFlatDict
{
 public function getTypeFormated()
  {
    return ucfirst($this->_get('dict_value'));
  }

  public function getTypeSearchFormated()
  {
    return ucfirst($this->_get('dict_value'));
  }

  public function getTypeGroupFormated()
  {
    return ucfirst($this->_get('dict_value'));
  }

  public function getSexFormated()
  {
    if ($this->_get('dict_value') == 'undefined')
      return '-';
    return ucfirst($this->_get('dict_value'));
  }

  public function getSexSearchFormated()
  {
    return ucfirst($this->_get('dict_value'));
  }

  public function getStateFormated()
  {
    if ($this->_get('dict_value') == 'not applicable')
      return '-';
    return ucfirst($this->_get('dict_value'));
  }

  public function getStateSearchFormated()
  {
    return ucfirst($this->_get('dict_value'));
  }

  public function getStageFormated()
  {
    if ($this->_get('dict_value') == 'undefined')
      return '-';
    return ucfirst($this->_get('dict_value'));
  }

  public function getStageSearchFormated()
  {
    return ucfirst($this->_get('dict_value'));
  }

  public function getSocialStatusFormated()
  {
    if ($this->_get('dict_value') == 'not applicable')
      return '-';
    return ucfirst($this->_get('dict_value'));
  }

  public function getSocialStatusSearchFormated()
  {
    return ucfirst($this->_get('dict_value'));
  }

  public function getRockFormFormated()
  {
    if ($this->_get('dict_value') == 'not applicable')
      return '-';
    return ucfirst($this->_get('dict_value'));
  }

  public function getRockFormSearchFormated()
  {
    return ucfirst($this->_get('dict_value'));
  }

}
