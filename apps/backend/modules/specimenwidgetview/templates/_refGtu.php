<table class="catalogue_table_view">
  <tbody>
    <tr>
      <th>
        <?php echo __('Station visible ?') ?>
      </th>
      <td>
        <?php echo $spec->getStationVisible()?__("Yes"):__("No") ; ?>
      </td>
    </tr>
    <?php if(isset($gtu) && ($spec->getStationVisible() || (!$spec->getStationVisible() && $sf_user->isAtLeast(Users::ENCODER)))) : ?>
    <tr>
      <th><label><?php echo __('Sampling location code');?></label></th>
      <td id="specimen_gtu_ref_code">
        <?php if($sf_user->isAtLeast(Users::ENCODER)):?>
          <?php echo link_to($gtu->getCode(), 'gtu/edit?id='.$spec->getGtuRef()) ?>
        <?php else:?>
          <?php echo $gtu->getCode();?>
        <?php endif;?>
      </td>
    </tr>
    <?php if($gtu->getLocation()):?>
    <tr>
      <th><label><?php echo __('Latitude');?></label></th>
      <td id="specimen_gtu_ref_lat"><?php echo $gtu->getLatitude() ; ?></td>
    </tr>
    <tr>
      <th><label><?php echo __('Longitude');?></label></th>
      <td id="specimen_gtu_ref_lon"><?php echo $gtu->getLongitude(); ?></td>
    </tr>
    <?php endif;?>
    <?php if($gtu->getElevation()):?>
    <tr>
      <th><label><?php echo __('Altitude');?></label></th>
      <td id="specimen_gtu_ref_elevation"><?php echo $gtu->getElevation().' +- '.$gtu->getElevationAccuracy().' m'; ?></td>
    </tr>
    <?php endif;?>
    <tr>
      <th><label><?php echo __('Date from');?></label></th>
      <td id="specimen_gtu_date_from" class="datesNum"><?php echo $gtu->getGtuFromDateMasked(ESC_RAW);?></td>
    </tr>
    <tr>
      <th><label><?php echo __('Date to');?></label></th>
      <td id="specimen_gtu_date_to" class="datesNum"><?php echo $gtu->getGtuToDateMasked(ESC_RAW);?></td>
    </tr>
    <tr>
      <th class="top_aligned">
        <?php echo __("Sampling location Tags") ?>
      </th>
      <td>
        <div class="inline">
          <?php echo $gtu->getName(ESC_RAW); ?>
        </div>
      </td>
    </tr>
    <tr>
      <td colspan="2" id="specimen_gtu_ref_map">
        <?php echo $gtu->getMap(ESC_RAW);?>
      </td>
    </tr>
    <?php elseif(isset($gtu) && $gtu->hasCountries()):?>
      <tr>
        <th class="top_aligned">
          <?php echo __("Sampling location countries") ?>
        </th>
        <td>
          <div class="inline">
            <?php echo $gtu->getRawValue()->getName(null, true); ?>
          </div>
        </td>
      </tr>
    <?php endif ; ?>
  </tbody>
</table>
