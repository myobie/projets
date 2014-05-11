require 'securerandom'

class Array
  def random
    self[rand(length)]
  end
end

names = ["Kate", "Jack", "Hugo", "James",
         "John", "Sayid", "Jin-Soo",
         "Sun-Hwa", "Claire", "Charlie"]

users = names.each_with_object({}) do |name, h|
  h[name] = User.create({
    email: "#{name}@example.com",
    name: name
  })
end

accounts = names.each_with_object({}) do |name, h|
  h[name] = Account.create({
    name: "#{name}'s Projects Too",
    owner: users[name]
  })
end

accounts.each do |name, account|
  3.times do
    account.add_admin users.values.random
  end
end

project_names = ["The Hydra", "The Arrow",
                 "The Swan", "The Flame",
                 "The Pearl", "The Orchid",
                 "The Staff", "The Looking Glass",
                 "The Tempest", "The Lamp Post"]

projects = project_names.map do |name|
  accounts["Kate"].projects.create({
    name: name,
    owner: users["Kate"]
  })
end

files = {
  boy: Rails.root.join("db/data/boy.pdf"),
  girl: Rails.root.join("db/data/girl.pdf")
}

projects.each do |project|
  project.add_member users["Kate"]

  5.times do
    project.add_member users.values.random
  end

  discussion = project.discussions.create({
    name: "What do we do?",
    user: users["Kate"]
  })

  (users.values - [users["Kate"]]).each do |user|
    discussion.comments.create({
      content: "I really don't know.",
      user: user
    })
  end

  # attach the files to the discussion
  files.each do |name, pathname|
    user = project.members.random
    upload = Upload.create({
      user: user
    })

    url = URI(upload.generate_url)
    response = nil
    Net::HTTP.start(url.host, url.port, :use_ssl => true) do |http|
      req = Net::HTTP::Put.new(url.request_uri)
      req.body_stream = File.open(pathname)
      req['Content-Length'] = req.body_stream.size
      req['Content-Type'] = '' # Prevents Net::HTTP from adding content-type
      response = http.request(req)
      puts "Status code: #{response.code}"
      puts "Response body: #{response.body}"
    end

    if response.code == "204"
      upload.finish && upload.save

      attachment = discussion.attachments.create({
        original_filename: pathname.basename,
        size:              pathname.size,
        content_type:      "application/pdf",
        user:              user,
        upload:            upload
      })

      attachment.comments.create({
        content: "Oh wow",
        user: project.members.random
      })
    else
      puts "Upload of a file failed..."
    end
  end

  # attach the files to the project
  files.each do |name, pathname|
    user = project.members.random
    upload = Upload.create({
      user: user
    })

    url = URI(upload.generate_url)
    response = nil
    Net::HTTP.start(url.host, url.port, :use_ssl => true) do |http|
      req = Net::HTTP::Put.new(url.request_uri)
      req.body_stream = File.open(pathname)
      req['Content-Length'] = req.body_stream.size
      req['Content-Type'] = '' # Prevents Net::HTTP from adding content-type
      response = http.request(req)
      puts "Status code: #{response.code}"
      puts "Response body: #{response.body}"
    end

    if response.code == "204"
      upload.finish && upload.save

      attachment = project.attachments.create({
        original_filename: pathname.basename,
        size:              pathname.size,
        content_type:      "application/pdf",
        user:              user,
        upload:            upload
      })

      attachment.comments.create({
        content: "Oh wow",
        user: project.members.random
      })
    else
      puts "Upload of a file failed..."
    end
  end
end

50.times do
  project = projects.first
  name = 4.times.map { SecureRandom.urlsafe_base64 }.join(" ")
  discussion = project.discussions.create({
    name: name,
    user: project.members.random
  })

  50.times do
    content = 40.times.map { SecureRandom.urlsafe_base64 }.join(" ")
    discussion.comments.create({
      content: content,
      user: project.members.random
    })
  end
end
