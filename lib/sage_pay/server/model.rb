
module SagePay
  class Model
    # For the ActiveRecord::Errors object.
    attr_accessor :errors

    def initialize(attributes = {})
      attributes.each do |k, v|
        send("#{k}=", v)
      end
      @errors = ActiveRecord::Errors.new(self)
    end

    # Stubs etc for validations
    def save; end
    def save!; end
    def new_record?; false; end
    def update_attribute; end
    include ActiveRecord::Validations

    # Yank stuff from AR::Base
    class << self
      def human_attribute_name(attribute_key_name, options = {})
        defaults = self_and_descendants_from_active_record.map do |klass|
          :"#{klass.name.underscore}.#{attribute_key_name}"
        end
        defaults << options[:default] if options[:default]
        defaults.flatten!
        defaults << attribute_key_name.to_s.humanize
        options[:count] ||= 1
        I18n.translate(defaults.shift, options.merge(:default => defaults, :scope => [:activerecord, :attributes]))
      end

      def human_name(options = {})
        defaults = self_and_descendants_from_active_record.map do |klass|
          :"#{klass.name.underscore}"
        end
        defaults << self.name.humanize
        I18n.translate(defaults.shift, {:scope => [:activerecord, :models], :count => 1, :default => defaults}.merge(options))
      end

      def self_and_descendants_from_active_record#nodoc:
        klass = self
        classes = [klass]
        while klass != klass.base_class
          classes << klass = klass.superclass
        end
        classes
      rescue
        # OPTIMIZE this rescue is to fix this test: ./test/cases/reflection_test.rb:56:in `test_human_name_for_column'
        # Appearantly the method base_class causes some trouble.
        # It now works for sure.
        [self]
      end
    end
  end
end
