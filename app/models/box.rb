class Box

require 'httparty'
	@dev_key = "1sxS5E4y5tSGrRkgA2njuPiC9JQWR6O6"
  @box_url = "https://api.box.com/2.0/folders/0" 
	FIXED_FIELDS = %w{name type owned_by created_at modified_at id}
	
	def self.populate
  	@box_content = []
  	@box_folders = []
  	@box_files = []
  	@box_files_info = []
  	@result = JSON::parse((HTTParty.get(@box_url, headers: {"Authorization" => "Bearer #{@dev_key}"})).body)

  	check_entries
  	check_files
  end

	def self.check_entries
		if @result['item_collection']['entries']
	    @result['item_collection']['entries'].each do |entry|
	      @box_content << entry
	      check_type(entry)
	    end
	  end
	end

	def self.check_type(entry)
		entry.each do |key,value|
		  case key
		  when "type"
		    if value == "folder"
		    	@box_folders << entry
		    end

		    if value == "file"
		    	@box_files << entry
		    end  
		  end
		end
	end


	def self.check_files
		file_info
  	@show_fields = FIXED_FIELDS + (@box_files_info.first.keys - FIXED_FIELDS)
	end

	def self.file_info
		@box_files.each do |file_hash|
			file_hash.each do |k, v|
				get_info(k,v)
			end
		end
	end

	def self.get_info(k,v)
		if k == "id"
			response = HTTParty.get("https://api.box.com/2.0/files/#{v}", headers: {"Authorization" => "Bearer #{@dev_key}"})
	    @box_files_info << JSON::parse(response.body)
		end
	end

	def self.box_content
		@box_content
	end

	def self.box_folders
		@box_folders
		
	end

	def self.show_fields
		@show_fields
		
	end

	def self.box_files
		@box_files
		
	end

	def self.box_files_info
		@box_files_info
		
	end

end