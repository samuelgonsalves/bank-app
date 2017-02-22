class Account < ApplicationRecord
	belongs_to :user
	has_many :transactions
	has_many :transfers
	after_create :reload
end
