# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "json"
require "rest-client"

Job.destroy_all
Company.destroy_all
User.destroy_all

url_arr = [
  "https://phantombuster.s3.amazonaws.com/mkrBVUuON2g/CiKJ8wejbU5c89KJ4kzMYw/ProfileMongLinkedin.json",
  "https://phantombuster.s3.amazonaws.com/mkrBVUuON2g/tKu3CcI31b0fZgWH7RcB2g/ProfileMaloLinkedin.json",
  "https://phantombuster.s3.amazonaws.com/mkrBVUuON2g/QOzupxPxgRudOGY2odgk6Q/ProfileJustineLinkedin.json"
]

url_arr.each do |url|
  infos = JSON.parse(RestClient.get(url))

  user1 = User.new(
    first_name: infos[0]["general"]["firstName"],
    last_name: infos[0]["general"]["lastName"],
    gender: "female",
    description: infos[0]["general"]["description"],
    mbti: "super smart",
    city: infos[0]["general"]["location"],
    has_a_project: false,
    email: "#{infos[0]["general"]["lastName"]}@gmail.com",
    password: "123456"
  )
  user1.save!

  infos[0]["jobs"].first(3).each do |job|
    company1 = Company.new(
      industry: job["companyName"],
    )
    company1.save!

    job = Job.new(
      description: job["description"],
      title: job["jobTitle"],
      city: job["location"],
      year_experience: 1
    )

    job.user = user1
    job.company = company1

    job.save!
  end
end

def xp_calculation
  date_range = infos[0]["jobs"][num]["dateRange"]
  end_date = date_range.split(" - ")[1].split(" · ")[0]
  start_date = date_range.split(" - ")[0]
  Date.parse(end_date) - Date.parse(start_date)
end

# /(.*)\s-\s(.*)\s·/.match("Sep 2021 - Jan 2022 · 1 yrs 5 mos")
# matches = _
# matches[1]
# Date.today
