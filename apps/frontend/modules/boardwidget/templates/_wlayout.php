<?php $widget_content = get_component($category, $widget); ?>
<li class="widget" id="<?php echo $widget;?>">
    <div class="widget_top_button" <?php if(! $is_opened):?> style="display:block"<?php endif;?>>
        <?php if($category=='boardwidget'):?>
            <?php echo image_tag('widget_box_expand_button.png', 'alt=Close');?>
        <?php else:?>
            <?php echo image_tag('widget_box_expand_green_button.png', 'alt=Close');?>
        <?php endif;?>
    </div>
	<div class="widget_top_bar">
		<div class="widget_top_bar_button">
            <?php if($category=='boardwidget'):?>
                <a href="#" class="widget_refresh" ><?php echo image_tag('widget_refresh.png', 'alt=Refresh');?></a>
            <?php endif;?>
            <a href="#" class="widget_close" ><?php echo image_tag('widget_close.png', 'alt=Close');?></a>
		</div>
		<span><?php include_slot('widget_title'); ?></span>
	</div>
	<div class="widget_content" <?php if(! $is_opened):?> style="display:none"<?php endif;?>>

        <?php echo $widget_content; ?>
	</div>
    <div class="widget_bottom_button" <?php if(! $is_opened):?> style="display:none"<?php endif;?>>
        <?php if($category=='boardwidget'):?>
            <?php echo image_tag('widget_box_expand_up_button.png', 'alt=Collapse');?>
        <?php else:?>
            <?php echo image_tag('widget_box_expand_up_green_button.png', 'alt=Collapse');?>
        <?php endif;?>
    </div>
</li>