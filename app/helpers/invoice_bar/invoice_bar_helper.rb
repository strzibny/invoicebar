module InvoiceBar
  module InvoiceBarHelper

    # Defines an active state of the navbar item according to
    # which controller is used.
    def active_for_controller(controller)
      if params[:controller].include? controller
        'active'
      end
    end

    # Format Czech (and a like) 5-digit-long postcode.
    def formatted_postcode(postcode)
      unless postcode.to_s.length == 5
        postcode
      end

      postcode.to_s.gsub(/^(\d\d\d)(\d\d)$/,'\\1 \\2')
    end

    # Format money values using FormattedMoney.
    # If specified, it uses a +currency_symbol+ in front of the amount.
    def formatted_amount(cents, currency_symbol='')
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

    def formatted_money(cents, currency_symbol='')
      formatted_amount(cents, currency_symbol='')
    end
  end
end
