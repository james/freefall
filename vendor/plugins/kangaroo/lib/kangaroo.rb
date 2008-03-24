# Kangaroo
module Kangaroo

	# Makes it possible to pass any has_one relationships as a hash within the params hash and it will save 
	# for you. eg, text_field_tag 'snippet[article][content]' would pass {snippet => {:article => {:content => 'value'}}} back to the controller, which could then pass it here.
	# This method then looks to see if there Snippet has a has_one relationship to Article. If it does, then
	# it goes ahead and creates the Article for you
	#
	# Find all has_one relationships and, if there is a corresponding hash in the params, add it to an 
	# external hash
  def save_with_related(params)
		associations = []
		self.class.reflect_on_all_associations(:has_one).each do |model|
	    if params[model.name]
				associations << {:name => model.name, :values => params[model.name]}
				# Delete the related model params from the hash to stop validation errors
				params.delete(model.name)
	    end
	  end
	
		transaction do
			# We can now save the record itself now we have stripped the params of related model info
			raise unless self.update_attributes(params)
			# And then create the appropiate related models, then save them into the parent model
			associations.each do |association|
				name = Inflector.titleize(association[:name])
				raise unless model_instance = Object.const_get(name).new(association[:values])
				raise unless self.update_attributes(association[:name] => model_instance)
			end
		end
	end

end