<?php slot('title', __('Parts overview'));  ?>

<?php include_partial('specimen/specBeforeTab', array('specimen' => $specimen, 'individual'=> $individual, 'mode' => 'parts_overview') );?>

<table class="parts_overview results">
  <thead>
	<tr>
	  <th><?php echo __('Code');?></th>
	  <th><?php echo __('Part');?></th>
	  <th><?php echo __('Room');?></th>
	  <th><?php echo __('Row');?></th>
	  <th><?php echo __('Shelf');?></th>
	  <th><?php echo __('Container');?></th>
	  <th><?php echo __('Sub container');?></th>
	  <th></th>
	  <th></th>
	</tr>
  </thead>
  <tbody>
  <?php foreach($parts as $part):?>
	<tr>
	  <td><?php if(isset($codes[$part->getId()])):?>
		  <ul><?php foreach($codes[$part->getId()] as $code):?>
			<li><?php echo $code->getCodeFormated();?></li>
		  <?php endforeach;?></ul>
		<?php endif;?>
	  </td>
	  <td><?php echo $part->getSpecimenPart();?></td>
	  <td><?php echo $part->getRoom();?></td>
	  <td><?php echo $part->getRow();?></td>
	  <td><?php echo $part->getShelf();?></td>
	  <td><?php echo $part->getContainer();?></td>
	  <td><?php echo $part->getSubContainer();?></td>
	  <td>
		<?php //echo link_to(image_tag('slide_right_enable.png'),'parts/details?id='.$part->getId(), array('class'=>'part_detail_slide'));?>
		<?php echo link_to(image_tag('edit.png'),'parts/edit?id='.$part->getId());?>
	  </td>
	  <td>
		<a class="widget_row_delete" href="<?php echo url_for('catalogue/deleteRelated?table=specimens_type&id='.$part->getId());?>" title="<?php echo __('Are you sure ?') ?>"><?php echo image_tag('remove.png'); ?>
	  </td>
	</tr>
  <?php endforeach;?>
  </tbody>
</table>

<br />

  <div class="new_link">
	<a href="<?php echo url_for('parts/edit?indid='.$individual->getId());?>"><?php echo __('Add New');?></a>
  </div>
<?php include_partial('specimen/specAfterTab');?>
