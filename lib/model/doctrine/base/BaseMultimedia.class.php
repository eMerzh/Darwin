<?php

/**
 * BaseMultimedia
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @property integer $id
 * @property boolean $is_digital
 * @property string $type
 * @property string $sub_type
 * @property string $title
 * @property string $title_indexed
 * @property string $subject
 * @property string $coverage
 * @property string $apercu_path
 * @property string $copyright
 * @property string $license
 * @property string $uri
 * @property string $descriptive_ts
 * @property string $descriptive_language_full_text
 * @property date $creation_date
 * @property integer $creation_date_mask
 * @property date $publication_date_from
 * @property integer $publication_date_from_mask
 * @property date $publication_date_to
 * @property integer $publication_date_to_mask
 * @property integer $parent_ref
 * @property string $path
 * @property string $mime_type
 * @property Multimedia $Parent
 * @property Doctrine_Collection $Multimedia
 * @property Doctrine_Collection $PeopleMultimedia
 * @property Doctrine_Collection $UsersMultimedia
 * @property Doctrine_Collection $MyPreferences
 * @property Doctrine_Collection $MultimediaKeywords
 * @property Doctrine_Collection $AssociatedMultimedia
 * 
 * @package    ##PACKAGE##
 * @subpackage ##SUBPACKAGE##
 * @author     ##NAME## <##EMAIL##>
 * @version    SVN: $Id: Builder.php 5845 2009-06-09 07:36:57Z jwage $
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
        $this->hasColumn('is_digital', 'boolean', null, array(
             'type' => 'boolean',
             'notnull' => true,
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
        $this->hasColumn('title_indexed', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('subject', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             'default' => '/',
             ));
        $this->hasColumn('coverage', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             'default' => 'temporal',
             ));
        $this->hasColumn('apercu_path', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('copyright', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('license', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('uri', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('descriptive_ts', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('descriptive_language_full_text', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('creation_date', 'date', null, array(
             'type' => 'date',
             'notnull' => true,
             'default' => '0001-01-01',
             ));
        $this->hasColumn('creation_date_mask', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             'default' => 0,
             ));
        $this->hasColumn('publication_date_from', 'date', null, array(
             'type' => 'date',
             'notnull' => true,
             'default' => '0001-01-01',
             ));
        $this->hasColumn('publication_date_from_mask', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             'default' => 0,
             ));
        $this->hasColumn('publication_date_to', 'date', null, array(
             'type' => 'date',
             'notnull' => true,
             'default' => '0001-01-01',
             ));
        $this->hasColumn('publication_date_to_mask', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             'default' => 0,
             ));
        $this->hasColumn('parent_ref', 'integer', null, array(
             'type' => 'integer',
             ));
        $this->hasColumn('path', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             'default' => '/',
             ));
        $this->hasColumn('mime_type', 'string', null, array(
             'type' => 'string',
             ));
    }

    public function setUp()
    {
        $this->hasOne('Multimedia as Parent', array(
             'local' => 'parent_ref',
             'foreign' => 'id'));

        $this->hasMany('Multimedia', array(
             'local' => 'id',
             'foreign' => 'parent_ref'));

        $this->hasMany('PeopleMultimedia', array(
             'local' => 'id',
             'foreign' => 'object_ref'));

        $this->hasMany('UsersMultimedia', array(
             'local' => 'id',
             'foreign' => 'object_ref'));

        $this->hasMany('MyPreferences', array(
             'local' => 'id',
             'foreign' => 'icon_ref'));

        $this->hasMany('MultimediaKeywords', array(
             'local' => 'id',
             'foreign' => 'object_ref'));

        $this->hasMany('AssociatedMultimedia', array(
             'local' => 'id',
             'foreign' => 'multimedia_ref'));
    }
}