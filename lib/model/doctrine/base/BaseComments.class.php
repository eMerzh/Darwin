<?php

/**
 * BaseComments
 * 
 * This class has been auto-generated by the Doctrine ORM Framework
 * 
 * @property integer $id
 * @property string $table_name
 * @property integer $record_id
 * @property string $notion_concerned
 * @property string $comment
 * @property string $comment_ts
 * @property string $comment_language_full_text
 * 
 * @package    ##PACKAGE##
 * @subpackage ##SUBPACKAGE##
 * @author     ##NAME## <##EMAIL##>
 * @version    SVN: $Id: Builder.php 5845 2009-06-09 07:36:57Z jwage $
 */
abstract class BaseComments extends sfDoctrineRecord
{
    public function setTableDefinition()
    {
        $this->setTableName('comments');
        $this->hasColumn('id', 'integer', null, array(
             'type' => 'integer',
             'primary' => true,
             'autoincrement' => true,
             ));
        $this->hasColumn('table_name', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('record_id', 'integer', null, array(
             'type' => 'integer',
             'notnull' => true,
             ));
        $this->hasColumn('notion_concerned', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('comment', 'string', null, array(
             'type' => 'string',
             'notnull' => true,
             ));
        $this->hasColumn('comment_ts', 'string', null, array(
             'type' => 'string',
             ));
        $this->hasColumn('comment_language_full_text', 'string', null, array(
             'type' => 'string',
             ));
    }

}