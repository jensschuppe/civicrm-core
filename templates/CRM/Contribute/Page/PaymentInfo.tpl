{*
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC. All rights reserved.                        |
 |                                                                    |
 | This work is published under the GNU AGPLv3 license with some      |
 | permitted exceptions and without any warranty. For full license    |
 | and copyright information, see https://civicrm.org/licensing       |
 +--------------------------------------------------------------------+
*}
{if $show eq 'payments'}
{literal}
<script type='text/javascript'>
CRM.$(function($) {
  if ($("#payment-info").length) {
    var dataUrl = {/literal}'{crmURL p="civicrm/payment/view" h=0 q="action=browse&id=$componentId&cid=`$contactId`&component=$component&context=payment_info&snippet=4"}'{literal};
    $.ajax({
      url: dataUrl,
      async: false,
      success: function(html) {
        $("#payment-info").html(html).trigger('crmLoad');
      }
    });
    // Fixme: Possible bug - the following line won't be processed by smarty because it's in a literal block
    var taxAmount = "{$totalTaxAmount}";
    if (taxAmount) {
      $('.total_amount-section').show();
    }
    else {
      $('.total_amount-section').remove();
    }
  }
});
</script>
{/literal}
{/if}
{if $context eq 'payment_info'}
<table id='info'>
  <tr class="columnheader">
    {if $component eq "event"}
      <th>{ts}Total Fee(s){/ts}</th>
    {else}
      <th>{ts}Contribution Total{/ts}</th>
    {/if}
    <th class="right">{ts}Total Paid{/ts}</th>
    <th class="right">{ts}Balance{/ts}</th>
  </tr>
  <tr>
    <td>{$paymentInfo.total|crmMoney:$paymentInfo.currency}</td>
    <td class='right'>
      {if $paymentInfo.paid > 0}
        {$paymentInfo.paid|crmMoney:$paymentInfo.currency}
        {if !$hideButtonLinks}
          <br/>
          <a class="crm-hover-button action-item crm-popup medium-popup" href='{crmURL p="civicrm/payment" q="view=transaction&cid=`$cid`&id=`$paymentInfo.id`&component=`$paymentInfo.component`&action=browse"}'>
            <i class="crm-i fa-list"></i>
            {ts}view payments{/ts}
          </a>
        {/if}
      {/if}
    </td>
    <td class="right" id="payment-info-balance" data-balance="{$paymentInfo.balance}">{$paymentInfo.balance|crmMoney:$paymentInfo.currency}</td>
  </tr>
</table>
{if $paymentInfo.balance and !$paymentInfo.payLater && !$hideButtonLinks}
  {if $paymentInfo.balance > 0}
     {assign var=paymentButtonName value='Record Payment'}
  {elseif $paymentInfo.balance < 0}
     {assign var=paymentButtonName value='Record Refund'}
  {/if}
  <a class="action-item crm-hover-button" href='{crmURL p="civicrm/payment" q="action=add&reset=1&component=`$component`&id=`$id`&cid=`$cid`"}'><i class="crm-i fa-plus-circle"></i> {ts}{$paymentButtonName}{/ts}</a>
{/if}
{/if}
