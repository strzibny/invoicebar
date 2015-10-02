InvoiceBar::Engine.routes.draw do
  # Sessions
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'login', to: 'sessions#new', as: 'login'
  get 'login_from_http_basic', to: 'sessions#login_from_http_basic', as: 'login_from_http_basic'

  resources :sessions

  # Search
  get 'search', to: 'search#index', as: 'search'

  # Users
  get 'signup', to: 'users#new', as: 'signup'
  get 'profile', to: 'settings#index', as: 'profile'

  resources :users

  # Contacts
  resources :contacts

  # Currencies
  resources :currencies

  # Accounts
  resources :accounts

  # Invoices
  get 'invoices/from_template/:id', to: 'invoices#from_template', as: 'invoice_from_template'
  get 'invoices/:id/mark_as_paid', to: 'invoices#mark_as_paid', as: 'mark_invoice_as_paid'
  get 'invoices/:id/mark_as_sent', to: 'invoices#mark_as_sent', as: 'mark_invoice_as_sent'
  get 'invoices/:id/create_receipt_for_invoice', to: 'invoices#create_receipt_for_invoice', as: 'create_receipt_for_invoice'
  get 'invoices/filter', to: 'invoices#filter', as: 'filter_invoices', method: :get
  get 'invoices/issued', to: 'invoices#issued', as: 'issued_invoices', method: :get
  get 'invoices/received', to: 'invoices#received', as: 'received_invoices', method: :get

  resources :invoices
  resources :invoice_templates

  # Receipts
  get 'receipts/from_template/:id', to: 'receipts#from_template', as: 'receipt_from_template'
  get 'receipts/filter', to: 'receipts#filter', as: 'filter_receipts', method: :get
  get 'receipts/income', to: 'receipts#income', as: 'income_receipts', method: :get
  get 'receipts/expence', to: 'receipts#expence', as: 'expence_receipts', method: :get

  resources :receipts
  resources :receipt_templates

  # Root default
  root to: 'dashboard#index'
end
