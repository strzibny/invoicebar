pdf.font_families.update("DejaVuSans" => {
	:normal => { :file => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"},
	:bold => { :file => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"}
})

pdf.font("DejaVuSans")

pdf.text "#{t('titles.invoice_pdf')}", :size => 20#, :style => :bold

pdf.fill_color "666666"
pdf.text_box "#{t('titles.number')} #{@invoice.number}", :size => 20, :at => [240, 720], :width => 300, :align => :right

pdf.move_down(250)

pdf.fill_color "000000"

# User
pdf.stroke_color "BFBFBF"
pdf.fill_color "BFBFBF"
unless @invoice.issuer
  pdf.text_box "#{t('attributes.invoice.purchaser')}", :size => 10, :at => [10, 660], :width => 240
else
 pdf.text_box "#{t('attributes.invoice.provider')}", :size => 10, :at => [10, 660], :width => 240
end
pdf.fill_color "000000"
pdf.text_box "#{@invoice.user_name}", :size => 14, :at => [10, 640], :width => 240
pdf.text_box "#{@invoice.user_street}    #{@invoice.user_street_number}", :size => 10, :at => [10, 620], :width => 240
pdf.text_box "#{formatted_postcode(@invoice.user_postcode)}", :size => 10, :at => [10, 605], :width => 240
pdf.text_box "#{@invoice.user_city}", :size => 10, :at => [60, 605], :width => 240
pdf.text_box "#{@invoice.user_city_part}", :size => 10, :at => [60, 590], :width => 240
pdf.text_box "#{@invoice.user_extra_address_line}", :size => 10, :at => [10, 575], :width => 240

pdf.fill_color "666666"
pdf.text_box "#{t('attributes.user.ic')}:    #{@invoice.user_ic}", :size => 10, :at => [10, 570], :width => 240

# Customer
pdf.fill_color "DBDAD9"
unless @invoice.issuer
  pdf.text_box "#{t('attributes.invoice.provider')}", :size => 10, :at => [290, 660], :width => 240
else
  pdf.text_box "#{t('attributes.invoice.purchaser')}", :size => 10, :at => [290, 660], :width => 240
end
pdf.fill_color "000000"
pdf.text_box "#{@invoice.contact_name}", :size => 14, :at => [290, 640], :width => 240
pdf.text_box "#{@invoice.address_street}    #{@invoice.address_street_number}", :size => 10, :at => [290, 620], :width => 240
pdf.text_box "#{formatted_postcode(@invoice.address_postcode)}", :size => 10, :at => [290, 605], :width => 240
pdf.text_box "#{@invoice.address_city}", :size => 10, :at => [340, 605], :width => 240
pdf.text_box "#{@invoice.address_city_part}", :size => 10, :at => [340, 590], :width => 240
pdf.text_box "#{@invoice.address_extra_address_line}", :size => 10, :at => [290, 575], :width => 240

move_down = 0

unless @invoice.address_city_part.blank?
  move_down += 15
end

unless @invoice.address_extra_address_line.blank?
  move_down += 15
end

pdf.stroke_rounded_rectangle [0, 670], 270, 120, 6
pdf.stroke_rounded_rectangle [280, 670], 270, 120, 6


pdf.fill_color "666666"
if @invoice.contact_ic.blank? and @invoice.contact_dic.blank?
elsif not @invoice.contact_dic.blank?
  pdf.text_box "#{t('attributes.contact.dic')}:    #{@invoice.contact_dic}", :size => 10, :at => [290, 570-move_down], :width => 240
elsif not @invoice.contact_ic.blank?
  pdf.text_box "#{t('attributes.contact.ic')}:    #{@invoice.contact_ic}", :size => 10, :at => [290, 570-move_down], :width => 240
else
  pdf.text_box "#{t('attributes.contact.ic')}:    #{@invoice.contact_ic}    #{t('attributes.contact.dic')}:    #{@invoice.contact_dic}", :size => 10, :at => [290, 570], :width => 240
end
# Account
unless @invoice.account_bank_account_number.blank?
  #pdf.text @invoice.account_bank_account_number

  pdf.fill_color "666666"

  if @invoice.account_swift.blank? or @invoice.account_swift.blank?
    pdf.stroke_rounded_rectangle [0, 540], 270, 45, 6
    pdf.text_box t('keywords.payment'), :size => 10, :at => [10, 530], :width => 240
    pdf.text_box "#{@invoice.account_name}", :size => 10, :at => [10, 515], :width => 240
  else
    pdf.stroke_rounded_rectangle [0, 540], 270, 75, 6
    pdf.text_box t('keywords.payment'), :size => 10, :at => [10, 530], :width => 240
    pdf.text_box "#{t('models.account')}:", :size => 10, :at => [10, 530], :width => 240
    pdf.text_box "#{@invoice.account_bank_account_number}", :size => 10, :at => [75, 530], :width => 240
    pdf.text_box "#{t('attributes.account.swift')}:", :size => 10, :at => [10, 515], :width => 240
    pdf.text_box "#{@invoice.account_swift} #{@invoice.address_street_number}", :size => 10, :at => [75, 515], :width => 240
    pdf.text_box "#{t('attributes.account.iban')}:", :size => 10, :at => [10, 500], :width => 240
    pdf.text_box "#{@invoice.account_iban}", :size => 10, :at => [75, 500], :width => 240
  end
else
  pdf.stroke_rounded_rectangle [0, 540], 270, 45, 6
  pdf.text_box t('keywords.payment'), :size => 10, :at => [10, 530], :width => 240
  pdf.text_box "Hotově", :size => 10, :at => [10, 515], :width => 240
end

# Info
pdf.stroke_rounded_rectangle [280, 540], 270, 45, 6
pdf.text_box "#{t('attributes.invoice.issue_date')}:", :size => 10, :at => [290, 530], :width => 240
pdf.text_box "#{l(@invoice.issue_date, :format => :invoice)}", :size => 10, :at => [390, 530], :width => 240
pdf.text_box "#{t('attributes.invoice.due_date')}:", :size => 10, :at => [290, 515], :width => 240
pdf.text_box "#{l(@invoice.due_date, :format => :invoice)}", :size => 10, :at => [390, 515], :width => 240

items = @invoice.items.map do |item|
  [
    item.name,
    item.number,
    item.unit,
    formatted_amount(item.price),
    formatted_amount(item.amount),
  ]
end

pdf.table(items, :headers =>
  [{:text => "Položka"},
   {:text => "Počet"},
   {:text => "MJ"},
   {:text => "Cena za položku"},
   {:text => "Částka"}]) do |table|

end

pdf.move_down(25)

pdf.text "#{formatted_amount(@invoice.amount, @invoice.account.currency_symbol)}", :size => 16, :style => :bold
