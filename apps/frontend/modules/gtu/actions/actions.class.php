<?php

/**
 * Gtu actions.
 *
 * @package    darwin
 * @subpackage GTU
 * @author     DB team <collections@naturalsciences.be>
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class gtuActions extends DarwinActions
{
  protected $widgetCategory = 'gtu_widget';

 /* public function executeChoose(sfWebRequest $request)
  {
    $this->form = new GtuFormFilter();
  }
*/
  public function executeIndex(sfWebRequest $request)
  {
    $this->form = new GtuFormFilter();
  }

/*  public function executeSearch(sfWebRequest $request)
  {
    $this->forward404Unless($request->isMethod('post'));
    $this->setCommonValues('gtu', 'family_name', $request);
    $this->form = new InstitutionsFormFilter();
    $this->is_choose = ($request->getParameter('is_choose', '') == '')?0:intval($request->getParameter('is_choose'));

    if($request->getParameter('gtu_filters','') !== '')
    {
      $this->form->bind($request->getParameter('institutions_filters'));

      if ($this->form->isValid())
      {
        $query = $this->form->getQuery()->orderBy($this->orderBy .' '.$this->orderDir);
        $this->pagerLayout = new PagerLayoutWithArrows(
	  new Doctrine_Pager(
	    $query,
	    $this->currentPage,
	    $this->form->getValue('rec_per_page')
	  ),
	  new Doctrine_Pager_Range_Sliding(
	    array('chunk' => $this->pagerSlidingSize)
	    ),
	  $this->getController()->genUrl($this->s_url.$this->o_url).'/page/{%page_number}'
	);

        // Sets the Pager Layout templates
        $this->setDefaultPaggingLayout($this->pagerLayout);
        // If pager not yet executed, this means the query has to be executed for data loading
        if (! $this->pagerLayout->getPager()->getExecuted())
           $this->items = $this->pagerLayout->execute();
      }
    }    
  }
*/
  public function executeNew(sfWebRequest $request)
  {
    $this->form = new GtuForm();
  }

  public function executeCreate(sfWebRequest $request)
  {
    $this->forward404Unless($request->isMethod(sfRequest::POST));

    $this->form = new GtuForm();

    $this->processForm($request, $this->form);

    $this->setTemplate('new');
  }

  public function executeEdit(sfWebRequest $request)
  {
    $this->forward404Unless($gtu = Doctrine::getTable('Gtu')->findExcept($request->getParameter('id')), sprintf('Object gtu does not exist (%s).', $request->getParameter('id')));
    $this->form = new GtuForm($gtu);
    $this->loadWidgets();
  }

  public function executeUpdate(sfWebRequest $request)
  {
    $this->forward404Unless($request->isMethod(sfRequest::POST) || $request->isMethod(sfRequest::PUT));
    $this->forward404Unless($gtu = Doctrine::getTable('Gtu')->findExcept($request->getParameter('id')), sprintf('Object gtu does not exist (%s).', $request->getParameter('id')));
    $this->form = new GtuForm($gtu);

    $this->processForm($request, $this->form);
    $this->loadWidgets();
    $this->setTemplate('edit');
  }

  public function executeDelete(sfWebRequest $request)
  {
    $request->checkCSRFProtection();

    $this->forward404Unless($gtu = Doctrine::getTable('Gtu')->findExcept($request->getParameter('id')), sprintf('Object gtu does not exist (%s).', $request->getParameter('id')));
    try{
        $gtu->delete();
	$this->redirect('gtu/index');
    }
    catch(Doctrine_Exception $ne)
    {
      $e = new DarwinPgErrorParser($ne);
      $error = new sfValidatorError(new savedValidator(),$e->getMessage());
      $this->form = new GtuForm($gtu);
      $this->form->getErrorSchema()->addError($error); 
      $this->loadWidgets();
      $this->setTemplate('edit');
    }
  }

  protected function processForm(sfWebRequest $request, sfForm $form)
  {
    $form->bind($request->getParameter($form->getName()), $request->getFiles($form->getName()));
    if ($form->isValid())
    {
      try{
        $item = $form->save();
	$this->redirect('gtu/edit?id='.$item->getId());
      }
      catch(Doctrine_Exception $ne)
      {
	$e = new DarwinPgErrorParser($ne);
	$error = new sfValidatorError(new savedValidator(),$e->getMessage());
        $form->getErrorSchema()->addError($error); 
      }
    }
  }

  public function executeAddGroup(sfWebRequest $request)
  {
    $number = intval($request->getParameter('num'));
    $gtu = null;

    if($request->hasParameter('id') && $request->getParameter('id'))
      $gtu = Doctrine::getTable('Gtu')->findExcept($request->getParameter('id') );

    $form = new GtuForm($gtu);
    $form->addValue($number, $request->getParameter('group','administrative'));
    return $this->renderPartial('taggroups',array('form' => $form['newVal'][$number]));
  }
}
