<?php

/**
 * BaseVernacularNames
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @property integer $vernacular_class_ref
 * @property string $name
 * @property string $name_ts
 * @property string $country_language_full_text
 * @property VernacularNames $VernacularNames
 * 
 * @package    ##PACKAGE##
 * @subpackage ##SUBPACKAGE##
 * @author     ##NAME## <##EMAIL##>
 * @version    SVN: $Id: Builder.php 5845 2009-06-09 07:36:57Z jwage $
 */
abstract class BaseVernacularNames extends sfDoctrineRecord
{
    public function setTableDefinition()
    {
        $this->setTableName('vernacular_names');
        $this->hasColumn('vernacular_class_ref', 'integer', null, array(
             'type' => 'integer',
             'primary' => true,
             ));
        $this->hasColumn('name', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('name_ts', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('country_language_full_text', 'string', null, array(
             'type' => 'string',
             ));
    }

    public function setUp()
    {
        $this->hasOne('VernacularNames', array(
             'local' => 'vernacular_class_ref',
             'foreign' => 'id'));
    }
}