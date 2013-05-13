require 'test/unit'
require 'rails'
require 'active_record'

if $LOAD_PATH.include?(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))
  require 'rails/alpha_numeric_validator'
else
  raise RuntimeError, "Try ruby -Ilib test/#{File.basename(__FILE__)}"
end

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

ActiveRecord::Schema.define(:version => 1) do
  create_table :models do |t|
    t.string :name
    t.string :organization
    t.string :favorite_quote
    t.string :server_name
    t.string :website
    t.string :id_code
  end
end

class Model < ActiveRecord::Base
  attr_accessible :name, :organization, :favorite_quote, :server_name, :website, :id_code
  validates :name, :alpha_numeric => true
  validates :organization, :alpha_numeric => {punctuation: :limited}
  validates :favorite_quote, :alpha_numeric => {punctuation: true, allow_nil: true, allow_blank: true}
  validates :server_name, :alpha_numeric => {punctuation: :dns}
  validates :website, :alpha_numeric => {punctuation: :fqdn}
  validates :id_code, :alpha_numeric => {allow_whitespace: false}
end

class AlphaNumericValidatorTest < Test::Unit::TestCase
  def validate_field(record, field, valid_values, invalid_values)
    original_value = record.send(field)
    assignment_method = "#{field}=".to_sym
    valid_values.each do |value|
      record.send(assignment_method, value)
      assert record.valid?
    end
    invalid_values.each do |value|
      record.send(assignment_method, value)
      assert !record.valid?
    end
    record.send(assignment_method, original_value)
  end

  def test_alpha_numeric_validation
    @model = Model.new(:name => 'Paul Belt', :organization => 'Hello Corp.', :favorite_quote => 'Hello world!',
      :server_name => 'hello-world', :website => 'hello-world.example.com', :id_code => 'abc123')
    assert @model.valid?
    validations = {name: [['Bob1 Jones2', 'abcdef'], ['Bob# Jones?', '!@#$!@']],
      organization: [["McDonald's", 'Yahoo!', 'ABC-DEF + GHI'], %w(A@B XYZ~3)],
      favorite_quote: [['This$is=a& good*string', '~!@#$%^&*()'], %W(Hello\x00)],
      server_name: [%w(hello1 abcdef), ['hello world', 'hello~world']],
      website: [%w(abc123.example.com example.com), ['he llo.example.com', 'my@site.com']],
      id_code: [%w(hello1 abcdef), ['hello world', 'hello-world']]}
    validations.each do |k, v|
      validate_field(@model, k, v[0], v[1])
    end
  end
end

