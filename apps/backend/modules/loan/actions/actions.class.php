<?php

/**
 * loan actions.
 *
 * @package    darwin
 * @subpackage loan
 * @author     DB team <collections@naturalsciences.be>
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class loanActions extends DarwinActions
{
  protected $widgetCategory = 'loan_widget';

  protected function checkRight($loan_id)  
  {
    // Forward to a 404 page if the requested expedition id is not found
    $this->forward404Unless($loan = Doctrine::getTable('Loans')->findExcept($loan_id), sprintf('Object loan does not exist (%s).', array($loan_id)));
    if($this->getUser()->isAtLeast(Users::ADMIN)) return $loan ;    
    if(!$right = Doctrine::getTable('loanRights')->isAllowed($this->getUser()->getId(),$loan->getId()))
      $this->forwardToSecureAction();
    if($right==="view") $this->redirect('loan/view?id='.$loan->getId());      
    return $loan ;
  }  
  
  protected function getLoanForm(sfWebRequest $request, $fwd404=false, $parameter='id',$options=null)
  {
    $loan = null;
    

    if ($fwd404)
      return $this->forward404Unless($loan = Doctrine::getTable('Loans')->findExcept($request->getParameter($parameter,0)));

    if($request->getParameter('table','loans')== 'loans')
    {
      if($request->hasParameter($parameter))
        $loan = Doctrine::getTable('Loans')->findExcept($request->getParameter($parameter) );      
      $form = new LoansForm($loan,$options);
    }else
    {
      if($request->hasParameter($parameter))    
        $loan = Doctrine::getTable('LoanItems')->findExcept($request->getParameter($parameter) );
      $form = new LoanItemWidgetForm($loan,$options);
    }
    return $form;
  }
  
  public function executeIndex(sfWebRequest $request)
  {
    $this->form = new LoansFormFilter(null,array('user' => $this->getUser()));
  }

  public function executeSearch(sfWebRequest $request)
  {
    $this->forward404Unless($request->isMethod('post'));
    $this->setCommonValues('loan', 'from_date', $request);

    $this->form = new LoansFormFilter(null,array('user' => $this->getUser()));
    $this->is_choose = ($request->getParameter('is_choose', '') == '') ? 0 : intval($request->getParameter('is_choose') );
    if($request->getParameter('loans_filters','') !== '')
    {
      $this->form->bind($request->getParameter('loans_filters'));

      if ($this->form->isValid())
      {
        $query = $this->form->getQuery()->orderBy($this->orderBy .' '.$this->orderDir);


        $pager = new DarwinPager($query,
          $this->currentPage,
          $this->form->getValue('rec_per_page')
        );
        $count_q = clone $query;
        $count_q = $count_q->select('count(*)')->removeDqlQueryPart('orderby')->limit(0);
        $counted = new DoctrineCounted();
        $counted->count_query = $count_q;
          // And replace the one of the pager with this new one
          $pager->setCountQuery($counted);

        $this->pagerLayout = new PagerLayoutWithArrows($pager,
          new Doctrine_Pager_Range_Sliding(array('chunk' => $this->pagerSlidingSize)),
          $this->getController()->genUrl($this->s_url.$this->o_url).'/page/{%page_number}'
        );

        // Sets the Pager Layout templates
        $this->setDefaultPaggingLayout($this->pagerLayout);
        // If pager not yet executed, this means the query has to be executed for data loading
        if (! $this->pagerLayout->getPager()->getExecuted())
           $this->items = $this->pagerLayout->execute();
          $loan_list = array();
          foreach($this->items as $loan) {
            $loan_list[] = $loan->getId() ;
          }
          $status = Doctrine::getTable('LoanStatus')->getStatusRelatedArray($loan_list) ;
          $this->status = array();
          foreach($status as $sta) {
            $this->status[$sta->getLoanRef()] = $sta;
          $this->rights = Doctrine::getTable('loanRights')->getEncodingRightsForUser($this->getUser()->getId());
          }
      }
    }
  }


  public function executeNew(sfWebRequest $request)
  {
    if($this->getUser()->isA(Users::REGISTERED_USER)) $this->forwardToSecureAction();  
    $loan = new Loans() ;
    $duplic = $request->getParameter('duplicate_id','0') ;
    $loan = $this->getRecordIfDuplicate($duplic, $loan);
    if($request->hasParameter('expedition')) $expedition->fromArray($request->getParameter('expedition'));
    // Initialization of a new encoding expedition form
    $this->form = new LoansForm($loan);
    if ($duplic)
    {
    }
    $this->loadWidgets();    
  }


  public function executeEdit(sfWebRequest $request)
  {
    $loan = $this->checkRight($request->getParameter('id')) ;
    $this->form = new LoansForm($loan);
    $this->loadWidgets();
    $this->setTemplate('new') ;    
  }

  public function executeView(sfWebRequest $request)
  {
    // Forward to a 404 page if the requested expedition id is not found
    $this->forward404Unless($this->loan = Doctrine::getTable('Loans')->findExcept($request->getParameter('id')), sprintf('Object loan does not exist (%s).', array($request->getParameter('id'))));
    if(!$this->getUser()->isAtLeast(Users::ADMIN))    
      if(!Doctrine::getTable('loanRights')->isAllowed($this->getUser()->getId(),$this->loan->getId()))
       $this->forwardToSecureAction();
    $this->loadWidgets();
  }

  protected function processForm(sfWebRequest $request, sfForm $form)
  {
 //   die(print_r($request->getParameter($form->getName())));
    $form->bind($request->getParameter($form->getName()),$request->getFiles($this->form->getName()));   
    if ($form->isValid())
    {
      try
      {        
        $item = $form->save();
        $this->redirect('loan/edit?id='.$item->getId());
      }
      catch(Doctrine_Exception $ne)
      {
        $e = new DarwinPgErrorParser($ne);
        $error = new sfValidatorError(new savedValidator(),$e->getMessage());
        $form->getErrorSchema()->addError($error); 
      }
    } 
  }

  public function executeViewAll(sfWebRequest $request)
  {  
    $this->loans = Doctrine::getTable('Loans')->getMyLoans($this->getUser()->getId())->execute(); 
    $this->rights = Doctrine::getTable('LoanRights')->getEncodingRightsForUser($this->getUser()->getId());

    if( count($this->loans) )
    {
      $ids = array();
      foreach($this->loans as $loan)
 	$ids[] = $loan->getId();
      
      if( !empty($ids) )
	$this->status = Doctrine::getTable('LoanStatus')->getFromLoans($ids);
    }
  }


  public function executeDelete(sfWebRequest $request)
  {
    $loan = $this->checkRight($request->getParameter('id')) ;  
    try
    {
      $loan->delete();
      $this->redirect('loan/index');
    }
    catch(Doctrine_Exception $ne)
    {
      $e = new DarwinPgErrorParser($ne);
      $error = new sfValidatorError(new savedValidator(),$e->getMessage());
      $this->form = new LoansForm($loan);
      $this->form->getErrorSchema()->addError($error); 
      $this->loadWidgets();
      $this->setTemplate('new');
    }
  }


  public function executeCreate(sfWebRequest $request)
  {    
    if($this->getUser()->isA(Users::REGISTERED_USER)) $this->forwardToSecureAction();  
    $loan = new Loans() ;
    $this->form = new LoansForm();
    // Process the form for saving informations
    $this->processForm($request, $this->form);
    $this->loadWidgets();    
    $this->setTemplate('new');
    
  }
  public function executeUpdate(sfWebRequest $request)
  {
    $this->forward404Unless($request->isMethod('post') || $request->isMethod('put'));
    $loan = $this->checkRight($request->getParameter('id')) ;  
    $this->form = new LoansForm($loan);
    $this->processForm($request, $this->form);
    $this->loadWidgets();
    $this->setTemplate('new');
  }

  public function executeOverview(sfWebRequest $request) {
    $this->forward404Unless($this->loan = Doctrine::getTable('Loans')->findExcept($request->getParameter('id')), sprintf('Object loan does not exist (%s).', array($request->getParameter('id'))));
    $this->form = new LoanOverviewForm(null, array('loan'=>$this->loan));
    if($request->getParameter('loan_overview','') !== '')
    {
      $this->form->bind($request->getParameter($this->form->getName()));
      if ($this->form->isValid())
      {
        try
        {
          $this->form->save();
          return $this->redirect('loan/overview?id='.$this->loan->getId());
        }
        catch(Doctrine_Exception $ne)
        {
          $e = new DarwinPgErrorParser($ne);
          $error = new sfValidatorError(new savedValidator(),$e->getMessage());
          $this->form->getErrorSchema()->addError($error); 
        }
      }
    }
  }

  public function executeOverviewView(sfWebRequest $request) {
    $this->forward404Unless($this->loan = Doctrine::getTable('Loans')->findExcept($request->getParameter('id')), sprintf('Object loan does not exist (%s).', array($request->getParameter('id'))));
    $this->items = Doctrine::getTable('LoanItems')->findForLoan($this->loan->getId());
  }

  public function executeAddLoanItem(sfWebRequest $request)
  {
    $number = intval($request->getParameter('num'));
    $this->loan = $this->checkRight($request->getParameter('id'));
    $item = new LoanItems();
    $this->form = new LoanOverviewForm(null, array('loan'=>$this->loan));
    $this->form->addItem($number);
    return $this->renderPartial('loanLine',array('form' => $this->form['newLoanItems'][$number], 'lineObj'=> $item));
  }

  public function executeGetPartInfo(sfWebRequest $request)
  {
    $this->forward404Unless($item = Doctrine::getTable('SpecimenSearch')->findOneByPartRef($request->getParameter('id')),'Part does not exist');  
    return $this->renderPartial('extInfo',array('item' => $item)); 
  }
  
  public function executeAddActors(sfWebRequest $request)
  {
    $number = intval($request->getParameter('num'));
    $people_ref = intval($request->getParameter('people_ref')) ;
    $form = $this->getLoanForm($request);
    if ($request->getParameter('type') == 'sender')
    {
      $form->addActorsSender($number,$people_ref,$request->getParameter('order_by',0));    
      return $this->renderPartial('actors_association',array('type'=>'sender','form' => $form['newActorsSender'][$number], 'row_num'=>$number));        
    }
    $form->addActorsReceiver($number,$people_ref,$request->getParameter('order_by',0));
    return $this->renderPartial('actors_association',array('type'=>'receiver','form' => $form['newActorsReceiver'][$number], 'row_num'=>$number));  
  }

  public function executeAddUsers(sfWebRequest $request)
  {
    $number = intval($request->getParameter('num'));
    $user_ref = intval($request->getParameter('user_ref')) ;
    $form = $this->getLoanForm($request);
    $form->addUsers($number,$user_ref,$request->getParameter('order_by',0));
    return $this->renderPartial('darwin_user',array('form' => $form['newUsers'][$number], 'row_num'=>$number));  
  }
  
  public function executeAddComments(sfWebRequest $request)
  {
    $number = intval($request->getParameter('num'));
    $form = $this->getLoanForm($request);
    $form->addComments($number);
    return $this->renderPartial('specimen/spec_comments',array('form' => $form['newComments'][$number], 'rownum'=>$number));
  }
    
  public function executeAddInsurance(sfWebRequest $request)
  {    
    $number = intval($request->getParameter('num'));
    $form = $this->getLoanForm($request);
    $form->addInsurances($number);
    return $this->renderPartial('parts/insurances',array('form' => $form['newInsurance'][$number], 'rownum'=>$number));
  }  

  public function executeInsertFile(sfWebRequest $request)
  {
    $form = $this->getLoanForm($request,false,'id',array('no_name'=>true));
    $form->bind($request->getParameter($form->getName()), $request->getFiles($form->getName()));
    $file = $form->getValue('filenames');    
    if($form->isValid()) 
    {       
      if(!Multimedia::CheckMymeType($file->getType()))
        return $this->renderText("<script>parent.displayFileError('This type of file is not allowed')</script>") ;
      // first save the file
      $filename = sha1($file->getOriginalName().rand());
      while(file_exists(sfConfig::get('sf_upload_dir').'/multimedia/temp/'.$filename))
        $filename = sha1($file->getOriginalName().rand());
      $extension = $file->getExtension($file->getOriginalExtension());
      $file->save(sfConfig::get('sf_upload_dir').'/multimedia/temp/'.$filename);      
      if($file->isSaved())
        $file_info = array(
          'title' => $file->getOriginalName(),
          'filename' => $file->getOriginalName(),
          'mime_type' => $file->getType(),
          'type' => $extension,
          'uri' => $filename,
          'referenced_relation' => $request->getParameter('table'),
          'creation_date' => date('Y/m/d')
        ) ;
        $this->getUser()->setAttribute($filename, $file_info);
      return $this->renderText("<script>parent.getFileInfo('$filename')</script>") ;
    }
    return $this->renderText("<script>parent.displayFileError('".$form->getErrorSchema()->current()."')</script>") ;

  }

  public function executeAddRelatedFiles(sfWebRequest $request)
  {
    $number = intval($request->getParameter('num'));
    $form = $this->getLoanForm($request);    
    $file = $this->getUser()->getAttribute($request->getParameter('file_id')) ;    
    $form->addRelatedFiles($number,$file);
    return $this->renderPartial('loan/multimedia',array('form' => $form['newRelatedFiles'][$number], 'row_num'=>$number));
  }  
    
  public function executeAddStatus(sfWebRequest $request)
  {    
    if($request->isXmlHttpRequest()) 
    {    
      $form = new InformativeWorkflowForm(null, array('available_status' => LoanStatus::getAvailableStatus())) ;
      $form->bind(array('comment'=>$request->getParameter('comment'),'status'=>$request->getParameter('status'))) ;
      if($form->isValid())
      {        
        $data = array(
            'loan_ref' => $request->getParameter('id'),
            'status' => $request->getParameter('status'),   
            'comment' => $request->getParameter('comment'),    
            'user_ref' => $this->getUser()->getId()) ;    
            
        $loanstatus = new LoanStatus() ;
        $loanstatus->fromArray($data) ;
        $loanstatus->save() ;
      }
      // else : nothing append, and it's a good thing
      return $this->renderText('ok') ;
    }
    $this->redirect('board/index') ;
  }  
}
