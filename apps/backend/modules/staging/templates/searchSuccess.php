    <?php include_partial('global/pager', array('pagerLayout' => $pagerLayout)); ?>
    <?php include_partial('global/pager_info', array('form' => $form, 'pagerLayout' => $pagerLayout)); ?>  

<div class="edition">
<table class="staging_table results ">
  <thead>
  <?php foreach($fields as $name):?>
    <th><?php echo $name;?></th>
  <?php endforeach;?>
    <th><?php echo __('Codes');?></th>
    <th><?php echo __('Linked Info');?></th>
    <th><?php echo __('Status');?></th>
    <th></th>
  </thead>
  <?php foreach($search as $row):?>
    <tr>
      <?php foreach($fields as $name):?>
        <td class="<?php echo $row->getStatusFor($name);?>"><?php echo $row[$name];?></td>
      <?php endforeach;?>
      <td>
        <ul class="codes">
          <?php foreach($row['codes'] as $k=>$v):?>
            <li>
              <?php echo $v->code_prefix.$v->code_prefix_separator.
              $v->code.$v->code_suffix.$v->code_suffix_separator;?>
            </li>
          <?php endforeach;?>
        </ul>
      </td>
      <td><?php echo $row['linked_info'];?></td>
      <td>
        <?php if(count($row['status']) != 0 ):?>
          <?php echo __('Error');?>
        <?php endif;?>
      </td>
      <td>
        <?php if(count($row['status']) != 0 ):?>
          <?php echo link_to(image_tag('edit.png', array("title" => __("Edit"))), 'staging/edit?id='.$row['id']);?>
        <?php endif;?>
      </td>
      </tr>
  <?php endforeach;?>
</table>
<br/>
<div class="blue_link"><?php echo link_to(__('Back to Import'), 'import/index');?></div>
<?php echo link_to(__('Import "Ok" lines'), 'staging/markok?import='.$import->getId() ,'class=but');?>
</div>