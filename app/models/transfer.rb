class Transfer < ApplicationRecord
	belongs_to :transaction, :account
end
