<?php

/**
 * BaseInformativeWorkflow
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @property integer $id
 * @property integer $record_id
 * @property string $referenced_relation
 * @property integer $user_ref
 * @property string $formated_name
 * @property string $status
 * @property string $modification_date_time
 * @property string $comment
 * @property Users $Users
 * 
 * @method integer             getId()                     Returns the current record's "id" value
 * @method integer             getRecordId()               Returns the current record's "record_id" value
 * @method string              getReferencedRelation()     Returns the current record's "referenced_relation" value
 * @method integer             getUserRef()                Returns the current record's "user_ref" value
 * @method string              getFormatedName()           Returns the current record's "formated_name" value
 * @method string              getStatus()                 Returns the current record's "status" value
 * @method string              getModificationDateTime()   Returns the current record's "modification_date_time" value
 * @method string              getComment()                Returns the current record's "comment" value
 * @method Users               getUsers()                  Returns the current record's "Users" value
 * @method InformativeWorkflow setId()                     Sets the current record's "id" value
 * @method InformativeWorkflow setRecordId()               Sets the current record's "record_id" value
 * @method InformativeWorkflow setReferencedRelation()     Sets the current record's "referenced_relation" value
 * @method InformativeWorkflow setUserRef()                Sets the current record's "user_ref" value
 * @method InformativeWorkflow setFormatedName()           Sets the current record's "formated_name" value
 * @method InformativeWorkflow setStatus()                 Sets the current record's "status" value
 * @method InformativeWorkflow setModificationDateTime()   Sets the current record's "modification_date_time" value
 * @method InformativeWorkflow setComment()                Sets the current record's "comment" value
 * @method InformativeWorkflow setUsers()                  Sets the current record's "Users" value
 * 
 * @package    darwin
 * @subpackage model
 * @author     DB team <collections@naturalsciences.be>
 * @version    SVN: $Id: Builder.php 7490 2010-03-29 19:53:27Z jwage $
 */
abstract class BaseInformativeWorkflow extends sfDoctrineRecord
{
    public function setTableDefinition()
    {
        $this->setTableName('informative_workflow');
        $this->hasColumn('id', 'integer', null, array(
             'type' => 'integer',
             'primary' => true,
             'autoincrement' => true,
             ));
        $this->hasColumn('record_id', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             ));
        $this->hasColumn('referenced_relation', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('user_ref', 'integer', null, array(
             'type' => 'integer',
             ));
        $this->hasColumn('formated_name', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('status', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('modification_date_time', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('comment', 'string', null, array(
             'type' => 'string',
             ));
    }

    public function setUp()
    {
        parent::setUp();
        $this->hasOne('Users', array(
             'local' => 'user_ref',
             'foreign' => 'id'));
    }
}