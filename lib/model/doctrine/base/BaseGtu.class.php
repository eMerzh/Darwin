<?php

/**
 * BaseGtu
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @property integer $id
 * @property string $code
 * @property integer $parent_ref
 * @property integer $gtu_from_date_mask
 * @property string $gtu_from_date
 * @property integer $gtu_to_date_mask
 * @property string $gtu_to_date
 * @property Gtu $Parent
 * @property Doctrine_Collection $TagGroups
 * @property Doctrine_Collection $Tags
 * @property Doctrine_Collection $Gtu
 * @property Doctrine_Collection $Soortenregister
 * @property Doctrine_Collection $Specimens
 * 
 * @method integer             getId()                 Returns the current record's "id" value
 * @method string              getCode()               Returns the current record's "code" value
 * @method integer             getParentRef()          Returns the current record's "parent_ref" value
 * @method integer             getGtuFromDateMask()    Returns the current record's "gtu_from_date_mask" value
 * @method string              getGtuFromDate()        Returns the current record's "gtu_from_date" value
 * @method integer             getGtuToDateMask()      Returns the current record's "gtu_to_date_mask" value
 * @method string              getGtuToDate()          Returns the current record's "gtu_to_date" value
 * @method Gtu                 getParent()             Returns the current record's "Parent" value
 * @method Doctrine_Collection getTagGroups()          Returns the current record's "TagGroups" collection
 * @method Doctrine_Collection getTags()               Returns the current record's "Tags" collection
 * @method Doctrine_Collection getGtu()                Returns the current record's "Gtu" collection
 * @method Doctrine_Collection getSoortenregister()    Returns the current record's "Soortenregister" collection
 * @method Doctrine_Collection getSpecimens()          Returns the current record's "Specimens" collection
 * @method Gtu                 setId()                 Sets the current record's "id" value
 * @method Gtu                 setCode()               Sets the current record's "code" value
 * @method Gtu                 setParentRef()          Sets the current record's "parent_ref" value
 * @method Gtu                 setGtuFromDateMask()    Sets the current record's "gtu_from_date_mask" value
 * @method Gtu                 setGtuFromDate()        Sets the current record's "gtu_from_date" value
 * @method Gtu                 setGtuToDateMask()      Sets the current record's "gtu_to_date_mask" value
 * @method Gtu                 setGtuToDate()          Sets the current record's "gtu_to_date" value
 * @method Gtu                 setParent()             Sets the current record's "Parent" value
 * @method Gtu                 setTagGroups()          Sets the current record's "TagGroups" collection
 * @method Gtu                 setTags()               Sets the current record's "Tags" collection
 * @method Gtu                 setGtu()                Sets the current record's "Gtu" collection
 * @method Gtu                 setSoortenregister()    Sets the current record's "Soortenregister" collection
 * @method Gtu                 setSpecimens()          Sets the current record's "Specimens" collection
 * 
 * @package    darwin
 * @subpackage model
 * @author     DB team <collections@naturalsciences.be>
 * @version    SVN: $Id: Builder.php 7380 2010-03-15 21:07:50Z jwage $
 */
abstract class BaseGtu extends sfDoctrineRecord
{
    public function setTableDefinition()
    {
        $this->setTableName('gtu');
        $this->hasColumn('id', 'integer', null, array(
             'type' => 'integer',
             'primary' => true,
             'autoincrement' => true,
             ));
        $this->hasColumn('code', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('parent_ref', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             'default' => 0,
             ));
        $this->hasColumn('gtu_from_date_mask', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             'default' => 0,
             ));
        $this->hasColumn('gtu_from_date', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             'default' => '0001-01-01',
             ));
        $this->hasColumn('gtu_to_date_mask', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             'default' => 0,
             ));
        $this->hasColumn('gtu_to_date', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             'default' => '0001-01-01',
             ));
    }

    public function setUp()
    {
        parent::setUp();
        $this->hasOne('Gtu as Parent', array(
             'local' => 'parent_ref',
             'foreign' => 'id'));

        $this->hasMany('TagGroups', array(
             'local' => 'id',
             'foreign' => 'gtu_ref'));

        $this->hasMany('Tags', array(
             'local' => 'id',
             'foreign' => 'gtu_ref'));

        $this->hasMany('Gtu', array(
             'local' => 'id',
             'foreign' => 'parent_ref'));

        $this->hasMany('Soortenregister', array(
             'local' => 'id',
             'foreign' => 'gtu_ref'));

        $this->hasMany('Specimens', array(
             'local' => 'id',
             'foreign' => 'gtu_ref'));
    }
}