# Load the Rails application.
require_relative 'application'
require 'logger'

Rails.logger = Logger.new("log/#{Rails.env}.log")
Rails.logger.level = 0
Rails.logger.formatter = proc do |severity, datetime, progname, msg|
	date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
	"[#{date_format}] #{severity} --#{msg}\n"
end
# Initialize the Rails application.
Rails.application.initialize!
