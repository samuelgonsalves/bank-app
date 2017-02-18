class Account < ApplicationRecord
	belongs_to :user
	has_many :transactions
	has_many :transfers
end
