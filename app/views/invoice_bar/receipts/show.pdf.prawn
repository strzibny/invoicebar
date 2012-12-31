pdf.font_families.update("DejaVuSans" => {
	:normal => { :file => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"},
	:bold => { :file => "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"}
})

pdf.font("DejaVuSans")

unless @receipt.issuer
  pdf.text "Výdajový doklad", :size => 20
else
  pdf.text "Příjmový doklad", :size => 20
end

pdf.fill_color "666666" 
pdf.text_box "#{t('titles.number')} #{@receipt.number}", :size => 20, :at => [240, 720], :width => 300, :align => :right

pdf.move_down(250)

pdf.fill_color "000000" 

# User
pdf.stroke_color "BFBFBF" 
pdf.fill_color "BFBFBF" 
unless @receipt.issuer
  pdf.text_box "#{t('attributes.invoice.purchaser')}", :size => 10, :at => [10, 660], :width => 240
else
 pdf.text_box "#{t('attributes.invoice.provider')}", :size => 10, :at => [10, 660], :width => 240 
end
pdf.fill_color "000000" 
pdf.text_box "#{@receipt.user_name}", :size => 14, :at => [10, 640], :width => 240
pdf.text_box "#{@receipt.user_street}    #{@receipt.user_street_number}", :size => 10, :at => [10, 620], :width => 240
pdf.text_box "#{formatted_postcode(@receipt.user_postcode)}", :size => 10, :at => [10, 605], :width => 240
pdf.text_box "#{@receipt.user_city}", :size => 10, :at => [60, 605], :width => 240
pdf.text_box "#{@receipt.user_city_part}", :size => 10, :at => [60, 590], :width => 240
pdf.text_box "#{@receipt.user_extra_address_line}", :size => 10, :at => [10, 575], :width => 240

pdf.fill_color "666666" 
pdf.text_box "#{t('attributes.user.ic')}:    #{@receipt.user_ic}", :size => 10, :at => [10, 570], :width => 240

# Customer
pdf.fill_color "DBDAD9" 
unless @receipt.issuer
  pdf.text_box "#{t('attributes.invoice.provider')}", :size => 10, :at => [290, 660], :width => 240
else
  pdf.text_box "#{t('attributes.invoice.purchaser')}", :size => 10, :at => [290, 660], :width => 240
end
pdf.fill_color "000000" 
pdf.text_box "#{@receipt.contact_name}", :size => 14, :at => [290, 640], :width => 240
pdf.text_box "#{@receipt.address_street}    #{@receipt.address_street_number}", :size => 10, :at => [290, 620], :width => 240
pdf.text_box "#{formatted_postcode(@receipt.address_postcode)}", :size => 10, :at => [290, 605], :width => 240
pdf.text_box "#{@receipt.address_city}", :size => 10, :at => [340, 605], :width => 240
pdf.text_box "#{@receipt.address_city_part}", :size => 10, :at => [340, 590], :width => 240
pdf.text_box "#{@receipt.address_extra_address_line}", :size => 10, :at => [290, 575], :width => 240

move_down = 0

unless @receipt.address_city_part.blank?
  move_down += 15
end

unless @receipt.address_extra_address_line.blank?
  move_down += 15
end

pdf.stroke_rounded_rectangle [0, 670], 270, 120, 6
pdf.stroke_rounded_rectangle [280, 670], 270, 120, 6


pdf.fill_color "666666" 
if @receipt.contact_ic.blank? and @receipt.contact_dic.blank?
elsif not @receipt.contact_dic.blank?
  pdf.text_box "#{t('attributes.contact.dic')}:    #{@receipt.contact_dic}", :size => 10, :at => [290, 570-move_down], :width => 240
elsif not @receipt.contact_ic.blank?
  pdf.text_box "#{t('attributes.contact.ic')}:    #{@receipt.contact_ic}", :size => 10, :at => [290, 570-move_down], :width => 240
else
  pdf.text_box "#{t('attributes.contact.ic')}:    #{@receipt.contact_ic}    #{t('attributes.contact.dic')}:    #{@receipt.contact_dic}", :size => 10, :at => [290, 570], :width => 240
end
# Account
unless @receipt.account_bank_account_number.blank?  
  pdf.fill_color "666666" 
  
  if @receipt.account_swift.blank? or @receipt.account_swift.blank?
    pdf.stroke_rounded_rectangle [0, 540], 270, 45, 6
    pdf.text_box t('keywords.payment'), :size => 10, :at => [10, 530], :width => 240
    pdf.text_box "#{@receipt.account_name}", :size => 10, :at => [10, 515], :width => 240
  else 
    pdf.stroke_rounded_rectangle [0, 540], 270, 75, 6
    pdf.text_box t('keywords.payment'), :size => 10, :at => [10, 530], :width => 240
    pdf.text_box "#{t('models.account')}:", :size => 10, :at => [10, 530], :width => 240
    pdf.text_box "#{@receipt.account_bank_account_number}", :size => 10, :at => [75, 530], :width => 240
    pdf.text_box "#{t('attributes.account.swift')}:", :size => 10, :at => [10, 515], :width => 240
    pdf.text_box "#{@receipt.account_swift} #{@receipt.address_street_number}", :size => 10, :at => [75, 515], :width => 240
    pdf.text_box "#{t('attributes.account.iban')}:", :size => 10, :at => [10, 500], :width => 240
    pdf.text_box "#{@receipt.account_iban}", :size => 10, :at => [75, 500], :width => 240
  end
else
  pdf.stroke_rounded_rectangle [0, 540], 270, 45, 6
  pdf.text_box t('keywords.payment'), :size => 10, :at => [10, 530], :width => 240
  pdf.text_box "Hotově", :size => 10, :at => [10, 515], :width => 240
end

# Info
pdf.stroke_rounded_rectangle [280, 540], 270, 45, 6
pdf.text_box "#{t('attributes.invoice.issue_date')}:", :size => 10, :at => [290, 530], :width => 240
pdf.text_box "#{l(@receipt.issue_date, :format => :invoice)}", :size => 10, :at => [390, 530], :width => 240

items = @receipt.items.map do |item|
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

pdf.text "#{formatted_amount(@receipt.amount, @receipt.account.currency_symbol)}", :size => 16, :style => :bold