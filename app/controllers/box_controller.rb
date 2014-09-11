class BoxController < ApplicationController
	require 'httparty'

  FIXED_FIELDS = %w{name type owned_by created_at modified_at id}
  

  def index

   @dev_key = "RHidly12DGUgGqwCYEoVaSRhrQoxHuX4"
   @box_url = "https://api.box.com/2.0/folders/0" 

   @box_content = []
   @box_folders = []
   @box_files = []
   @box_files_info = []

   response = HTTParty.get(@box_url, headers: {"Authorization" => "Bearer #{@dev_key}"})
   @result = JSON::parse(response.body)

   if @result['item_collection']['entries']
    @result['item_collection']['entries'].each do |entry|
      @box_content << entry

      entry.each do |k,v|
        case k
        when "type"
          if v == "folder"
            @box_folders << entry
          end

          if v == "file"
            @box_files << entry
          end  

        end
      end
    end
  end 

  @box_files.each do |file_hash|
   file_hash.each do |k, v|
		# puts k + ":" + v
		if k == "id"
			#thumbnails = HTTParty.get("https://api.box.com/2.0/files/#{v}/thumbnail.png?min_height=256&min_width=256&max_height=256&max_width=256", headers: {"Authorization" => "Bearer #{dev_key}"})
			response = HTTParty.get("https://api.box.com/2.0/files/#{v}", headers: {"Authorization" => "Bearer #{@dev_key}"})
      files = JSON::parse(response.body)

      @box_files_info << files
     
		end
	end
  first_item_fields = @box_files_info.first.keys
  @show_fields = FIXED_FIELDS + (first_item_fields - FIXED_FIELDS)
end
end
end
