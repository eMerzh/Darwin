<?php

/**
 * BaseMySavedSearches
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @property integer $user_ref
 * @property string $name
 * @property string $search_criterias
 * @property boolean $favorite
 * @property timestamp $modification_date_time
 * @property string $visible_fields_in_result
 * @property Users $User
 * 
 * @package    ##PACKAGE##
 * @subpackage ##SUBPACKAGE##
 * @author     ##NAME## <##EMAIL##>
 * @version    SVN: $Id: Builder.php 5845 2009-06-09 07:36:57Z jwage $
 */
abstract class BaseMySavedSearches extends sfDoctrineRecord
{
    public function setTableDefinition()
    {
        $this->setTableName('my_saved_searches');
        $this->hasColumn('user_ref', 'integer', null, array(
             'type' => 'integer',
             'primary' => true,
             ));
        $this->hasColumn('name', 'string', null, array(
             'type' => 'string',
             'primary' => true,
             ));
        $this->hasColumn('search_criterias', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('favorite', 'boolean', null, array(
             'type' => 'boolean',
             'notnull' => true,
             'default' => false,
             ));
        $this->hasColumn('modification_date_time', 'timestamp', null, array(
             'type' => 'timestamp',
             'notnull' => true,
             ));
        $this->hasColumn('visible_fields_in_result', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
    }

    public function setUp()
    {
        $this->hasOne('Users as User', array(
             'local' => 'user_ref',
             'foreign' => 'id'));
    }
}