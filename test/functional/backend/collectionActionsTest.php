<?php

include(dirname(__FILE__).'/../../bootstrap/functional.php');

$browser = new DarwinTestFunctional(new sfBrowser());
$browser->loadData($configuration)->login('root','evil');

$browser->
  info('Index')->
  get('/collection/index')->

  with('request')->begin()->
    isParameter('module', 'collection')->
    isParameter('action', 'index')->
  end()->

  with('response')->begin()->
    isStatusCode(200)->
    checkElement('h1', 'Collection List')->
    checkElement('h2:last','UGMM')->
    checkElement('.treelist:first > ul > li',1)->
    checkElement('.treelist:first > ul > li:first span','/Vertebrates/')->
    checkElement('.treelist:first > ul > li:first span a img')->
    checkElement('.treelist:first > ul > li:first > ul > li',2)->
    checkElement('.treelist:first > ul > li:first > ul > li:first span', '/Amphibia/')->
    checkElement('.treelist:last > ul > li',1)->
  end()->
  
  info('New')->
  get('/collection/new')->

  with('request')->begin()->
    isParameter('module', 'collection')->
    isParameter('action', 'new')->
  end()->

  with('response')->begin()->
    isStatusCode(200)->
  end()->
  click('Save', array('collections' => array(
    'name'            => '',
    'institution_ref' => '',
    'collection_type' => '',
    'code'            => '',
    'main_manager_ref'=> '',
    'parent_ref'      => '',
  )))->

  with('form')->begin()->
    hasErrors(5)->
    isError('name', 'required')->
    isError('code', 'required')->
    isError('institution_ref', 'required')->
    isError('collection_type', 'required')->
    isError('main_manager_ref', 'required')->
  end()->

  with('request')->begin()->
    isParameter('module', 'collection')->
    isParameter('action', 'create')->
  end()->
  
  click('Save', array('collections' => array(
    'name'            => 'Paléonotologie',
    'institution_ref' => Doctrine::getTable('People')->findOneByFamilyName('Institut Royal des Sciences Naturelles de Belgique')->getId(),
    'collection_type' => 'mix',
    'code'            => 'paleo',
    'main_manager_ref'=> Doctrine::getTable('Users')->findOneByFamilyName('Evil')->getId(),
    'parent_ref'      => '',
  )))->
  followRedirect()->
  
  with('request')->begin()->
    isParameter('module', 'collection')->
    isParameter('action', 'edit')->
  end()->

  with('response')->begin()->
    isStatusCode(200)->
  end()->
  
  get('/collection/index')->
  info('Edit')->
  click('span > a', array(), array('position' => 5))->
  with('request')->begin()->
    isParameter('module', 'collection')->
    isParameter('action', 'edit')->
  end()->

   with('response')->begin()->
    isStatusCode(200)->
    checkElement('input[value="Aves"]')->
  end()->
  click('Save',array('collections' => 
    array(
    'name'            => 'Paléonotologie',
    'institution_ref' => Doctrine::getTable('People')->findOneByFamilyName('UGMM')->getId(),
    'collection_type' => 'mix',
    'code'            => 'paleo',
    'main_manager_ref'=> Doctrine::getTable('Users')->findOneByFamilyName('Evil')->getId(),
    'parent_ref'      => Doctrine::getTable('Collections')->findOneByName('Molusca')->getId(),
        )))->
  followRedirect()->

  with('request')->begin()->
    isParameter('module', 'collection')->
    isParameter('action', 'edit')->
  end()->

  get('/collection/index')->
  with('response')->begin()->
    isStatusCode(200)->
    checkElement('.treelist:first > ul > li',2)->
    checkElement('.treelist:last > ul > li',1)->
    checkElement('.treelist:last > ul > li > ul > li',1)->
  end()->


 info('Delete')->
  click('span > a', array(), array('position' => 5))->
  with('request')->begin()->
    isParameter('module', 'collection')->
    isParameter('action', 'edit')->
  end()->
  click('Delete')->
  followRedirect()->

  with('request')->begin()->
    isParameter('module', 'collection')->
    isParameter('action', 'index')->
  end()->
  
  with('response')->begin()->
    isStatusCode(200)->
    checkElement('.treelist:first > ul > li',1)->
  end();

$user_id = $browser->addCustomUserAndLogin();
$collection_id = Doctrine::getTable('collections')->getCollectionByName('Vertebrates')->getId() ;

$browser->
  info('sub collection right')->
  get('collection/rights/user_ref/'.$user_id.'/collection_ref/'.$collection_id)->
  with('request')->begin()->
    isParameter('module', 'collection')->
    isParameter('action', 'rights')->
  end()->
  with('response')->begin()->
    isStatusCode(200)->//debug()->
    checkElement('.treelist:first > ul > li:first span','/Amphibia/')->
  end()->

  click('Save',  array('sub_collection' => array(
    'SubCollectionsRights' => array(
      0 => array(
        'user_ref'       => $user_id,
        'collection_ref' => Doctrine::getTable('collections')->getCollectionByName('Amphibia')->getId(),
        'check_right' => true),
      1 => array(
        'user_ref'       => $user_id,
        'collection_ref' => Doctrine::getTable('collections')->getCollectionByName('Fossile Aves')->getId(),
        'check_right' => false)
    )
    )));
    
$browser->
  info('sub collection right')->
  get('collection/edit/id/'.Doctrine::getTable('collections')->getCollectionByName('Amphibia')->getId())->
  with('request')->begin()->
    isParameter('module', 'collection')->
    isParameter('action', 'edit')->
  end()->
  with('response')->begin()->
    isStatusCode(200)->
// @ TODO: Y!, you should rework this line because I don't find any reference to what you're looking for here - P!
//     checkElement('#'.$user_id.' > td:first > label',Doctrine::getTable('users')->findUser($user_id)->getFormatedName())->
    end()->
    
  get('collection/edit/id/'.Doctrine::getTable('collections')->getCollectionByName('Fossile Aves')->getId())->
  with('request')->begin()->
    isParameter('module', 'collection')->
    isParameter('action', 'edit')->
  end()->
  with('response')->begin()->
    isStatusCode(200)->
    checkElement('#'.$user_id,null)->
    end();

$vertebrates = Doctrine::getTable('Collections')->findOneByName('Vertebrates');
$vertId = $vertebrates->getId();

$browser->
  info('Get vertebrate collection for specimen codes default values check')->
  get('collection/edit', array('id'=>$vertId))->
  with('response')->
  begin()->
    isStatusCode(200)->
    checkElement('li#collectionsCodes div.widget_content table tbody tr', 1)->
    checkElement('li#collectionsCodes div.widget_content table tbody tr td', 8)->
    checkElement('li#collectionsCodes div.widget_content table tbody tr td:first', '/VERT./')->
    checkElement('li#collectionsCodes div.widget_content table tbody tr td:nth-child(7) a.link_catalogue', 1)->
    checkElement('li#collectionsCodes div.widget_content table tbody tr td:last a.widget_row_delete', 1)->
  end()->
  click('li#collectionsCodes div.widget_content table tbody tr td:nth-child(7) a.link_catalogue')->
  with('response')->
  begin()->
    isStatusCode(200)->
    checkElement('div#collections_codes_screen form#collections_codes_form', 1)->
    checkElement('div#collections_codes_screen form#collections_codes_form table tbody tr', 7)->
    checkElement('div#collections_codes_screen form#collections_codes_form table tbody tr:nth-child(2) td input#collections_code_prefix', 1)->
    checkElement('div#collections_codes_screen form#collections_codes_form table tbody tr:nth-child(3) td input#collections_code_prefix_separator', 1)->
    checkElement('div#collections_codes_screen form#collections_codes_form table tbody tr:nth-child(4) td input#collections_code_suffix_separator', 1)->
    checkElement('div#collections_codes_screen form#collections_codes_form table tbody tr:nth-child(5) td input#collections_code_suffix', 1)->
    checkElement('div#collections_codes_screen form#collections_codes_form table tbody tr:nth-child(6) td input#collections_code_auto_increment', 1)->
    checkElement('div#collections_codes_screen form#collections_codes_form table tbody tr:last td input#collections_code_part_code_auto_copy', 1)->
  end()->
  click('a.delete_button')->
  with('response')->
  begin()->
    isStatusCode(200)->
    matches('/ok/')->
  end();

$vertebrates = Doctrine::getTable('Collections')->findOneByName('Vertebrates');

$browser->test()->is($vertebrates->getCodePrefix(), '', 'The code prefix has been well reset');
$collection_id = $browser->addCustomCollection('12345','Collection for test');

$browser->
  info('test if the two collector exist')->
  get('collection/edit?id='.$collection_id)->
  with('response')->
  begin()->
    isStatusCode(200)->
  end();
  