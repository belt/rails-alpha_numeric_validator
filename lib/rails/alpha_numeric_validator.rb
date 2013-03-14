# validate attributes have only alpha, numeric and whitespace
require 'rails/alpha_numeric_validator/version'

class AlphaNumericValidator < ActiveModel::EachValidator
  attr_accessor :string # :nodoc:

  PUNCTUATION_REGEXP = {
    :default => /(?:[[:alpha:]]|[[:digit:]])+/,
    :true => /(?:[[:graph:]])+/,
    :limited => /(?:[[:alpha:]]|[[:digit:]]|[_\+\.\?,\-!'\/#])+/,
    :dns => /(?:[[:alpha:]]|[[:digit:]]|\-)+/,
    :fqdn => /(?:[[:alpha:]]|[[:digit:]]|\-|\.)+/}

  # == Creation
  # To use the AlphaNumericsValidator, initialize it as any other class
  #
  #   class ExampleValidator < ActiveRecord::Base
  #     validates :attr1, :alpha_numerics => true
  #     validates :attr2, :alpha_numerics => { :punctuation => true }
  #     validates :attr3, :alpha_numerics => { :punctuation => :limited }
  #     validates :attr4, :alpha_numerics => { :allow_nil => false, :allow_blank => false }
  #     validates :attr4, :alpha_numerics => { :allow_whitespace => true }
  #     validates :attr4, :alpha_numerics => { :dns => true }
  #   end

  def initialize(*args) # :nodoc:
    @errors = []
    @record = nil
    super(*args)
  end

  # :call-seq:
  # validate_each :record, :attribute, :value
  #
  # <tt>:record</tt>:: AR instance
  # <tt>:attribute</tt>:: symbol for attribute
  # <tt>:value</tt>:: value to check validity

  def validate_each(record, attribute, value) #:nodoc:
    @record = record
    opts = {:allow_whitespace => ![:dns, :fqdn].member?(@options[:punctuation])}
    @options = opts.merge @options

    # TODO: document why value[1]
    @string = value.is_a?(Array) ? value[1] : value
    record.errors[attribute] << 'invalid characters' if !(@string.nil? || @string.class.ancestors.include?(Numeric) || is_valid?)
  end

  # :call-seq:
  # is_valid?
  #
  # alias for :is_valid_string?

  def is_valid?
    is_valid_string?
  end

  # :call-seq:
  # is_valid_string?
  #
  # returns true if the string only contains the requested character set
  #
  # TODO: support international DNS

  def is_valid_string?
    return true if @options[:allow_nil] && @string.nil?
    return false if !@options[:allow_blank] && @string.blank?
    return false if !@options[:allow_whitespace] && has_whitespace?
    re = PUNCTUATION_REGEXP[@options[:punctuation] ? @options[:punctuation].to_s.to_sym : :default]
    @string.to_s.gsub(re, "").blank?
  end

  # :call-seq:
  # has_whitespace?
  #
  # returns true if the string contains whitespace

  def has_whitespace?
    @string.to_s.match /(?:\s)+/
  end

end

