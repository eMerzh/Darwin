<?php

/**
 * BaseTagGroups
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @property integer $id
 * @property integer $gtu_ref
 * @property string $group_name
 * @property string $group_name_indexed
 * @property string $sub_group_name
 * @property string $sub_group_name_indexed
 * @property string $color
 * @property string $tag_value
 * @property string $international_name
 * @property Gtu $Gtu
 * @property Doctrine_Collection $Tags
 * 
 * @method integer             getId()                     Returns the current record's "id" value
 * @method integer             getGtuRef()                 Returns the current record's "gtu_ref" value
 * @method string              getGroupName()              Returns the current record's "group_name" value
 * @method string              getGroupNameIndexed()       Returns the current record's "group_name_indexed" value
 * @method string              getSubGroupName()           Returns the current record's "sub_group_name" value
 * @method string              getSubGroupNameIndexed()    Returns the current record's "sub_group_name_indexed" value
 * @method string              getColor()                  Returns the current record's "color" value
 * @method string              getTagValue()               Returns the current record's "tag_value" value
 * @method string              getInternationalName()      Returns the current record's "international_name" value
 * @method Gtu                 getGtu()                    Returns the current record's "Gtu" value
 * @method Doctrine_Collection getTags()                   Returns the current record's "Tags" collection
 * @method TagGroups           setId()                     Sets the current record's "id" value
 * @method TagGroups           setGtuRef()                 Sets the current record's "gtu_ref" value
 * @method TagGroups           setGroupName()              Sets the current record's "group_name" value
 * @method TagGroups           setGroupNameIndexed()       Sets the current record's "group_name_indexed" value
 * @method TagGroups           setSubGroupName()           Sets the current record's "sub_group_name" value
 * @method TagGroups           setSubGroupNameIndexed()    Sets the current record's "sub_group_name_indexed" value
 * @method TagGroups           setColor()                  Sets the current record's "color" value
 * @method TagGroups           setTagValue()               Sets the current record's "tag_value" value
 * @method TagGroups           setInternationalName()      Sets the current record's "international_name" value
 * @method TagGroups           setGtu()                    Sets the current record's "Gtu" value
 * @method TagGroups           setTags()                   Sets the current record's "Tags" collection
 * 
 * @package    darwin
 * @subpackage model
 * @author     DB team <darwin-ict@naturalsciences.be>
 * @version    SVN: $Id: Builder.php 7490 2010-03-29 19:53:27Z jwage $
 */
abstract class BaseTagGroups extends DarwinModel
{
    public function setTableDefinition()
    {
        $this->setTableName('tag_groups');
        $this->hasColumn('id', 'integer', null, array(
             'type' => 'integer',
             'primary' => true,
             'autoincrement' => true,
             ));
        $this->hasColumn('gtu_ref', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             ));
        $this->hasColumn('group_name', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('group_name_indexed', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('sub_group_name', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('sub_group_name_indexed', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('color', 'string', null, array(
             'type' => 'string',
             'default' => '#FFFFFF',
             ));
        $this->hasColumn('tag_value', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('international_name', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             'default' => '',
             ));
    }

    public function setUp()
    {
        parent::setUp();
        $this->hasOne('Gtu', array(
             'local' => 'gtu_ref',
             'foreign' => 'id'));

        $this->hasMany('Tags', array(
             'local' => 'id',
             'foreign' => 'group_ref'));
    }
}