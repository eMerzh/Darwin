<?php
if(isset($eid) && $eid != 0) $record_ref = "&eid=".$eid;
else $record_ref = "";
?>
<script type="text/javascript">
var chgstatus_url='<?php echo url_for('widgets/changeStatus?category='.$category.$record_ref);?>';
var chgorder_url='<?php echo url_for('widgets/changeOrder?category='.$category.$record_ref);?>';
var reload_url='<?php echo url_for('widgets/reloadContent?category='.$category.$record_ref);?>';
</script>

<div class="widget_collection_global">
	<div class="widget_collection_container">
        <?php foreach($widgets as $widget):?>
        
            <div class="widget_preview" <?php if($widget->getVisible()) echo 'style="display:none"';?>
                id="boardprev_<?php echo $widget->getGroupName();?>">
            <a href="<?php echo url_for('widgets/addWidget?widget='.$widget->getGroupName()."&category=".$category.$record_ref);?>">
                <?php echo image_tag('widged_preview_1.png','alt='.$widget->getGroupName());?>
            <span class="widget_prev_title"><?php echo $widget->getGroupName();?></span></a>
            </div>
            
		<?php endforeach;?>
        <br />
	</div>	
	<div class="widget_collection_top">
		<div class="help_message"><a class="close_button" href=""><?php echo image_tag('widget_help_close.png','alt=Close class=help_close');?></a>
		<?php echo __('Customise your interface !');?>
		</div>
	</div>
	<div class="widget_collection_button"><a href="#"><?php echo image_tag('widget_expand_button.png','alt=Expand');?></a></div>
</div>