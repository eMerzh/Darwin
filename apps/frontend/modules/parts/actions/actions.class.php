<?php

/**
 * Parts actions.
 *
 * @package    darwin
 * @subpackage parts
 * @author     DB team <collections@naturalsciences.be>
 */
class partsActions extends DarwinActions
{
  public function executeEdit(sfWebRequest $request)
  {
	$this->individual = Doctrine::getTable('SpecimenIndividuals')->findExcept($request->getParameter('id'));
	$this->forward404Unless($this->individual);
	$this->form = new PartsGroupedForm(null,array('individual' =>$this->individual));

	if($request->isMethod('post'))
	{
	  $this->form->bind( $request->getParameter('parts_grouped') );
	  if( $this->form->isValid() )
	  {
		$this->form->save();
		$this->redirect('parts/edit?id='.$this->individual->getId());
	  }
	}

  }

  public function executeAddNew(sfWebRequest $request)
  {
	$number = intval($request->getParameter('num'));
	$individual = Doctrine::getTable('SpecimenIndividuals')->findExcept($request->getParameter('id'));
	$form = new PartsGroupedForm(null,array('individual' =>$individual));
	$form->addValue($number);
	return $this->renderPartial('partform',array('form' => $form['newVal'][$number]));
  }
}