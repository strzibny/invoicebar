module InvoiceBarHelper
  # Defines an active state of the navbar item according to
  # which controller is used.
  def active_for_controller(path)
    'active' if params[:controller].include? path
  end

  # Format Czech (and a like) 5-digit-long postcode.
  def formatted_postcode(postcode)
    return postcode unless postcode.to_s.length == 5
    postcode.to_s.gsub(/^(\d\d\d)(\d\d)$/, '\\1 \\2')
  end

  # Format money values using FormattedMoney.
  # If specified, it uses a +currency_symbol+ in front of the amount.
  def formatted_amount(cents, currency_symbol = '')
    begin
      results = FormattedMoney.amount(cents)
    rescue
      results = cents
    end

    if currency_symbol.blank?
      results
    else
      "#{currency_symbol} #{results}"
    end
  end

  def formatted_money(cents, currency_symbol = '')
    formatted_amount(cents, currency_symbol)
  end

  def action_invoices_url(params)
    case params[:action]
    when 'issued'
      issued_invoices_url(params)
    when 'received'
      received_invoices_url(params)
    else
      filter_invoices_url(params)
    end
  end

  def action_receipts_url(params)
    case params[:action]
    when 'income'
      income_receipts_url(params)
    when 'expense'
      expense_receipts_url(params)
    else
      filter_receipts_url(params)
    end
  end
end
