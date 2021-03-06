<?php

/**
 * BaseReports
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @property integer $id
 * @property integer $user_ref
 * @property string $name
 * @property string $uri
 * @property string $lang
 * @property string $format
 * @property string $parameters
 * @property string $comment
 * @property Users $Users
 * 
 * @method integer getId()         Returns the current record's "id" value
 * @method integer getUserRef()    Returns the current record's "user_ref" value
 * @method string  getName()       Returns the current record's "name" value
 * @method string  getUri()        Returns the current record's "uri" value
 * @method string  getLang()       Returns the current record's "lang" value
 * @method string  getFormat()     Returns the current record's "format" value
 * @method string  getParameters() Returns the current record's "parameters" value
 * @method string  getComment()    Returns the current record's "comment" value
 * @method Users   getUsers()      Returns the current record's "Users" value
 * @method Reports setId()         Sets the current record's "id" value
 * @method Reports setUserRef()    Sets the current record's "user_ref" value
 * @method Reports setName()       Sets the current record's "name" value
 * @method Reports setUri()        Sets the current record's "uri" value
 * @method Reports setLang()       Sets the current record's "lang" value
 * @method Reports setFormat()     Sets the current record's "format" value
 * @method Reports setParameters() Sets the current record's "parameters" value
 * @method Reports setComment()    Sets the current record's "comment" value
 * @method Reports setUsers()      Sets the current record's "Users" value
 * 
 * @package    darwin
 * @subpackage model
 * @author     DB team <darwin-ict@naturalsciences.be>
 * @version    SVN: $Id: Builder.php 7490 2010-03-29 19:53:27Z jwage $
 */
abstract class BaseReports extends DarwinModel
{
    public function setTableDefinition()
    {
        $this->setTableName('reports');
        $this->hasColumn('id', 'integer', null, array(
             'type' => 'integer',
             'primary' => true,
             'autoincrement' => true,
             ));
        $this->hasColumn('user_ref', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             ));
        $this->hasColumn('name', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('uri', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('lang', 'string', 2, array(
             'type' => 'string',
             'notnull' => true,
             'length' => 2,
             ));
        $this->hasColumn('format', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             'default' => 'csv',
             ));
        $this->hasColumn('parameters', 'string', null, array(
             'type' => 'string',
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
