module ModelMatchers

  class HaveAssociation
    
    def initialize(association_name, options={})
      @association_name = association_name
      @options          = options
    end
  
    def matches?(model)
      @model = model
      
      assoc = model.reflect_on_association(@association_name)
      
      return false if assoc.nil?
      return false if @options.include?(:type)        && assoc.macro != @options[:type].to_sym
      return false if @options.include?(:polymorphic) && !assoc.options.include?(:polymorphic)
      true
    end
  
    def failure_message
      "expected #{message}"
    end
    
    def negative_failure_message
      "did not expect #{message}" 
    end
  
    private
    
    def message
      message = "#{@model} to have a"
      message << " polymorphic" if @options.include? :polymorphic
      message << " #{@options[:type]}" if @options.include? :type
      message << " #{@association_name} association"
      message << " through #{@options[:through]}" if @options.include? :through    
      message
    end
  
  end
  
  class BeValidWithout
    
    def initialize(*attributes)
      @attributes = attributes
    end
  
    def matches?(object)
      @object = object
      @attributes.each do |attr_name|
        object.send("#{attr_name}=", nil)
      end      
      object.valid?
    end
    
    def failure_message
      errs = @object.errors.collect{|e,m| "#{e} #{m}"}.join(', ')
      "expected to be valid without #{@attributes} (#{errs})"
    end
    
    def negative_failure_message
      "did not expect to be valid without #{@attributes}"
    end    
  
  end
  
  def have_association(association_name, options={})
    HaveAssociation.new(association_name, options)
  end

  def have_many(association_name, options={})
    HaveAssociation.new(association_name, options.merge({:type => :has_many}))
  end

  def belong_to(association_name, options={})
    HaveAssociation.new(association_name, options.merge({:type => :belongs_to}))
  end

  def have_and_belong_to_many(association_name, options={})
    HaveAssociation.new(association_name, options.merge({:type => :has_and_belongs_to_many}))
  end

  def have_one(association_name, options={})
    HaveAssociation.new(association_name, options.merge({:type => :has_one}))
  end

  def be_valid_without(*attributes)
    BeValidWithout.new(*attributes)
  end

end
