<?php include_partial('widgets/list', array('widgets' => $widgets, 'category' => 'maintenances','eid'=> null )); ?>
<?php $action = 'maintenances/create?table='.$sf_request->getParameter('table').'&record_id='.$sf_request->getParameter('record_id') ;?>
<div class="page">
  <?php echo form_tag($action, array('class'=>'edition','enctype'=>'multipart/form-data'));?>
  <h1><?php echo __('New Maintenance (table : ').$sf_request->getParameter('table').')';?></h1>
  
  <?php include_partial("maintenances", array('form' => $form)) ; ?>  
  <div>
    <?php include_partial('widgets/screen', array(
	  'widgets' => $widgets,
	  'category' => 'maintenanceswidget',
	  'columns' => 1,
	  'options' => array('form' => $form , 'table' => $sf_request->getParameter('table'), 'eid' => null)
	  )); ?>
	</div>
    <p class="form_buttons">
      <input id="submit_maintenance" type="submit" value="<?php echo __('Save');?>"/>
    </p>	
  </form>	
  <script  type="text/javascript">

    function addError(html)
    {
      $('ul#error_list').find('li').text(html);
      $('ul#error_list').show();
    }

    function removeError()
    {
      $('ul#error_list').hide();
      $('ul#error_list').find('li').text(' ');
    }   
    $(document).ready(function () {
      $('body').catalogue({}); 
      $('#submit_maintenance').click(function() 
      {
        form = $(this).closest('form') ;
        form.removeAttr('target') ;
        form.attr('action', '<?php echo url_for($action) ; ?>') ;
        form.submit() ;
      });        
    });
  </script>  
</div>	
