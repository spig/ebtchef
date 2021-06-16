// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function show_creditcard()
{
  $('creditcard_section').show();
  $('user_credit_card_number').disabled = false;
  $('user_credit_card_verification').disabled = false;
  $('user[ccexp_month]').disabled = false;
  $('user[ccexp_year]').disabled = false;
}

function hide_creditcard()
{
  $('creditcard_section').hide();
  $('user_credit_card_number').disabled = true;
  $('user_credit_card_verification').disabled = true;
  $('user[ccexp_month]').disabled = true;
  $('user[ccexp_year]').disabled = true;
}

function show_check()
{
  $('checking_section').show();
  $('user_routing_number').disabled = false;
  $('user_phone').disabled = false;
  $('user_checking_account').disabled = false;
}

function hide_check()
{
  $('checking_section').hide();
  $('user_routing_number').disabled = true;
  $('user_phone').disabled = true;
  $('user_checking_account').disabled = true;
}

/* POP up for free 30 day trial*/

