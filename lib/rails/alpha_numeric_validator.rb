require File.expand_path(File.dirname(__FILE__) + '/alpha_numeric_validator/alpha_numeric_validator/parser.rb') # validate attributes have only alpha, numeric and whitespace
require 'rails/alpha_numeric_validator/version'
require 'rails/alpha_numeric_validator/parser'

class AlphaNumericValidator < ActiveModel::EachValidator
  include AlphaNumericValidator::Parser
end

