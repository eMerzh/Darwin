<?php
/**
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class UsersLoginInfosTable extends DarwinTable
{
  public function getInfoForUser($user_id, $system=null)
  {
    $q = Doctrine_Query::create()
            ->from('UsersLoginInfos u')
            ->andWhere('u.user_ref = ?', $user_id);
    if( $system !== null)
    {
      $q->andWhere('u.login_system = ?',$system);
    }
    return $q->execute();
  }
}