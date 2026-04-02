get "/files" do |env|
  stored_files = StoredFile.all
  notice = env.params.query["notice"]?
  error_message = env.params.query["error"]?

  render "src/views/files/index.ecr", "src/views/layouts/application.ecr"
end

post "/files/upload" do |env|
  unless env.params.files.has_key?("file")
    env.redirect "/files?error=Please+choose+a+file+to+upload."
    next ""
  end

  uploaded_file = env.params.files["file"]
  original_name = uploaded_file.filename || "upload"

  unless StoredFile.allowed_extension?(original_name)
    env.redirect "/files?error=Only+images,+PDF,+and+TXT+files+are+allowed."
    next ""
  end

  max_size = 10_i64 * 1024 * 1024
  extension = ::File.extname(original_name).downcase
  stored_name = "#{Random::Secure.hex(16)}#{extension}"
  destination = ::File.join(Kemal.config.public_folder, "uploads", stored_name)

  uploaded_file.tempfile.rewind
  copied_bytes = 0_i64

  ::File.open(destination, "w") do |file|
    copied_bytes = IO.copy(uploaded_file.tempfile, file)
  end

  if copied_bytes > max_size
    ::File.delete(destination) if ::File.exists?(destination)
    env.redirect "/files?error=File+size+must+be+10MB+or+smaller."
    next ""
  end

  mime_type = uploaded_file.headers["Content-Type"]? || "application/octet-stream"
  StoredFile.create(original_name, stored_name, mime_type, copied_bytes)

  env.redirect "/files?notice=File+uploaded+successfully."
end

get "/files/:id" do |env|
  stored_file = StoredFile.find(env.params.url["id"].to_i64)

  if stored_file
    render "src/views/files/show.ecr", "src/views/layouts/application.ecr"
  else
    env.response.status_code = 404
    "File not found"
  end
end

post "/files/:id/delete" do |env|
  stored_file = StoredFile.find(env.params.url["id"].to_i64)

  if stored_file
    ::File.delete(stored_file.storage_path) if ::File.exists?(stored_file.storage_path)
    stored_file.delete
    env.redirect "/files?notice=File+deleted+successfully."
  else
    env.response.status_code = 404
    "File not found"
  end
end
