<?php

include(dirname(__FILE__).'/../../bootstrap/functional.php');

$browser = new DarwinTestFunctional(new sfBrowser());
$browser->loadData($configuration)->login('root','evil');

$taxon = Doctrine::getTable('Taxonomy')->findOneByName('Falco Peregrinus Tunstall, 1771');
$taxonId = $taxon->getId();
$collection = Doctrine::getTable('Collections')->findOneByName('Aves');
$collectionId = $collection->getId();
$collection->setCodePrefix('AVES');
$collection->setCodePrefixSeparator('/');
$collection->setCodeSuffix('LOULOU');
$collection->setCodeSuffixSeparator('-');
$collection->save();

$browser->
  info('1 - New Specimen screen')->
  get('/specimen/new')->

  with('request')->begin()->
    isParameter('module', 'specimen')->
    isParameter('action', 'new')->
  end()->

  info('1.1 - is everything ok on screen')->
  with('response')->begin()->
    isStatusCode(200)->
    checkElement('title','Add Specimens')->
    checkElement('.board_col',2)->
    checkElement('.board_col:first .widget',5)->
    checkElement('.board_col:last .widget',4)->
    checkElement('.board_col:first .widget:first .widget_top_bar span','Collection')->
    checkElement('.board_col:first .widget:nth-child(2) .widget_top_bar span','Codes')->
    checkElement('.board_col:first .widget:nth-child(2) .widget_content thead tr',2)->
    checkElement('.board_col:first .widget:nth-child(2) .widget_content thead tr:first th',7)->
    checkElement('.board_col:first .widget:nth-child(2) .widget_content thead tr:nth-child(2) th',5)->
    checkElement('.board_col:first .widget:nth-child(2) .widget_content tbody#codes tr td',7)->
    checkElement('.board_col:first .widget:nth-child(2) .widget_content tbody#codes tr td:first select option',3)->
    checkElement('.board_col:first .widget:nth-child(2) .widget_content tbody#codes tr td:first select option[selected="selected"]','Main')->
    checkElement('.board_col:first .widget:nth-child(2) .widget_content tbody#codes tr td:nth-child(2) input',1)->
    checkElement('.board_col:last .widget:first .widget_top_bar span','Acquisition')->
    checkElement('.board_col:last .widget:nth-child(2) .widget_top_bar span','Expedition')->
    checkElement('.board_col:last .widget:nth-child(3) .widget_top_bar span','I.G. number')->
    checkElement('.board_col:last .widget:nth-child(4) .widget_top_bar span','Sampling location')->
  end()->
  info('1.2 - Fill in infos for this new specimen and for a code for this new specimen')->
  click('Submit', array('collection_ref'=>$collectionId, 'taxon_ref'=>$taxonId, 'code'=>1, 'newCode'=>array('0'=>array('code_category'=>'secondary','referenced_relation'=>'specimens','code_prefix'=>'AVES','code_prefix_separator'=>'/','code'=>'blabla', 'code_suffix_separator'=>'-','code_suffix'=>'LOULOU'))))->
  with('response')->begin()->
    isStatusCode(200)->
    matches('/ok/')->
  end();

$browser->
  info('2 - Specimen search')->
  get('/specimen/index')->

  with('request')->begin()->
    isParameter('module', 'specimen')->
    isParameter('action', 'index')->
  end()->

  info('2.1 - is everything ok on screen')->
  with('response')->begin()->
    isStatusCode(200)->
    checkElement('table#search tbody tr td:first input#searchSpecimen_taxon_name',1)->
    checkElement('table#search tbody tr td:first input#searchSpecimen_caller_id',1)->
    checkElement('table#search tbody tr td:last select#searchSpecimen_taxon_level',1)->
    checkElement('table#search tbody tr td:last select#searchSpecimen_taxon_level option',55)->
  end()->
  info('2.2 - Post waiting for the full results table and the pager')->
  post('/specimen/search', array('is_choose'=>0, 'searchSpecimen'=>array('taxon_name'=>'', 'taxon_level'=>'')))->
  with('response')->
  begin()->
    isStatusCode()->
    checkElement('ul.pager_nav li', 10)->
    checkElement('ul.pager_nav li.page_selected', '[1]')->
    checkElement('.pager li a span.nav_arrow', 0)->
    checkElement('div.paging_info table td:nth-child(2)', 1)->
    checkElement('div.paging_info table td:last-child select[id="searchSpecimen_rec_per_page"]', 1)->
    checkElement('table.results tbody tr', 3)->
    checkElement('table.results tbody tr td:nth-child(2)', 'Animalia')->
    checkElement('table.results thead th:nth-child(2) a.sort span.order_sign_down')->
  end()->  
  info('2.3 - Click to sort on name descending...')->
  post('/specimen/search', array('orderby'=>'t.name', 'orderdir'=>'desc', 'page'=>1, 'is_choose'=>0, 'searchSpecimen'=>array('taxon_name'=>'', 'taxon_level'=>'')))->
  with('response')->
  begin()->
    checkElement('table.results thead th:nth-child(2) a.sort span.order_sign_up')->
    checkElement('table.results tbody tr td:nth-child(2)', 'Falco Peregrinus Tunstall, 1771')->
  end()->
  info('2.4 - Select only species level...')->
  post('/specimen/search', array('orderby'=>'t.name', 'orderdir'=>'asc', 'page'=>1, 'is_choose'=>0, 'searchSpecimen'=>array('taxon_name'=>'', 'taxon_level'=>'48')))->
  with('response')->
  begin()->
    checkElement('table.results tbody tr', 1)->
    checkElement('table.results tbody tr td:nth-child(2)', 'Falco Peregrinus')->
  end()->
  info('2.5 - Click on edition...')->
  click('.edit a')->
  with('response')->
  begin()->
    isStatusCode(200)->
    checkElement('title','Add Specimens')->
    checkElement('.board_col',2)->
    checkElement('.board_col:first .widget',5)->
    checkElement('.board_col:last .widget',4)->
    checkElement('.board_col:first .widget:first .widget_top_bar span','Collection')->
    checkElement('.board_col:first .widget:first .widget_content div#specimen_collection_ref_name','Vertebrates')->
    checkElement('.board_col:first .widget:nth-child(2) .widget_top_bar span','Codes')->
    checkElement('.board_col:first .widget:nth-child(2) .widget_content div#specimen_taxon_ref_name','Falco Peregrinus')->
    checkElement('.board_col:last .widget:first .widget_top_bar span','Acquisition')->
    checkElement('.board_col:last .widget:nth-child(2) .widget_top_bar span','Expedition')->
    checkElement('.board_col:last .widget:nth-child(3) .widget_top_bar span','I.G. number')->
    checkElement('.board_col:last .widget:nth-child(4) .widget_top_bar span','Sampling location')->
  end()->
  info('3 - Edit specimen - Change Taxon')->
  click('Submit', 
        array('specimen' => array('taxon_ref'  => $taxonId,
                                  'collection_ref' => $collectionId
                                 )
             )
       )->
  with('response')->begin()->
    isRedirected()->
  end()->

  followRedirect()->

  with('response')->begin()->
    isStatusCode(200)->
    checkElement('.board_col:first .widget:first .widget_content div#specimen_collection_ref_name','Aves')->
    checkElement('.board_col:first .widget:nth-child(2) .widget_content div#specimen_taxon_ref_name','Falco Peregrinus Tunstall, 1771')->
  end()->
  
  info('4 - Check sameTaxon action call')->
  info('4.1 - ...without arguments')->  
  get('/specimen/sameTaxon')->
  with('response')->begin()->
    matches('/ok/')->
  end();

$specimens = Doctrine::getTable('Specimens')->findAll();
  
$browser->
  info('4.2 - ...with a specimen id and a taxon id different from one associated to specimen called')->  
  get('specimen/sameTaxon', array('specId'=>$specimens[0]->getId(), 'taxonId'=>'-1'))->
  with('response')->begin()->
    matches('/not ok/')->
  end()->
  info('4.3 - ...with a specimen id and a corresponding taxon id')->  
  get('specimen/sameTaxon', array('specId'=>$specimens[0]->getId(), 'taxonId'=>$specimens[0]->Taxonomy->getId()))->
  with('response')->begin()->
    matches('/ok/')->
  end()->
  info('5 - Check getTaxon action call')->
  info('5.1 - ...without arguments')->  
  get('specimen/getTaxon')->
  with('response')->begin()->
    isStatusCode(404)->
  end()->
  info('5.2 - ...with a wrong specimen id')->
  get('specimen/getTaxon', array('specId'=>'0', 'targetField'=>'specimen_host_taxon'))->
  with('response')->begin()->
    isStatusCode(404)->
  end()->
  info('5.3 - ...with correct infos')->
  get('specimen/getTaxon', array('specId'=>$specimens[0]->getId(), 'targetField'=>'specimen_host_taxon'))->
  with('response')->begin()->
    isStatusCode(200)->
    matches('/","specimen_host_taxon_name":"Animalia"}/')->
  end();