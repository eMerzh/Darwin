<?php $sep=';';?>
Category<?php echo $sep;?>
Collection ID<?php echo $sep;?>
Collection Name<?php echo $sep;?>
Taxonomy ID<?php echo $sep;?>
Taxonomy Name<?php echo $sep;?>
With Types<?php echo $sep;?>
Sampling Location ID<?php echo $sep;?>
Sampling Location Code<?php echo $sep;?>
Country<?php echo $sep;?>
Specimens Codes<?php echo $sep;?>
Chronostratigraphy ID<?php echo $sep;?>
Chronostratigraphy Name<?php echo $sep;?>
I.G. ID<?php echo $sep;?>
I.G. Number<?php echo $sep;?>
Lithostratigraphy ID<?php echo $sep;?>
Lithostratigraphy Name<?php echo $sep;?>
Lithology ID<?php echo $sep;?>
Lithology Name<?php echo $sep;?>
Mineralogy ID<?php echo $sep;?>
Mineralogy Name<?php echo $sep;?>
Expedition ID<?php echo $sep;?>
Expedition Name<?php echo $sep;?>
Acquisition Category<?php echo $sep;?>
<?php if($source != 'specimen'):?>
Type Grouped<?php echo $sep;?>
Sex<?php echo $sep;?>
Developpement State<?php echo $sep;?>
Individual Stage<?php echo $sep;?>
SocialStatus<?php echo $sep;?>
RockForm<?php echo $sep;?>
Ind Count Min<?php echo $sep;?>
Ind Count Max<?php echo $sep;?>
<?php elseif($source =='part'):?>
Part<?php echo $sep;?>
Part Status<?php echo $sep;?>
<?php if ($sf_user->isAtLeast(Users::ENCODER)) : ?>
Building<?php echo $sep;?>
Floor<?php echo $sep;?>
Room<?php echo $sep;?>
Row<?php echo $sep;?>
Shelf<?php echo $sep;?>
Container<?php echo $sep;?>
Container Type<?php echo $sep;?>
Container Storage<?php echo $sep;?>
Sub Container<?php echo $sep;?>
Sub Container Type<?php echo $sep;?>
Sub Container Storage<?php echo $sep;?>
Part Codes<?php echo $sep;?>
<?php endif;?>
<?php endif;?>

<?php foreach($specimensearch as $item):?>
<?php $item = $item->getRawValue();?>
<?php echo $item->getCategory().$sep;?>
<?php echo $item->getCollectionRef().$sep;?>
<?php echo $item->getCollectionName().$sep;?>
<?php echo $item->getTaxonRef().$sep;?>
<?php echo $item->getTaxonName().$sep;?>
<?php echo ($item->getWithTypes()? 'yes':'no').$sep;?>
<?php echo $item->getGtuRef().$sep;?>
<?php echo $item->getGtuCode().$sep;?>
<?php echo str_replace(';', ',', $item->getGtuCountryTagValue('')).$sep; ?>
<?php if(isset($codes[$item->getSpecRef()])) foreach($codes[$item->getSpecRef()] as $code) echo $code->getFullCode().',';?><?php echo $sep;?>
<?php echo $item->getChronoRef().$sep;?>
<?php echo $item->getChronoName().$sep;?>
<?php echo $item->getIgRef().$sep;?>
<?php echo $item->getIgNum().$sep;?>
<?php echo $item->getLithoRef().$sep;?>
<?php echo $item->getLithoName().$sep;?>
<?php echo $item->getLithologyRef().$sep;?>
<?php echo $item->getLithologyName().$sep;?>
<?php echo $item->getMineralRef().$sep;?>
<?php echo $item->getMineralName().$sep;?>
<?php echo $item->getExpeditionRef().$sep;?>
<?php echo $item->getExpeditionName().$sep;?>
<?php echo $item->getAcquisitionCategory().$sep;?>
<?php if($source != 'specimen'):?>
<?php echo $item->getIndividualTypeGroup().$sep;;?>
<?php echo $item->getIndividualSex().$sep;?>
<?php echo $item->getIndividualState().$sep;?>
<?php echo $item->getIndividualStage().$sep;?>
<?php echo $item->getIndividualSocialStatus().$sep;?>
<?php echo $item->getIndividualRockForm().$sep;?>
<?php echo $item->getIndividualCountMin().$sep;?>
<?php echo $item->getIndividualCountMax().$sep;?>
<?php elseif($source =='part'):?>
<?php echo $specimen->getPart();?>
<?php echo $specimen->getPartStatus();?>
<?php if ($sf_user->isAtLeast(Users::ENCODER)) : ?>
<?php echo $specimen->getBuilding();?>
<?php echo $specimen->getFloor();?>
<?php echo $specimen->getRoom();?>
<?php echo $specimen->getRow();?>
<?php echo $specimen->getShelf();?>
<?php echo $specimen->getContainer();?>
<?php echo $specimen->getContainerType();?>
<?php echo $specimen->getContainerStorage();?>
<?php echo $specimen->getSubContainer();?>
<?php echo $specimen->getSubContainerType();?>
<?php echo $specimen->getSubContainerStorage();?>
<?php if(isset($part_codes[$item->getSpecRef()])) foreach($part_codes[$item->getSpecRef()] as $code) echo $code->getFullCode().',';?><?php echo $sep;?>
<?php endif;?>
<?php endif;?>

<?php endforeach;?>