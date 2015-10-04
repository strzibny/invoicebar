module InvoiceBar

  # Module that provides +search_for+ method on a model class.
  # It expects +searchable_fields+ to be defined.
  # +searchable_fields+ contains the table fields of the model
  # (attributes) that should be searched.
  module Searchable
    extend ActiveSupport::Concern

    included do
      def self.search_for(query)
        where(self.build_search_query, query: "%#{query}%")
      end

      protected

        def self.build_search_query()
          @query = ''

          self.searchable_fields.each do |field|
            unless @query.blank?
              @query += ' OR '
            end

            @query += "#{field} LIKE :query"
          end

          @query
        end
    end
  end
end
