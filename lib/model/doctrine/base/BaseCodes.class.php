<?php

/**
 * BaseCodes
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @property integer $id
 * @property string $referenced_relation
 * @property integer $record_id
 * @property string $code_category
 * @property string $code_prefix
 * @property string $code_prefix_separator
 * @property string $code
 * @property string $code_suffix
 * @property string $code_suffix_separator
 * @property string $full_code_indexed
 * @property string $full_code_order_by
 * @property string $code_date
 * @property integer $code_date_mask
 * 
 * @method integer getId()                    Returns the current record's "id" value
 * @method string  getReferencedRelation()    Returns the current record's "referenced_relation" value
 * @method integer getRecordId()              Returns the current record's "record_id" value
 * @method string  getCodeCategory()          Returns the current record's "code_category" value
 * @method string  getCodePrefix()            Returns the current record's "code_prefix" value
 * @method string  getCodePrefixSeparator()   Returns the current record's "code_prefix_separator" value
 * @method string  getCode()                  Returns the current record's "code" value
 * @method string  getCodeSuffix()            Returns the current record's "code_suffix" value
 * @method string  getCodeSuffixSeparator()   Returns the current record's "code_suffix_separator" value
 * @method string  getFullCodeIndexed()       Returns the current record's "full_code_indexed" value
 * @method string  getFullCodeOrderBy()       Returns the current record's "full_code_order_by" value
 * @method string  getCodeDate()              Returns the current record's "code_date" value
 * @method integer getCodeDateMask()          Returns the current record's "code_date_mask" value
 * @method Codes   setId()                    Sets the current record's "id" value
 * @method Codes   setReferencedRelation()    Sets the current record's "referenced_relation" value
 * @method Codes   setRecordId()              Sets the current record's "record_id" value
 * @method Codes   setCodeCategory()          Sets the current record's "code_category" value
 * @method Codes   setCodePrefix()            Sets the current record's "code_prefix" value
 * @method Codes   setCodePrefixSeparator()   Sets the current record's "code_prefix_separator" value
 * @method Codes   setCode()                  Sets the current record's "code" value
 * @method Codes   setCodeSuffix()            Sets the current record's "code_suffix" value
 * @method Codes   setCodeSuffixSeparator()   Sets the current record's "code_suffix_separator" value
 * @method Codes   setFullCodeIndexed()       Sets the current record's "full_code_indexed" value
 * @method Codes   setFullCodeOrderBy()       Sets the current record's "full_code_order_by" value
 * @method Codes   setCodeDate()              Sets the current record's "code_date" value
 * @method Codes   setCodeDateMask()          Sets the current record's "code_date_mask" value
 * 
 * @package    darwin
 * @subpackage model
 * @author     DB team <darwin-ict@naturalsciences.be>
 * @version    SVN: $Id: Builder.php 7490 2010-03-29 19:53:27Z jwage $
 */
abstract class BaseCodes extends sfDoctrineRecord
{
    public function setTableDefinition()
    {
        $this->setTableName('codes');
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
             'notnull' => true,
             ));
        $this->hasColumn('code_category', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             'default' => 'main',
             ));
        $this->hasColumn('code_prefix', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('code_prefix_separator', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('code', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('code_suffix', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('code_suffix_separator', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('full_code_indexed', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('full_code_order_by', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('code_date', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('code_date_mask', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             'default' => 0,
             ));
    }

    public function setUp()
    {
        parent::setUp();
        
    }
}