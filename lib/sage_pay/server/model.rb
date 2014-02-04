
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

    # Dummy stub to make validtions happy.
    def save
    end

    # Dummy stub to make validtions happy.
    def save!
    end

    # Dummy stub to make validtions happy.
    def new_record?
      false
    end

    # Dummy stub to make validtions happy.
    def update_attribute
    end

    # Mix in that validation goodness!
    include ActiveRecord::Validations

    def self.human_name
      name.humanize
    end
  end
end
