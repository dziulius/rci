class UploadData
  attr_accessor :path

  def self.save(uploaded)
    temp_file = uploaded[:data_file]
    @path = File.join('public/uploads', temp_file.original_filename)
    file = File.open(@path, "wb") { |f| f.write(temp_file.read) }

  end
end
