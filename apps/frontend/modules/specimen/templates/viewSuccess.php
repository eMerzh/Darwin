<?php slot('title', __('View Specimen'));  ?>
<?php include_partial('widgets/list', array('widgets' => $widgets, 'category' => 'specimen','eid'=> $form->getObject()->getId(),'view' => true)); ?>
<?php include_stylesheets_for_form($form) ?>
<?php include_javascripts_for_form($form) ?>
<div class="page">
  <div class="tabs_view">
    <a class="enabled selected" id="tab_0"> &lt; <?php echo sprintf(__('Specimen %d'),$specimen->getId());?> &gt; </a>
		<?php echo link_to(__('Individuals overview'), 'individuals/overview?spec_id='.$specimen->getId()."&view=true", array('class'=>'enabled', 'id' => 'tab_1'));?>
  </div>

  <div class="panel_view encod_screen edition" id="intro">
    <div>
      <?php include_partial('widgets/screen', array(
        'widgets' => $widgets,
        'category' => 'specimenwidget',
        'columns' => 2,
        'options' => array('form' => $form, 'level' => 2, 'view' => true),
      )); ?>
    </div>
    <p class="clear"></p>
    <p align="right">
      <?php if ($sf_user->isAtLeast(Users::ENCODER)): ?>
        <?php echo link_to(__('New specimen'), 'specimen/new', array('class' => 'bt_close')) ?>
        &nbsp;<a href="<?php echo url_for('specimen/new?duplicate_id='.$form->getObject()->getId());?>" class="duplicate_link bt_close"><?php echo __('Duplicate specimen');?></a>
      <?php endif?>
      &nbsp;<a class="bt_close" href="<?php echo url_for('specimensearch/index') ?>" id="spec_cancel"><?php echo __('Back');?></a>
    </p>
  </div>
</div>
