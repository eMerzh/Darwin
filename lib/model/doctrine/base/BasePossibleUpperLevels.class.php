<?php

/**
 * BasePossibleUpperLevels
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @property integer $level_ref
 * @property integer $level_upper_ref
 * @property CatalogueLevels $UpperLevel
 * @property CatalogueLevels $Level
 * 
 * @package    ##PACKAGE##
 * @subpackage ##SUBPACKAGE##
 * @author     ##NAME## <##EMAIL##>
 * @version    SVN: $Id: Builder.php 5845 2009-06-09 07:36:57Z jwage $
 */
abstract class BasePossibleUpperLevels extends sfDoctrineRecord
{
    public function setTableDefinition()
    {
        $this->setTableName('possible_upper_levels');
        $this->hasColumn('level_ref', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             ));
        $this->hasColumn('level_upper_ref', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             ));
    }

    public function setUp()
    {
        $this->hasOne('CatalogueLevels as UpperLevel', array(
             'local' => 'level_upper_ref',
             'foreign' => 'id'));

        $this->hasOne('CatalogueLevels as Level', array(
             'local' => 'level_ref',
             'foreign' => 'id'));
    }
}