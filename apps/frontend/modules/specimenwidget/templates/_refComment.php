<table class="property_values comments"  id="spec_ident_comments">
    <thead style="<?php echo ($form['Comments']->count() || $form['newComments']->count())?'':'display: none;';?>" class="spec_ident_comments_head">
    <tr>   
      <th><?php echo __('Notion');?></th>
      <th><?php echo __('Comment');?></th>
      <th><?php echo $form['comment'];?></th>
    </tr>
  </thead>
  <?php foreach($form['Comments'] as $form_value):?>
     <?php include_partial('spec_comments', array('form' => $form_value));?>
  <?php endforeach;?>
  <?php foreach($form['newComments'] as $form_value):?>
     <?php include_partial('spec_comments', array('form' => $form_value));?>
  <?php endforeach;?>
   <tfoot>
     <tr>
       <td colspan="3">
         <div class="add_collectors">
           <a href="<?php echo url_for('specimen/addComments'.($form->getObject()->isNew() ? '': '?id='.$form->getObject()->getId()) );?>/num/" id="add_comment"><?php echo __('Add Comm.');?></a>
         </div>
       </td>
     </tr>
   </tfoot>
</table>
 
<script  type="text/javascript">
$(document).ready(function () {

    $('#add_comment').live('click', function()
    {
        parent = $(this).closest('table.comments');
        parentId = $(parent).attr('id');
        $.ajax(
        {
          type: "GET",
          url: $(this).attr('href')+ ($('table#'+parentId+' tbody.spec_ident_comments_data').length),
          success: function(html)
          {                    
            $(parent).append(html);
          }
        });
        $(this).closest('table.comments').find('thead').show();
        return false;
    }); 
    $('.clear_comment').live('click', function()
    {
      parent = $(this).closest('tbody');
      parentTableId = $(parent).closest('table').attr('id');
      nvalue="0";
      $(parent).find('input[id$=\"_referenced_relation\"]').val(nvalue);
      $(parent).find('textarea[id$=\"_comment\"]').html(nvalue);      
      $(parent).hide();
      reOrderIdentifiers(parentTableId);
      visibles = $('table#'+parentTableId+' tbody.spec_ident_comments_data:visible').size();
      if(!visibles)
      {
        $(this).closest('table#'+parentTableId).find('thead').hide();
      }
    });
});
</script>
