<?php

/**
 * BaseMultimedia
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @property integer $id
 * @property string $referenced_relation
 * @property integer $record_id
 * @property boolean $is_digital
 * @property string $type
 * @property string $sub_type
 * @property string $title
 * @property string $description
 * @property string $uri
 * @property : { type: string } $filename
 * @property string $search_ts
 * @property string $creation_date
 * @property integer $creation_date_mask
 * @property string $mime_type
 * @property boolean $visible
 * @property boolean $publishable
 * 
 * @method integer    getId()                  Returns the current record's "id" value
 * @method string     getReferencedRelation()  Returns the current record's "referenced_relation" value
 * @method integer    getRecordId()            Returns the current record's "record_id" value
 * @method boolean    getIsDigital()           Returns the current record's "is_digital" value
 * @method string     getType()                Returns the current record's "type" value
 * @method string     getSubType()             Returns the current record's "sub_type" value
 * @method string     getTitle()               Returns the current record's "title" value
 * @method string     getDescription()         Returns the current record's "description" value
 * @method string     getUri()                 Returns the current record's "uri" value
 * @method string     getSearchTs()            Returns the current record's "search_ts" value
 * @method string     getCreationDate()        Returns the current record's "creation_date" value
 * @method integer    getCreationDateMask()    Returns the current record's "creation_date_mask" value
 * @method string     getMimeType()            Returns the current record's "mime_type" value
 * @method boolean    getVisible()             Returns the current record's "visible" value
 * @method boolean    getPublishable()         Returns the current record's "publishable" value
 * @method Multimedia setId()                  Sets the current record's "id" value
 * @method Multimedia setReferencedRelation()  Sets the current record's "referenced_relation" value
 * @method Multimedia setRecordId()            Sets the current record's "record_id" value
 * @method Multimedia setIsDigital()           Sets the current record's "is_digital" value
 * @method Multimedia setType()                Sets the current record's "type" value
 * @method Multimedia setSubType()             Sets the current record's "sub_type" value
 * @method Multimedia setTitle()               Sets the current record's "title" value
 * @method Multimedia setDescription()         Sets the current record's "description" value
 * @method Multimedia setUri()                 Sets the current record's "uri" value
 * @method Multimedia setSearchTs()            Sets the current record's "search_ts" value
 * @method Multimedia setCreationDate()        Sets the current record's "creation_date" value
 * @method Multimedia setCreationDateMask()    Sets the current record's "creation_date_mask" value
 * @method Multimedia setMimeType()            Sets the current record's "mime_type" value
 * @method Multimedia setVisible()             Sets the current record's "visible" value
 * @method Multimedia setPublishable()         Sets the current record's "publishable" value
 * 
 * @package    darwin
 * @subpackage model
 * @author     DB team <darwin-ict@naturalsciences.be>
 * @version    SVN: $Id: Builder.php 7490 2010-03-29 19:53:27Z jwage $
 */
abstract class BaseMultimedia extends sfDoctrineRecord
{
    public function setTableDefinition()
    {
        $this->setTableName('multimedia');
        $this->hasColumn('id', 'integer', null, array(
             'type' => 'integer',
             'primary' => true,
             'autoincrement' => true,
             ));
        $this->hasColumn('referenced_relation', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('record_id', 'integer', null, array(
             'type' => 'integer',
             ));
        $this->hasColumn('is_digital', 'boolean', null, array(
             'type' => 'boolean',
             'notnull' => true,
             'default' => true,
             ));
        $this->hasColumn('type', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             'default' => 'image',
             ));
        $this->hasColumn('sub_type', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('title', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('description', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             'default' => '',
             ));
        $this->hasColumn('uri', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('filename', ': { type: string }', null, array(
             'type' => ': { type: string }',
             ));
        $this->hasColumn('search_ts', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('creation_date', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             'default' => '0001-01-01',
             ));
        $this->hasColumn('creation_date_mask', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             'default' => 0,
             ));
        $this->hasColumn('mime_type', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('visible', 'boolean', null, array(
             'type' => 'boolean',
             'notnull' => true,
             'default' => true,
             ));
        $this->hasColumn('publishable', 'boolean', null, array(
             'type' => 'boolean',
             'notnull' => true,
             'default' => true,
             ));
    }

    public function setUp()
    {
        parent::setUp();
        
    }
}